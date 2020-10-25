unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonSave: TButton;
    ButtonLoadImage2: TButton;
    ButtonLoadImage1: TButton;
    ImageResult: TImage;
    ImageSource1: TImage;
    ImageSource2: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonLoadImage1Click(Sender: TObject);
    procedure ButtonLoadImage2Click(Sender: TObject);
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

type
  Channel = record
    R, G, B: Byte;
  end;

var
  Image1, Image2: array [0..1000, 0..1000] of Channel;

procedure TFormMain.ButtonLoadImage1Click(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    ImageSource1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    for y:= 0 to ImageSource1.Height-1 do
    begin
      for x:= 0 to ImageSource1.Width-1 do
      begin
        Image1[x, y].R:= GetRValue(ImageSource1.Canvas.Pixels[x, y]);
        Image1[x, y].G:= GetGValue(ImageSource1.Canvas.Pixels[x, y]);
        Image1[x, y].B:= GetBValue(ImageSource1.Canvas.Pixels[x, y]);
      end;
    end;
  end;
end;

procedure TFormMain.ButtonLoadImage2Click(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    ImageSource2.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    for y:= 0 to ImageSource1.Height-1 do
    begin
      for x:= 0 to ImageSource1.Width-1 do
      begin
        Image2[x, y].R:= GetRValue(ImageSource2.Canvas.Pixels[x, y]);
        Image2[x, y].G:= GetGValue(ImageSource2.Canvas.Pixels[x, y]);
        Image2[x, y].B:= GetBValue(ImageSource2.Canvas.Pixels[x, y]);
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

