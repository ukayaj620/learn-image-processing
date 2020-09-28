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
    ImageSketch: TImage;
    ImageSource: TImage;
    Label1: TLabel;
    Label2: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    RadioColorMode: TRadioGroup;
    RadioPassFilter: TRadioGroup;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonLoadImageClick(Sender: TObject);
    procedure ButtonMeanConvolutionClick(Sender: TObject);
    procedure ButtonMeanCorrelationClick(Sender: TObject);
  private
    procedure InitKernelMean();
    procedure PaddingBitmap();
    function Constrain(value: integer): byte;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses
  windows;

var
  bitmapR, bitmapG, bitmapB: array[0..1000, 0..1000] of byte;
  bitmapGray: array[0..1000, 0..1000] of byte;
  paddingR, paddingG, paddingB: array[0..1000, 0..1000] of double;
  paddingGray: array[0..1000, 0..1000] of double;
  kernelMean: array[0..100, 0..100] of double;

  initWidth, initHeight: integer;
  k, kHalf: integer;


function TForm1.Constrain(value: integer): byte;
begin
  if value < 0 then Constrain := 0
  else if value > 255 then Constrain := 255
  else Constrain := value;
end;

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

        bitmapGray[x, y]:= (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;
      end;
    end;
  end;
end;

procedure TForm1.ButtonMeanConvolutionClick(Sender: TObject);
var
  x, y, xK, yK: integer;
  cBR, cBG, cBB, cGrayB: array[0..1000, 0..1000] of integer;
  cR, cG, cB, cGray: double;
begin
  ImageResult.Width:= initWidth;
  ImageResult.Height:= initHeight;

  ImageSketch.Width:= initWidth;
  ImageSketch.Height:= initHeight;

  k:= StrToInt(EditKernel.Text);
  kHalf:= k div 2;
  InitKernelMean();
  PaddingBitmap();

  if RadioColorMode.ItemIndex = 1 then
  begin
    for y:= kHalf to (initHeight+kHalf) do
    begin
      for x:= kHalf to (initWidth+kHalf) do
      begin
        cR:= 0;
        cG:= 0;
        cB:= 0;
        for yK:= 1 to k do
        begin
          for xK:= 1 to k do
          begin
            cR:= cR + (paddingR[x-(xK- k + kHalf), y-(yK - k + kHalf)] * kernelMean[xK, yK]);
            cG:= cG + (paddingG[x-(xK- k + kHalf), y-(yK - k + kHalf)] * kernelMean[xK, yK]);
            cB:= cB + (paddingB[x-(xK- k + kHalf), y-(yK - k + kHalf)] * kernelMean[xK, yK]);
          end;
        end;

        cBR[x-kHalf, y-kHalf]:= Constrain(Round(cR));
        cBG[x-kHalf, y-kHalf]:= Constrain(Round(cG));
        cBB[x-kHalf, y-kHalf]:= Constrain(Round(cB));
      end;
    end;

    for y:= 0 to initHeight-1 do
    begin
      for x:= 0 to initWidth-1 do
      begin
        ImageResult.Canvas.Pixels[x, y]:= RGB(cBR[x, y], cBG[x, y], cBB[x, y]);
      end;
    end;

  end
  else if RadioColorMode.ItemIndex = 0 then
  begin
    for y:= kHalf to (initHeight+kHalf) do
    begin
      for x:= kHalf to (initWidth+kHalf) do
      begin
        cGray:= 0;
        for yK:= 1 to k do
        begin
          for xK:= 1 to k do
          begin
            cGray:= cGray + (paddingGray[x-(xK- k + kHalf), y-(yK - k + kHalf)] * kernelMean[xK, yK]);
          end;
        end;

        cGrayB[x-kHalf, y-kHalf]:= Constrain(Round(cGray));
      end;
    end;

    for y:= 0 to initHeight-1 do
    begin
      for x:= 0 to initWidth-1 do
      begin
        ImageResult.Canvas.Pixels[x, y]:= RGB(cGrayB[x, y], cGrayB[x, y], cGrayB[x, y]);
        ImageSketch.Canvas.Pixels[x, y]:= RGB(255-cGrayB[x, y], 255-cGrayB[x, y], 255-cGrayB[x, y]);
      end;
    end;
  end;

end;

procedure TForm1.PaddingBitmap();
var
  x, y, z: integer;
begin;
  if RadioColorMode.ItemIndex = 1 then
  begin
    for y:= 0 to initHeight+kHalf  do
    begin
      for z:= 0 to kHalf-1 do
      begin
        paddingR[0+z, y]:= 255;
        paddingR[initWidth+kHalf+z, y]:= 255;

        paddingG[0+z, y]:= 255;
        paddingG[initWidth+kHalf+z, y]:= 255;

        paddingB[0+z, y]:= 255;
        paddingB[initWidth+kHalf+z, y]:= 255;
      end;
    end;

    for x:= 0 to initWidth+kHalf do
    begin
      for z:= 0 to kHalf-1 do
      begin
        paddingR[x, 0+z]:= 255;
        paddingR[x, initHeight+kHalf+z]:= 255;

        paddingG[x, 0+z]:= 255;
        paddingG[x, initHeight+kHalf+z]:= 255;

        paddingB[x, 0+z]:= 255;
        paddingB[x, initHeight+kHalf+z]:= 255;
      end;
    end;

    for y:= kHalf to (initHeight+kHalf-1) do
    begin
      for x:= kHalf to (initWidth+kHalf-1) do
      begin
        paddingR[x, y]:= bitmapR[x-kHalf, y-kHalf];
        paddingG[x, y]:= bitmapG[x-kHalf, y-kHalf];
        paddingB[x, y]:= bitmapB[x-kHalf, y-kHalf];
      end;
    end;
  end
  else if RadioColorMode.ItemIndex = 0 then
  begin
    for y:= 0 to initHeight+kHalf do
    begin
      for z:= 0 to kHalf-1 do
      begin
        paddingGray[0+z, y]:= 255;
        paddingGray[initWidth+kHalf+z, y]:= 255;
      end;
    end;

    for x:= 0 to initWidth+kHalf do
    begin
      for z:= 0 to kHalf-1 do
      begin
        paddingGray[x, 0+z]:= 255;
        paddingGray[x, initHeight+kHalf+z]:= 255;
      end;
    end;

    for y:= kHalf to (initHeight+kHalf-1) do
    begin
      for x:= kHalf to (initWidth+kHalf-1) do
      begin
        paddingGray[x, y]:= bitmapGray[x-kHalf, y-kHalf];
      end;
    end;
  end;

end;

procedure TForm1.InitKernelMean();
var
  x, y: integer;
begin
  if RadioPassFilter.ItemIndex = 2 then
  begin
    for y:= 1 to k do
    begin
      for x:= 1 to k do
      begin
        kernelMean[x, y]:= 1 / (k*k);
      end;
    end;
  end
  else
  begin
    for y:= 1 to k do
    begin
      for x:= 1 to k do
      begin
        kernelMean[x, y]:= -1;
      end;
    end;
    if RadioPassFilter.ItemIndex = 0 then
      kernelMean[kHalf, kHalf]:= (k*k) - 1
    else if RadioPassFilter.ItemIndex = 1 then
      kernelMean[kHalf, kHalf]:= (k*k);
  end;
end;

procedure TForm1.ButtonMeanCorrelationClick(Sender: TObject);
var
  x, y, xK, yK: integer;
  cBR, cBG, cBB: array[0..1000, 0..1000] of integer;
  cR, cG, cB: double;
begin
  ImageResult.Width:= initWidth;
  ImageResult.Height:= initHeight;
  k:= StrToInt(EditKernel.Text);
  InitKernelMean();
  PaddingBitmap();

  for y:= 1 to initHeight do
  begin
    for x:= 1 to initWidth do
    begin
      cR:= 0;
      cG:= 0;
      cB:= 0;
      for yK:= 1 to k do
      begin
        for xK:= 1 to k do
        begin
          cR:= cR + (paddingR[x+(xK-k+1), y+(yK-k+1)] * kernelMean[xK, yK]);
          cG:= cG + (paddingG[x+(xK-k+1), y+(yK-k+1)] * kernelMean[xK, yK]);
          cB:= cB + (paddingB[x+(xK-k+1), y+(yK-k+1)] * kernelMean[xK, yK]);
        end;
      end;

      cBR[x-1, y-1]:= Constrain(Round(cR));
      cBG[x-1, y-1]:= Constrain(Round(cG));
      cBB[x-1, y-1]:= Constrain(Round(cB));
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

