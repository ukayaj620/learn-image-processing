unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonExecute: TButton;
    ButtonSaveImage: TButton;
    ButtonLoadImage: TButton;
    ImageSource: TImage;
    ImageResult: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    RadioGroupEdge: TRadioGroup;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonExecuteClick(Sender: TObject);
    procedure ButtonLoadImageClick(Sender: TObject);
    procedure ButtonSaveImageClick(Sender: TObject);
    procedure RadioGroupEdgeSelectionChanged(Sender: TObject);
  private
    //procedure InitKernel();
    procedure InitPadding(value: Integer);
    procedure ShowFilterResult();
    function Constrain(value: Integer): Byte;
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
  bitmapR, bitmapG, bitmapB, bitmapGray, paddingGray, bitmapFilter: array[0..1000, 0..1000] of Byte;
  imageWidth, imageHeight: Integer;

  kernelX: array[1..3, 1..3] of Integer = ((0, 0, 0), (0, 0, 0), (0, 0, 0));
  kernelY: array[1..3, 1..3] of Integer = ((0, 0, 0), (0, 0, 0), (0, 0, 0));
  size: Integer;

procedure TForm1.ButtonLoadImageClick(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    ImageSource.Picture.LoadFromFile(OpenPictureDialog1.FileName);

    imageWidth:= ImageSource.Width;
    imageHeight:= ImageSource.Height;

    ImageResult.Width:= imageWidth;
    ImageResult.Height:= imageHeight;

    for y:= 0 to imageHeight-1 do
    begin
      for x:= 0 to imageWidth-1 do
      begin
        bitmapR[x, y]:= GetRValue(ImageSource.Canvas.Pixels[x, y]);
        bitmapG[x, y]:= GetGValue(ImageSource.Canvas.Pixels[x, y]);
        bitmapB[x, y]:= GetBValue(ImageSource.Canvas.Pixels[x, y]);

        bitmapGray[x, y]:= (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;
      end;
    end;
  end;
end;

procedure TForm1.ButtonExecuteClick(Sender: TObject);
var
  x, y, xK, yK: Integer;
  grayX, grayY: Integer;
  k, kHalf: Integer;
begin
  k:= size;
  kHalf:= size div 2;
  InitPadding(0);
  for y:= kHalf to (imageHeight+kHalf) do
  begin
    for x:= kHalf to (imageWidth+kHalf) do
    begin
      grayX:= 0;
      grayY:= 0;
      for yK:= 1 to k do
      begin
        for xK:= 1 to k do
        begin
          grayX:= grayX + (paddingGray[x-(xK- k + kHalf), y-(yK - k + kHalf)] * kernelX[xK, yK]);
          grayY:= grayY + (paddingGray[x-(xK- k + kHalf), y-(yK - k + kHalf)] * kernelY[xK, yK]);
        end;
      end;
      if grayX > grayY then
      begin
        bitmapFilter[x-kHalf, y-kHalf]:= Constrain(Round(grayX));
      end
      else
      begin
        bitmapFilter[x-kHalf, y-kHalf]:= Constrain(Round(grayY));
      end;
    end;
  end;
  ShowFilterResult();
end;

procedure TForm1.ShowFilterResult();
var
  x, y: Integer;
begin
  for y:= 0 to imageHeight-1 do
  begin
    for x:= 0 to imageWidth-1 do
    begin
      ImageResult.Canvas.Pixels[x, y]:= RGB(bitmapFilter[x, y], bitmapFilter[x, y], bitmapFilter[x, y]);
    end;
  end;
end;

procedure TForm1.ButtonSaveImageClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    ImageResult.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TForm1.RadioGroupEdgeSelectionChanged(Sender: TObject);
var
  sobelX: array[1..3, 1..3] of Integer = ((-1, 0, 1), (-2, 0, 2), (-1, 0, 1));
  sobelY: array[1..3, 1..3] of Integer = ((1, 2, 1), (0, 0, 0), (-1, -2, -1));

  prewitX: array[1..3, 1..3] of Integer = ((-1, 0, 1), (-1, 0, 1), (-1, 0, 1));
  prewitY: array[1..3, 1..3] of Integer = ((1, 1, 1), (0, 0, 0), (-1, -1, -1));

  robertX: array[1..3, 1..3] of Integer = ((1, 0, 0), (0, -1, 0), (0, 0, 0));
  robertY: array[1..3, 1..3] of Integer = ((0, -1, 0), (1, 0, 0), (0, 0, 0));
begin
  if RadioGroupEdge.ItemIndex = 0 then
  begin
    size:= 3;
    kernelX:= sobelX;
    kernelY:= sobelY;
  end;
  if RadioGroupEdge.ItemIndex = 1 then
  begin
    size:= 3;
    kernelX:= prewitX;
    kernelY:= prewitY;
  end;
  if RadioGroupEdge.ItemIndex = 2 then
  begin
    size:= 2;
    kernelX:= robertX;
    kernelY:= robertY;
  end;
end;

//procedure TForm1.InitKernel();
//var
//  sobelX: array[1..3, 1..3] of Integer = ((-1, 0, 1), (-2, 0, 2), (-1, 0, 1));
//  sobelY: array[1..3, 1..3] of Integer = ((1, 2, 1), (0, 0, 0), (-1, -2, -1));
//
//  prewitX: array[1..3, 1..3] of Integer = ((-1, 0, 1), (-1, 0, 1), (-1, 0, 1));
//  prewitY: array[1..3, 1..3] of Integer = ((1, 1, 1), (0, 0, 0), (-1, -1, -1));
//
//  robertX: array[1..3, 1..3] of Integer = ((1, 0, 0), (0, -1, 0), (0, 0, 0));
//  robertY: array[1..3, 1..3] of Integer = ((0, -1, 0), (1, 0, 0), (0, 0, 0));
//begin
//  if RadioGroupEdge.ItemIndex = 0 then
//  begin
//    size:= 3;
//    kernelX:= sobelX;
//    kernelY:= sobelY;
//  end;
//  if RadioGroupEdge.ItemIndex = 1 then
//  begin
//    size:= 3;
//    kernelX:= prewitX;
//    kernelY:= prewitY;
//  end;
//  if RadioGroupEdge.ItemIndex = 2 then
//  begin
//    size:= 2;
//    kernelX:= robertX;
//    kernelY:= robertY;
//  end;
//end;

procedure TForm1.InitPadding(value: Integer);
var
  kHalf: Integer;
  x, y, z: Integer;
begin
  kHalf:= size div 2;
  for y:= 0 to imageHeight+kHalf do
  begin
    for z:= 0 to kHalf-1 do
    begin
      paddingGray[0+z, y]:= value;
      paddingGray[imageWidth+kHalf+z, y]:= value;
    end;
  end;

  for x:= 0 to imageWidth+kHalf do
  begin
    for z:= 0 to kHalf-1 do
    begin
      paddingGray[x, 0+z]:= value;
      paddingGray[x, imageHeight+kHalf+z]:= value;
    end;
  end;

  for y:= kHalf to (imageHeight+kHalf-1) do
  begin
    for x:= kHalf to (imageWidth+kHalf-1) do
    begin
      paddingGray[x, y]:= bitmapGray[x-kHalf, y-kHalf];
    end;
  end;
end;

function TForm1.Constrain(value: Integer): Byte;
begin
  if value < 0 then Constrain := 0
  else if value > 255 then Constrain := 255
  else Constrain := value;
end;

end.

