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
    procedure InitKernelMean(size: integer);
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
  windows, math;

var
  bitmapR, bitmapG, bitmapB: array[0..1000, 0..1000] of byte;
  bitmapGray: array[0..1000, 0..1000] of byte;
  paddingR, paddingG, paddingB: array[0..1000, 0..1000] of double;
  paddingGray: array[0..1000, 0..1000] of double;
  kernelMean: array[0..100, 0..100] of double;

  initWidth, initHeight: integer;


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
  size: integer;
begin
  ImageResult.Width:= initWidth;
  ImageResult.Height:= initHeight;

  ImageSketch.Width:= initWidth;
  ImageSketch.Height:= initHeight;

  size:= StrToInt(EditKernel.Text);
  InitKernelMean(size);
  PaddingBitmap();

  if RadioColorMode.ItemIndex = 1 then
  begin
    for y:= 1 to initHeight do
    begin
      for x:= 1 to initWidth do
      begin
        cR:= 0;
        cG:= 0;
        cB:= 0;
        for yK:= 1 to size do
        begin
          for xK:= 1 to size do
          begin
            cR:= cR + (paddingR[x-(xK-size+1), y-(yK-size+1)] * kernelMean[xK, yK]);
            cG:= cG + (paddingG[x-(xK-size+1), y-(yK-size+1)] * kernelMean[xK, yK]);
            cB:= cB + (paddingB[x-(xK-size+1), y-(yK-size+1)] * kernelMean[xK, yK]);
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
  end
  else if RadioColorMode.ItemIndex = 0 then
  begin
    for y:= 1 to initHeight do
    begin
      for x:= 1 to initWidth do
      begin
        cGray:= 0;
        for yK:= 1 to size do
        begin
          for xK:= 1 to size do
          begin
            cGray:= cGray + (paddingGray[x-(xK-size+1), y-(yK-size+1)] * kernelMean[xK, yK]);
          end;
        end;

        cGrayB[x-1, y-1]:= Constrain(Round(cGray));
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
  x, y: integer;
begin
  if RadioColorMode.ItemIndex = 1 then
  begin
    for y:= 0 to initHeight+1 do
    begin
      paddingR[0, y]:= 255;
      paddingR[initWidth+1, y]:= 255;

      paddingG[0, y]:= 255;
      paddingG[initWidth+1, y]:= 255;

      paddingB[0, y]:= 255;
      paddingB[initWidth+1, y]:= 255;
    end;

    for x:= 0 to initWidth+1 do
    begin
      paddingR[x, 0]:= 255;
      paddingR[x, initHeight+1]:= 255;

      paddingG[x, 0]:= 255;
      paddingG[x, initHeight+1]:= 255;

      paddingB[x, 0]:= 255;
      paddingB[x, initHeight+1]:= 255;
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
  end
  else if RadioColorMode.ItemIndex = 0 then
  begin
    for y:= 0 to initHeight+1 do
    begin
      paddingGray[0, y]:= 127;
      paddingGray[initWidth+1, y]:= 127;
    end;

    for x:= 0 to initWidth+1 do
    begin
      paddingGray[x, 0]:= 127;
      paddingGray[x, initHeight+1]:= 127;
    end;

    for y:= 1 to initHeight do
    begin
      for x:= 1 to initWidth do
      begin
        paddingGray[x, y]:= bitmapR[x-1, y-1];
      end;
    end;
  end;
end;

procedure TForm1.InitKernelMean(size: integer);
var
  x, y: integer;
begin
  if RadioPassFilter.ItemIndex = 2 then
  begin
    for y:= 1 to size do
    begin
      for x:= 1 to size do
      begin
        kernelMean[x, y]:= 1 / (size*size);
      end;
    end;
  end
  else
  begin
    for y:= 1 to size do
    begin
      for x:= 1 to size do
      begin
        kernelMean[x, y]:= -1;
      end;
    end;
    if RadioPassFilter.ItemIndex = 0 then
      kernelMean[size div 2, size div 2]:= (size*size) - 1
    else if RadioPassFilter.ItemIndex = 1 then
      kernelMean[size div 2, size div 2]:= (size*size);
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

