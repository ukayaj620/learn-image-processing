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

  { TFormMain }

  TFormMain = class(TForm)
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonErosi: TButton;
    ButtonDilasi: TButton;
    ImageSource: TImage;
    ImageResult: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  private

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
  Bitmap1, Bitmap2: array[0..1000, 0..1000] of Channel;
  imageWidth, imageHeight: Integer;

procedure TFormMain.ButtonLoadClick(Sender: TObject);
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
        Bitmap1[x, y].R:= GetRValue(ImageSource.Canvas.Pixels[x, y]);
        Bitmap1[x, y].G:= GetGValue(ImageSource.Canvas.Pixels[x, y]);
        Bitmap1[x, y].B:= GetBValue(ImageSource.Canvas.Pixels[x, y]);
      end;
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

end.

