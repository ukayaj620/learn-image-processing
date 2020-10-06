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
    RadioGroupEdgeDetector: TRadioGroup;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonLoadImageClick(Sender: TObject);
    procedure ButtonSaveImageClick(Sender: TObject);
  private
    procedure InitKernel();
    procedure InitPadding();
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
  bitmapR, bitmapG, bitmapB, bitmapGray: array[1..1000, 1..1000] of Byte;
  imageWidth, imageHeight: Integer;

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

    for y:= 0 to imageWidth do
    begin
      for x:= 0 to imageHeight do
      begin
        bitmapR[x, y]:= GetRValue(ImageSource.Canvas.Pixels[x, y]);
        bitmapG[x, y]:= GetGValue(ImageSource.Canvas.Pixels[x, y]);
        bitmapB[x, y]:= GetBValue(ImageSource.Canvas.Pixels[x, y]);

        bitmapGray[x, y]:= (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;
      end;
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

end.

