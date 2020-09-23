unit utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs;

type

  { TFormUtama }

  TFormUtama = class(TForm)
    ButtonInterpolation: TButton;
    ButtonReplicate: TButton;
    ButtonFlipVertical: TButton;
    ButtonFlipHorizontal: TButton;
    ButtonLoadImage: TButton;
    EditScale: TEdit;
    ImageSource: TImage;
    ImageResult: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonFlipHorizontalClick(Sender: TObject);
    procedure ButtonFlipVerticalClick(Sender: TObject);
    procedure ButtonInterpolationClick(Sender: TObject);
    procedure ButtonLoadImageClick(Sender: TObject);
    procedure ButtonReplicateClick(Sender: TObject);
  private
    procedure ShowTransformImage();
    procedure SaveTransformImage();
  public

  end;

var
  FormUtama: TFormUtama;

implementation

{$R *.lfm}

{ TFormUtama }

uses
  windows;

var
  bitmapR, bitmapG, bitmapB : array[0..1000, 0..1000] of byte;
  bitmapTR, bitmapTG, bitmapTB : array[0..1000, 0..1000] of byte;
  bitmapSR, bitmapSG, bitmapSB : array[0..1000, 1..1000] of byte;
  initialWidth, initialHeight: integer;

procedure TFormUtama.ButtonLoadImageClick(Sender: TObject);
var
  x, y: integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    ImageSource.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    initialWidth:= ImageSource.Width;
    initialHeight:= ImageSource.Height;
    for y:= 0 to initialHeight-1 do
    begin
      for x:= 0 to initialWidth-1 do
      begin
        bitmapR[x, y]:= GetRValue(ImageSource.Canvas.Pixels[x, y]);
        bitmapG[x, y]:= GetGValue(ImageSource.Canvas.Pixels[x, y]);
        bitmapB[x, y]:= GetBValue(ImageSource.Canvas.Pixels[x, y]);

        bitmapSR[x, y]:= GetRValue(ImageSource.Canvas.Pixels[x, y]);
        bitmapSG[x, y]:= GetGValue(ImageSource.Canvas.Pixels[x, y]);
        bitmapSB[x, y]:= GetBValue(ImageSource.Canvas.Pixels[x, y]);
      end;
    end;
  end;
end;

procedure TFormUtama.ButtonReplicateClick(Sender: TObject);
var
  scaleCoef: integer;
  tempPosX, tempPosY: integer;
  kY, kX, x, y: integer;
begin
  scaleCoef:= StrToInt(EditScale.Text);
  ImageResult.Width:= initialWidth * scaleCoef;
  ImageResult.Height:= initialHeight * scaleCoef;
  tempPosX:= 0;
  tempPosY:= 0;
  for y:= 0 to initialHeight-1 do
  begin
    for x:= 0 to initialWidth-1 do
    begin
      for kY:= 0 to scaleCoef-1 do
      begin
        for kX:= 0 to scaleCoef-1 do
        begin
          ImageResult.Canvas.Pixels[tempPosX+kX, tempPosY+kY]:= RGB(bitmapR[x, y], bitmapG[x, y], bitmapB[x, y]);
        end;
      end;
      tempPosX:= tempPosX + scaleCoef;
    end;
    tempPosX:= 0;
    tempPosY:= tempPosY + scaleCoef;
  end;
end;

procedure TFormUtama.ShowTransformImage();
var
  x, y: integer;
begin
  ImageResult.Width:= initialWidth;
  ImageResult.Height:= initialHeight;

  for y:= 0 to initialHeight-1 do
  begin
    for x:= 0 to initialWidth-1 do
    begin
      ImageResult.Canvas.Pixels[x, y]:= RGB(bitmapTR[x, y], bitmapTG[x, y], bitmapTB[x, y]);
    end;
  end;
end;

procedure TFormUtama.SaveTransformImage();
var
  x, y: integer;
