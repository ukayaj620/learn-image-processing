unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, ComCtrls;

type
  Channel = record
    R, G, B: Byte;
  end;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonBinary: TButton;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonErosi: TButton;
    ButtonDilasi: TButton;
    ImageSource: TImage;
    ImageResult: TImage;
    Label1: TLabel;
    Label2: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    RadioGroupObject: TRadioGroup;
    SavePictureDialog1: TSavePictureDialog;
    TrackBar1: TTrackBar;
    procedure ButtonBinaryClick(Sender: TObject);
    procedure ButtonDilasiClick(Sender: TObject);
    procedure ButtonErosiClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    function BoolToByte(value: Boolean): Byte;
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
  Bitmap1: array[0..1000, 0..1000] of Channel;
  BinaryBitmap: array[0..1000, 0..1000] of Byte;
  SE: array[1..3, 1..3] of Byte = ((1, 1, 1), (1, 1, 1), (1, 1, 1));
  imageWidth, imageHeight: Integer;

procedure TFormMain.ButtonLoadClick(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    ImageSource.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    ImageResult.Picture.LoadFromFile(OpenPictureDialog1.FileName);

    imageWidth:= ImageSource.Width;
    imageHeight:= ImageSource.Height;

    ImageResult.Width:= imageWidth;
    ImageResult.Height:= imageHeight;

    for y:= 1 to imageHeight do
    begin
      for x:= 1 to imageWidth do
      begin
        Bitmap1[x, y].R:= GetRValue(ImageSource.Canvas.Pixels[x-1, y-1]);
        Bitmap1[x, y].G:= GetGValue(ImageSource.Canvas.Pixels[x-1, y-1]);
        Bitmap1[x, y].B:= GetBValue(ImageSource.Canvas.Pixels[x-1, y-1]);
      end;
    end;
  end;
end;

function TFormMain.BoolToByte(value: Boolean): Byte;
begin
  if value then BoolToByte:= 1 else BoolToByte:= 0;
end;

procedure TFormMain.ButtonErosiClick(Sender: TObject);
var
  x, y: Integer;
  xk, yk: Integer;
  TempBitmap: array[0..1000, 0..1000] of Byte;
  binary: Boolean;
  isFirst: Boolean;
  k: Integer = 3;
begin
  for y:= 1 to imageHeight do
  begin
    for x:= 1 to imageWidth do
    begin
      binary:= false;
      isFirst:= true;
      for yk:= 1 to k do
      begin
        for xk:= 1 to k do
        begin
          if BinaryBitmap[x, y] <> 127 then
          begin
            if isFirst then
            begin
              binary:= (BinaryBitmap[x+(xk-k+1), y+(yk-k+1)] = SE[xk, yk]);
              isFirst:= false;
            end
            else
              binary:= binary AND (BinaryBitmap[x+(xk-k+1), y+(yk-k+1)] = SE[xk, yk]);
          end;
        end;
      end;
      TempBitmap[x, y]:= BoolToByte(binary);
      if binary then
        ImageResult.Canvas.Pixels[x-1, y-1]:= RGB(255, 255, 255)
      else
        ImageResult.Canvas.Pixels[x-1, y-1]:= RGB(0, 0, 0)
    end;
  end;
  for y:= 1 to imageHeight do
  begin
    for x:= 1 to imageWidth do
    begin
      BinaryBitmap[x, y]:= TempBitmap[x, y];
    end;
  end;
end;

procedure TFormMain.ButtonBinaryClick(Sender: TObject);
var
  x, y: Integer;
  threshold: Integer;
  gray: Integer;
begin
  threshold:= TrackBar1.Position;
  for y:= 1 to imageHeight do
  begin
    for x:= 1 to imageWidth do
    begin
      gray:= (Bitmap1[x, y].R + Bitmap1[x, y].G + Bitmap1[x, y].B) div 3;
      if gray >= threshold then
      begin
        BinaryBitmap[x, y]:= 1;
        ImageResult.Canvas.Pixels[x-1, y-1]:= RGB(255, 255, 255);
      end
      else
      begin
        BinaryBitmap[x, y]:= 0;
        ImageResult.Canvas.Pixels[x-1, y-1]:= RGB(0, 0, 0);
      end;
    end;
  end;

  for y:= 0 to imageHeight+1 do
  begin
    BinaryBitmap[0, y]:= 127;
    BinaryBitmap[imageWidth+1, y]:= 127;
  end;
  for x:= 0 to imageWidth+1 do
  begin
    BinaryBitmap[x, 0]:= 127;
    BinaryBitmap[x, imageHeight+1]:= 127;
  end;
end;

procedure TFormMain.ButtonDilasiClick(Sender: TObject);
var
  x, y: Integer;
  xk, yk: Integer;
  TempBitmap: array[0..1000, 0..1000] of Byte;
  binary: Boolean;
  isFirst: Boolean;
  k: Integer = 3;
begin
  for y:= 1 to imageHeight do
  begin
    for x:= 1 to imageWidth do
    begin
      binary:= false;
      isFirst:= true;
      for yk:= 1 to k do
      begin
        for xk:= 1 to k do
        begin
          if BinaryBitmap[x, y] <> 127 then
          begin
            if isFirst then
            begin
              binary:= (BinaryBitmap[x+(xk-k+1), y+(yk-k+1)] = SE[xk, yk]);
              isFirst:= false;
            end
            else
              binary:= binary OR (BinaryBitmap[x+(xk-k+1), y+(yk-k+1)] = SE[xk, yk]);
          end;
        end;
      end;
      TempBitmap[x, y]:= BoolToByte(binary);
      if binary then
        ImageResult.Canvas.Pixels[x-1, y-1]:= RGB(255, 255, 255)
      else
        ImageResult.Canvas.Pixels[x-1, y-1]:= RGB(0, 0, 0)
    end;
  end;
  for y:= 1 to imageHeight do
  begin
    for x:= 1 to imageWidth do
    begin
      BinaryBitmap[x, y]:= TempBitmap[x, y];
    end;
  end;
end;

procedure TFormMain.ButtonSaveClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    ImageResult.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TFormMain.TrackBar1Change(Sender: TObject);
begin
  Label2.Caption:= IntToStr(TrackBar1.Position);
end;

end.

