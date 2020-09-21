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
    procedure ButtonLoadImageClick(Sender: TObject);
  private

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

procedure TFormUtama.ButtonLoadImageClick(Sender: TObject);
var
  x, y: integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    ImageSource.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    for y:= 0 to ImageSource.Height-1 do
    begin
      for x:= 0 to ImageSource.Width-1 do
      begin
        bitmapR[x, y]:= GetRValue(ImageSource.Canvas.Pixels[x, y]);
        bitmapG[x, y]:= GetGValue(ImageSource.Canvas.Pixels[x, y]);
        bitmapB[x, y]:= GetBValue(ImageSource.Canvas.Pixels[x, y]);
      end;
    end;
  end;
end;

end.