begin
  for y:= 0 to initialHeight-1 do
  begin
    for x:= 0 to initialWidth-1 do
    begin
      bitmapSR[x, y]:= bitmapTR[x, y];
      bitmapSG[x, y]:= bitmapTG[x, y];
      bitmapSB[x, y]:= bitmapTB[x, y];
    end;
  end;
end;

procedure TFormUtama.ButtonFlipHorizontalClick(Sender: TObject);
var
  x, y: integer;
begin
  for y:= 0 to initialHeight-1 do
  begin
    for x:= 0 to initialWidth-1 do
    begin
      bitmapTR[initialWidth-1-x, y]:= bitmapSR[x, y];
      bitmapTG[initialWidth-1-x, y]:= bitmapSG[x, y];
      bitmapTB[initialWidth-1-x, y]:= bitmapSB[x, y];
    end;
  end;
  SaveTransformImage();
  ShowTransformImage();
end;

procedure TFormUtama.ButtonFlipVerticalClick(Sender: TObject);
var
  x, y: integer;
begin
  for y:= 0 to initialHeight-1 do
  begin
    for x:= 0 to initialWidth-1 do
    begin
      bitmapTR[x, initialHeight-1-y]:= bitmapSR[x, y];
      bitmapTG[x, initialHeight-1-y]:= bitmapSG[x, y];
      bitmapTB[x, initialHeight-1-y]:= bitmapSB[x, y];
    end;
  end;
  SaveTransformImage();
  ShowTransformImage();
end;

procedure TFormUtama.ButtonInterpolationClick(Sender: TObject);
var
  x, y, i: integer;
  stepR, stepG, stepB: integer;
  scaleCoef: integer;
  R, G, B: byte;
  R1, R2, G1, G2, B1, B2: integer;
begin
  scaleCoef:= StrToInt(EditScale.Text);
  ImageResult.Width:= initialWidth * scaleCoef;
  ImageResult.Height:= initialHeight * scaleCoef;

  for y:= 0 to initialHeight-1 do
  begin
    for x:= 0 to initialWidth-1 do
    begin
      stepR:= round((bitmapR[x+1, y] - bitmapR[x, y])/scaleCoef);
      stepG:= round((bitmapG[x+1, y] - bitmapG[x, y])/scaleCoef);
      stepB:= round((bitmapB[x+1, y] - bitmapB[x, y])/scaleCoef);
      ImageResult.Canvas.Pixels[x*scaleCoef, y*scaleCoef]:= RGB(bitmapR[x, y], bitmapG[x, y], bitmapB[x, y]);
      for i:= 1 to scaleCoef-1 do
      begin
        R:= bitmapR[x, y] + (i * stepR);
        G:= bitmapG[x, y] + (i * stepG);
        B:= bitmapB[x, y] + (i * stepB);
        ImageResult.Canvas.Pixels[x*scaleCoef+i, y*scaleCoef]:= RGB(R, G, B);
      end;
    end;
  end;
  for x:= 0 to initialWidth*scaleCoef-1 do
  begin
    for y:= 0 to initialHeight-1 do
    begin
      R1:= Red(ImageResult.Canvas.Pixels[x, y*scaleCoef]);
      R2:= Red(ImageResult.Canvas.Pixels[x, (y+1)*scaleCoef]);

      G1:= Green(ImageResult.Canvas.Pixels[x, y*scaleCoef]);
      G2:= Green(ImageResult.Canvas.Pixels[x, (y+1)*scaleCoef]);

      B1:= Blue(ImageResult.Canvas.Pixels[x, y*scaleCoef]);
      B2:= Blue(ImageResult.Canvas.Pixels[x, (y+1)*scaleCoef]);

      stepR:= round((R2 - R1)/scaleCoef);
      stepG:= round((G2 - G1)/scaleCoef);
      stepB:= round((B2 - B1)/scaleCoef);
      for i:= 1 to scaleCoef-1 do
      begin
        R:= R1 + (i * stepR);
        G:= G1 + (i * stepG);
        B:= B1 + (i * stepB);
        ImageResult.Canvas.Pixels[x, y*scaleCoef+i]:= RGB(R, G, B);
      end;
    end;
  end;
end;

end.

