unit utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtDlgs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonMeanConvolution: TButton;
    ButtonMeanCorrelation: TButton;
    ButtonLoadImage: TButton;
    EditKernel: TEdit;
    ImageResult: TImage;
    ImageSource: TImage;
    Label1: TLabel;
    Label2: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonLoadImageClick(Sender: TObject);
    procedure ButtonMeanCorrelationClick(Sender: TObject);
  private
    procedure InitKernelMean(size: integer);
    procedure PaddingBitmap();
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses
  windows, math;

var
  bitmapR, bitmapG, bitmapB: array[0..1000, 0..1000] of byte;
  paddingR, paddingG, paddingB: array[0..1000, 0..1000] of double;
  kernelMean: array[1..100, 1..100] of double;

  initWidth, initHeight: integer;

procedure TForm1.ButtonLoadImageClick(Sender: TObject);
var
  x, y: integer;
begin
  if OpenPictureDialog1.Execute = True then
  begin
    ImageSource.Picture.LoadFromFile(OpenPictureDialog1.FileName);

    initWidth:= ImageSource.Width;
    initHeight:= ImageSource.Height;

    for y:= 0 to ImageSource.Height-1 do
    begin
      for x:= 0 to ImageSource.Width-1 do
      begin
        bitmapR[x, y]:= Red(ImageSource.Canvas.Pixels[x, y]);
        bitmapG[x, y]:= Green(ImageSource.Canvas.Pixels[x, y]);
        bitmapB[x, y]:= Blue(ImageSource.Canvas.Pixels[x, y]);
      end;
    end;
  end;
end;

procedure TForm1.PaddingBitmap();
var
  x, y: integer;
begin
  for y:= 0 to initHeight+1 do
  begin
    paddingR[0, y]:= 128;
    paddingR[initWidth+1, y]:= 128;

    paddingG[0, y]:= 0;
    paddingG[initWidth+1, y]:= 128;

    paddingB[0, y]:= 0;
    paddingB[initWidth+1, y]:= 128;
  end;

  for x:= 0 to initWidth+1 do
  begin
    paddingR[x, 0]:= 128;
    paddingR[x, initHeight+1]:= 128;

    paddingG[x, 0]:= 128;
    paddingG[x, initHeight+1]:= 128;

    paddingB[x, 0]:= 128;
    paddingB[x, initHeight+1]:= 128;
  end;

  for y:= 1 to initHeight do
  begin
    for x:= 1 to initWidth do
    begin
      paddingR[x, y]:= bitmapR[x-1, y-1];
      paddingG[x, y]:= bitmapG[x-1, y-1];
      paddingB[x, y]:= bitmapB[x-1, y-1];
    end;
  end;
end;

procedure TForm1.InitKernelMean(size: integer);
var
  x, y: integer;
begin
  for y:= 1 to size do
  begin
    for x:= 1 to size do
    begin
      kernelMean[x, y]:= 1 / (size*size);
    end;
  end;
end;

procedure TForm1.ButtonMeanCorrelationClick(Sender: TObject);
var
  x, y, xK, yK: integer;
  cBR, cBG, cBB: array[0..1000, 0..1000] of integer;
  cR, cG, cB: double;
  size: integer;
begin
  ImageResult.Width:= initWidth;
  ImageResult.Height:= initHeight;
  size:= StrToInt(EditKernel.Text);
  InitKernelMean(size);
  PaddingBitmap();

  for y:= 1 to initHeight do
  begin
    for x:= 1 to initWidth do
    begin
      cBR[x-1, y-1]:= 0;
      cBG[x-1, y-1]:= 0;
      cBB[x-1, y-1]:= 0;
      cR:= 0;
      cG:= 0;
      cB:= 0;
      for yK:= 1 to size do
      begin
        for xK:= 1 to size do
        begin
          cR:= cR + (paddingR[x+(xK-size+1), y+(yK-size+1)] * kernelMean[xK, yK]);
          cG:= cG + (paddingG[x+(xK-size+1), y+(yK-size+1)] * kernelMean[xK, yK]);
          cB:= cB + (paddingB[x+(xK-size+1), y+(yK-size+1)] * kernelMean[xK, yK]);
        end;
      end;

      cBR[x-1, y-1]:= Round(cR);
      cBG[x-1, y-1]:= Round(cG);
      cBB[x-1, y-1]:= Round(cB);

      if cBR[x-1, y-1] < 0 then
        cBR[x-1, y-1]:= 0
      else if cBR[x-1, y-1] > 255 then
        cBR[x-1, y-1]:= 255;

      if cBG[x-1, y-1] < 0 then
        cBG[x-1, y-1]:= 0
      else if cBG[x-1, y-1] > 255 then
        cBG[x-1, y-1]:= 255;

      if cBB[x-1, y-1] < 0 then
        cBB[x-1, y-1]:= 0
      else if cBB[x-1, y-1] > 255 then
        cBB[x-1, y-1]:= 255;
    end;
  end;

  for y:= 0 to initHeight-1 do
  begin
    for x:= 0 to initWidth-1 do
    begin
      ImageResult.Canvas.Pixels[x, y]:= RGB(cBR[x, y], cBG[x, y], cBB[x, y]);
    end;
  end;

end;

end.

