unit utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs;

type

  { TFormUtama }

  TFormUtama = class(TForm)
    ButtonFlipVertical: TButton;
    ButtonFlipHorizontal: TButton;
    ButtonLoadImage: TButton;
    ImageSource: TImage;
    ImageResult: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonFlipHorizontalClick(Sender: TObject);
    procedure ButtonFlipVerticalClick(Sender: TObject);
    procedure ButtonLoadImageClick(Sender: TObject);
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
        ImageResult.Canvas.Pixels[x, y]:= RGB(bitmapTR[x, y], bitmapTG[x, y], bitmapTB[x, y])
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

end.

