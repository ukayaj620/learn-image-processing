unit utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, ComCtrls;

type

  { TFormUtama }

  TFormUtama = class(TForm)
    ButtonBinary: TButton;
    ButtonSave: TButton;
    ButtonGray: TButton;
    ButtonBlue: TButton;
    ButtonGreen: TButton;
    ButtonRed: TButton;
    ButtonColor: TButton;
    ButtonLoadImage: TButton;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    RadioBlack: TRadioButton;
    RadioBlack1: TRadioButton;
    RadioBlue1: TRadioButton;
    RadioGreen: TRadioButton;
    RadioBlue: TRadioButton;
    RadioGreen1: TRadioButton;
    RadioGroupGray: TRadioGroup;
    RadioRed: TRadioButton;
    RadioGroupBinary: TRadioGroup;
    RadioRed1: TRadioButton;
    SavePictureDialog1: TSavePictureDialog;
    TrackBarBinary: TTrackBar;
    procedure ButtonBlueClick(Sender: TObject);
    procedure ButtonColorClick(Sender: TObject);
    procedure ButtonGrayClick(Sender: TObject);
    procedure ButtonGreenClick(Sender: TObject);
    procedure ButtonLoadImageClick(Sender: TObject);
    procedure ButtonRedClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
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
  x, y : integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);

    for y := 0 to Image1.Height-1 do
    begin
      for x := 0 to Image1.Width-1 do
      begin
        bitmapR[x,y] := GetRValue(Image1.Canvas.Pixels[x,y]);
        bitmapG[x,y] := GetGValue(Image1.Canvas.Pixels[x,y]);
        bitmapB[x,y] := GetBValue(Image1.Canvas.Pixels[x,y]);
      end;
    end;
  end;

end;

procedure TFormUtama.ButtonRedClick(Sender: TObject);
var
  x, y : integer;
begin
  for y := 0 to Image1.Height-1 do
  begin
    for x := 0 to Image1.Width-1 do
    begin
      Image1.Canvas.Pixels[x,y] := RGB(bitmapR[x,y], 0, 0);
    end;
  end;
end;

procedure TFormUtama.ButtonSaveClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    Image1.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TFormUtama.ButtonColorClick(Sender: TObject);
var
  x, y : integer;
begin
  for y := 0 to Image1.Height-1 do
  begin
    for x := 0 to Image1.Width-1 do
    begin
      Image1.Canvas.Pixels[x,y] := RGB(bitmapR[x,y], bitmapG[x,y], bitmapB[x,y]);
    end;
  end;
end;

procedure TFormUtama.ButtonGrayClick(Sender: TObject);
var
  x, y, gray : integer;
begin
  for y := 0 to Image1.Height-1 do
  begin
    for x := 0 to Image1.Width-1 do
    begin
      gray := (bitmapR[x,y] + bitmapG[x,y] + bitmapB[x,y]) div 3;
      Image1.Canvas.Pixels[x,y] := RGB(gray, gray, gray);
    end;
  end;
end;

procedure TFormUtama.ButtonBlueClick(Sender: TObject);
var
  x, y : integer;
begin
  for y := 0 to Image1.Height-1 do
  begin
    for x := 0 to Image1.Width-1 do
    begin
      Image1.Canvas.Pixels[x,y] := RGB(0, 0, bitmapB[x,y]);
    end;
  end;
end;

procedure TFormUtama.ButtonGreenClick(Sender: TObject);
var
  x, y : integer;
begin
  for y := 0 to Image1.Height-1 do
  begin
    for x := 0 to Image1.Width-1 do
    begin
      Image1.Canvas.Pixels[x,y] := RGB(0, bitmapG[x,y], 0);
    end;
  end;
end;

end.

