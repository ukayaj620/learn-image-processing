unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs;

type
  Channel = record
    R, G, B: Byte;
  end;

type
  BitmapColor = array [0..1000, 0..1000] of Channel;

type
  BitmapBinary = array [0..1000, 0..1000] of Boolean;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonMagic: TButton;
    ButtonSave: TButton;
    ButtonLoad1: TButton;
    ButtonLoad2: TButton;
    ButtonLoad3: TButton;
    ImageTexture1: TImage;
    ImageTexture2: TImage;
    ImagePattern: TImage;
    ImageResult: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonLoad1Click(Sender: TObject);
    procedure ButtonLoad2Click(Sender: TObject);
    procedure ButtonLoad3Click(Sender: TObject);
    procedure ButtonMagicClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  private
    procedure Binarization();
    procedure MergeTexture();
    function MergePatternWithTexture(Texture: BitmapColor; Binary: BitmapBinary): BitmapColor;
    function InversBinaryImage(Binary: BitmapBinary): BitmapBinary;

  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

uses
  windows;

var
   BitmapImage, BitmapTexture1, BitmapTexture2: BitmapColor;
   BitmapBinaryImage: BitmapBinary;
   imageWidth, imageHeight: Integer;


procedure TFormMain.ButtonLoad1Click(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    ImagePattern.Picture.LoadFromFile(OpenPictureDialog1.FileName);

    imageWidth:= ImagePattern.Width;
    imageHeight:= ImagePattern.Height;

    ImageTexture1.Width:= imageWidth;
    ImageTexture1.Height:= imageHeight;

    ImageTexture2.Width:= imageWidth;
    ImageTexture2.Height:= imageHeight;

    for y:= 1 to imageHeight do
    begin
      for x:= 1 to imageWidth do
      begin
        BitmapImage[x, y].R:= GetRValue(ImagePattern.Canvas.Pixels[x-1, y-1]);
        BitmapImage[x, y].G:= GetGValue(ImagePattern.Canvas.Pixels[x-1, y-1]);
        BitmapImage[x, y].B:= GetBValue(ImagePattern.Canvas.Pixels[x-1, y-1]);
      end;
    end;
  end;
  Binarization();
end;

procedure TFormMain.ButtonLoad2Click(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    ImageTexture1.Picture.LoadFromFile(OpenPictureDialog1.FileName);

    for y:= 1 to imageHeight do
    begin
      for x:= 1 to imageWidth do
      begin
        BitmapTexture1[x, y].R:= GetRValue(ImageTexture1.Canvas.Pixels[x-1, y-1]);
        BitmapTexture1[x, y].G:= GetGValue(ImageTexture1.Canvas.Pixels[x-1, y-1]);
        BitmapTexture1[x, y].B:= GetBValue(ImageTexture1.Canvas.Pixels[x-1, y-1]);
      end;
    end;
  end;
end;

procedure TFormMain.ButtonLoad3Click(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    ImageTexture2.Picture.LoadFromFile(OpenPictureDialog1.FileName);

    for y:= 1 to imageHeight do
    begin
      for x:= 1 to imageWidth do
      begin
        BitmapTexture2[x, y].R:= GetRValue(ImageTexture2.Canvas.Pixels[x-1, y-1]);
        BitmapTexture2[x, y].G:= GetGValue(ImageTexture2.Canvas.Pixels[x-1, y-1]);
        BitmapTexture2[x, y].B:= GetBValue(ImageTexture2.Canvas.Pixels[x-1, y-1]);
      end;
    end;
  end;
end;

procedure TFormMain.ButtonMagicClick(Sender: TObject);
var
  TempBitmap1, TempBitmap2: BitmapColor;
  x, y: Integer;
begin
  ImageResult.Width:= imageWidth;
  ImageResult.Height:= imageHeight;

  TempBitmap1:= MergePatternWithTexture(BitmapTexture1, BitmapBinaryImage);
  TempBitmap2:= MergePatternWithTexture(BitmapTexture2, InversBinaryImage(BitmapBinaryImage));
  for y:= 1 to imageHeight do
  begin
    for x:= 1 to imageWidth do
    begin
      ImageResult.Canvas.Pixels[x-1, y-1]:= RGB(
        TempBitmap1[x, y].R + TempBitmap2[x, y].R,
        TempBitmap1[x, y].G + TempBitmap2[x, y].G,
        TempBitmap1[x, y].B + TempBitmap2[x, y].B
      );
    end;
  end;
end;

procedure TFormMain.Binarization();
var
  x, y: Integer;
  gray: Integer;
begin
  for y:= 1 to imageHeight do
  begin
    for x:= 1 to imageWidth do
    begin
      gray:= (BitmapImage[x, y].R + BitmapImage[x, y].G + BitmapImage[x, y].B) div 3;
      if gray >= 36 then
      begin
        BitmapBinaryImage[x, y]:= true;
      end
      else
      begin
        BitmapBinaryImage[x, y]:= false;
      end;
    end;
  end;
end;

procedure TFormMain.MergeTexture();
begin

end;

function TFormMain.MergePatternWithTexture(Texture: BitmapColor; Binary: BitmapBinary): BitmapColor;
var
  x, y: Integer;
  BitmapTemp: BitmapColor;
begin
  for y:= 1 to imageHeight do
  begin
    for x:= 1 to imageWidth do
    begin
      if Binary[x, y] then
      begin
        BitmapTemp[x, y].R:= Texture[x, y].R * 1;
        BitmapTemp[x, y].G:= Texture[x, y].G * 1;
        BitmapTemp[x, y].B:= Texture[x, y].B * 1;
      end
      else
      begin
        BitmapTemp[x, y].R:= 0;
        BitmapTemp[x, y].G:= 0;
        BitmapTemp[x, y].B:= 0;
      end;
    end;
  end;
  MergePatternWithTexture:= BitmapTemp;
end;

function TFormMain.InversBinaryImage(Binary: BitmapBinary): BitmapBinary;
var
  x, y: Integer;
  BitmapTemp: BitmapBinary;
begin
  for y:= 1 to imageHeight do
  begin
    for x:= 1 to imageWidth do
    begin
      BitmapTemp[x, y]:= not Binary[x, y];
    end;
  end;
  InversBinaryImage:= BitmapTemp;
end;

procedure TFormMain.ButtonSaveClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    ImageResult.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

end.

