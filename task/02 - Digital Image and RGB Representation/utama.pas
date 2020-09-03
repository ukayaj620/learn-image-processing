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
    RadioGroupGray: TRadioGroup;
    RadioGroupBinary: TRadioGroup;
    SavePictureDialog1: TSavePictureDialog;
    TrackBarBinary: TTrackBar;
    procedure ButtonBinaryClick(Sender: TObject);
    procedure ButtonBlueClick(Sender: TObject);
    procedure ButtonColorClick(Sender: TObject);
    procedure ButtonGrayClick(Sender: TObject);
    procedure ButtonGreenClick(Sender: TObject);
    procedure ButtonLoadImageClick(Sender: TObject);
    procedure ButtonRedClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrackBarBinaryChange(Sender: TObject);
  private
    procedure AssignBitmapBinary();
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
  bitmapBinary : array[0..1000, 0..1000] of boolean;

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
  AssignBitmapBinary();
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

procedure TFormUtama.FormShow(Sender: TObject);
begin
  RadioGroupBinary.ItemIndex := 0;
  RadioGroupGray.ItemIndex := 0;
  TrackBarBinary.Position := 127;
end;

procedure TFormUtama.AssignBitmapBinary();
var
  x, y, threshold, gray : integer;
begin
  threshold := TrackBarBinary.Position;
  for y := 0 to Image1.Height-1 do
  begin
    for x := 0 to Image1.Width-1 do
    begin
      gray := (bitmapR[x,y] + bitmapG[x,y] + bitmapB[x,y]) div 3;
      if gray <= threshold then
       begin
         bitmapBinary[x,y] := false;
       end
      else
      begin
        bitmapBinary[x,y] := true;
      end;
    end;
  end;
end;

procedure TFormUtama.TrackBarBinaryChange(Sender: TObject);
begin
  AssignBitmapBinary();
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
      case(RadioGroupGray.ItemIndex) of
        0 : Image1.Canvas.Pixels[x,y] := RGB(gray, gray, gray);
        1 : Image1.Canvas.Pixels[x,y] := RGB(gray, 0, 0);
        2 : Image1.Canvas.Pixels[x,y] := RGB(0, gray, 0);
        3 : Image1.Canvas.Pixels[x,y] := RGB(0, 0, gray);
  end;
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

procedure TFormUtama.ButtonBinaryClick(Sender: TObject);
var
  x, y : integer;
begin
  for y := 0 to Image1.Height-1 do
  begin
    for x := 0 to Image1.Width-1 do
    begin
      if bitmapBinary[x,y] = true then
      begin
        case(RadioGroupBinary.ItemIndex) of
          0 : Image1.Canvas.Pixels[x,y] := RGB(0, 0, 0);
          1 : Image1.Canvas.Pixels[x,y] := RGB(255, 0, 0);
          2 : Image1.Canvas.Pixels[x,y] := RGB(0, 255, 0);
          3 : Image1.Canvas.Pixels[x,y] := RGB(0, 0, 255);
        end;
      end
      else
      begin
        Image1.Canvas.Pixels[x,y] := RGB(255, 255, 255);
      end;
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

