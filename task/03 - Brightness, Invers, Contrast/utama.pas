unit utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtDlgs, ExtCtrls;

type

  { TFormUtama }

  TFormUtama = class(TForm)
    Bevel1: TBevel;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonColor: TButton;
    ButtonInvers: TButton;
    ButtonGray: TButton;
    ButtonBinary: TButton;
    ButtonBrightness: TButton;
    ButtonContrast: TButton;
    ImageSource: TImage;
    ImageQuantify: TImage;
    LabelImage: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LabelP: TLabel;
    LabelG: TLabel;
    LabelBrightness: TLabel;
    LabelThreshold: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    TrackBarBinary: TTrackBar;
    TrackBarBrightness: TTrackBar;
    TrackBarContrast: TTrackBar;
    TrackBarG: TTrackBar;
    procedure ButtonBinaryClick(Sender: TObject);
    procedure ButtonBrightnessClick(Sender: TObject);
    procedure ButtonColorClick(Sender: TObject);
    procedure ButtonContrastClick(Sender: TObject);
    procedure ButtonGrayClick(Sender: TObject);
    procedure ButtonInversClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrackBarGChange(Sender: TObject);
    procedure TrackBarBinaryChange(Sender: TObject);
    procedure TrackBarBrightnessChange(Sender: TObject);
    procedure TrackBarContrastChange(Sender: TObject);
  private
    function ClipperItUp(value: integer): byte;
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
  colorMode : boolean; // Color is True and Monochrome is False

procedure TFormUtama.ButtonLoadClick(Sender: TObject);
var
  x, y : integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    ImageSource.Picture.LoadFromFile(OpenPictureDialog1.FileName);

    for y := 0 to ImageSource.Height-1 do
    begin
      for x := 0 to ImageSource.Width-1 do
      begin
        bitmapR[x,y] := GetRValue(ImageSource.Canvas.Pixels[x,y]);
        bitmapG[x,y] := GetGValue(ImageSource.Canvas.Pixels[x,y]);
        bitmapB[x,y] := GetBValue(ImageSource.Canvas.Pixels[x,y]);
      end;
    end;
  end;
  colorMode := True;
  LabelImage.Caption := 'Colorful';
end;

procedure TFormUtama.ButtonColorClick(Sender: TObject);
var
  x, y : integer;
begin
  for y := 0 to ImageSource.Height-1 do
  begin
    for x := 0 to ImageSource.Width-1 do
    begin
      ImageSource.Canvas.Pixels[x, y] := RGB(bitmapR[x, y], bitmapG[x, y], bitmapB[x, y]);
    end;
  end;
  colorMode := True;
  LabelImage.Caption := 'Colorful';
end;

procedure TFormUtama.ButtonContrastClick(Sender: TObject);
var
  x, y, Gval, Pval : integer;
  gray : byte;

  R, G, B : byte;
begin
  Gval := TrackBarG.Position;
  Pval := TrackBarContrast.Position;
  for y := 0 to ImageSource.Height-1 do
  begin
    for x := 0 to ImageSource.Width-1 do
    begin
      if colorMode = True then
      begin
        R := ClipperItUp(Gval * (bitmapR[x, y] - Pval) + Pval);
        G := ClipperItUp(Gval * (bitmapG[x, y] - Pval) + Pval);
        B := ClipperItUp(Gval * (bitmapB[x, y] - Pval) + Pval);
        ImageQuantify.Canvas.Pixels[x, y] := RGB(R, G, B);
      end
      else
      begin
        gray := ClipperItUp(Gval * ((bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3 - Pval) + Pval);
        ImageQuantify.Canvas.Pixels[x, y] := RGB(gray, gray, gray);
      end;
    end;
  end;

end;

procedure TFormUtama.ButtonBinaryClick(Sender: TObject);
var
  x, y : integer;
  gray : byte;
begin
  for y := 0 to ImageSource.Height-1 do
  begin
    for x := 0 to ImageSource.Width-1 do
    begin
      gray := (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;

      if gray <= TrackBarBinary.Position then
        ImageQuantify.Canvas.Pixels[x, y] := RGB(0, 0, 0)
      else
        ImageQuantify.Canvas.Pixels[x, y] := RGB(255, 255, 255);

    end;
  end;
end;

function TFormUtama.ClipperItUp(value: integer): byte;
begin
  if value < 0 then ClipperItUp := 0
  else if value > 255 then ClipperItUp := 255
  else ClipperItUp := value;
end;

procedure TFormUtama.ButtonBrightnessClick(Sender: TObject);
var
  x, y, brightCoef : integer;
  gray : byte;

  R, G, B : byte;
begin
  brightCoef := TrackBarBrightness.Position;
  for y := 0 to ImageSource.Height-1 do
  begin
    for x := 0 to ImageSource.Width-1 do
    begin
      if colorMode = True then
      begin
        R := ClipperItUp(bitmapR[x, y] + brightCoef);
        G := ClipperItUp(bitmapG[x, y] + brightCoef);
        B := ClipperItUp(bitmapB[x, y] + brightCoef);
        ImageQuantify.Canvas.Pixels[x, y] := RGB(R, G, B);
      end
      else
      begin
        gray := ClipperItUp(((bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3) + brightCoef);
        ImageQuantify.Canvas.Pixels[x, y] := RGB(gray, gray, gray);
      end;
    end;
  end;
end;

procedure TFormUtama.ButtonGrayClick(Sender: TObject);
var
  x, y : integer;
  gray : byte;
begin
  for y := 0 to ImageSource.Height-1 do
  begin
    for x := 0 to ImageSource.Width-1 do
    begin
      gray := (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;
      ImageSource.Canvas.Pixels[x, y] := RGB(gray, gray, gray);
    end;
  end;
  colorMode := False;
  LabelImage.Caption := 'Monochrome';
end;

procedure TFormUtama.ButtonInversClick(Sender: TObject);
var
  x, y : integer;
  inversedGray : byte;
begin
  for y := 0 to ImageSource.Height-1 do
  begin
    for x := 0 to ImageSource.Width-1 do
    begin
      if colorMode = True then
        ImageQuantify.Canvas.Pixels[x, y] := RGB(255-bitmapR[x, y], 255-bitmapG[x, y], 255-bitmapB[x, y])
      else
      begin
        inversedGray := 255 - ((bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3);
        ImageQuantify.Canvas.Pixels[x, y] := RGB(inversedGray, inversedGray, inversedGray);
      end;
    end;
  end;
end;

procedure TFormUtama.ButtonSaveClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    ImageQuantify.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TFormUtama.FormShow(Sender: TObject);
begin
  LabelG.Caption := IntToStr(TrackBarG.Position);
  LabelThreshold.Caption := IntToStr(TrackBarBinary.Position);
  LabelBrightness.Caption := IntToStr(TrackBarBrightness.Position);
  LabelP.Caption := IntToStr(TrackBarContrast.Position);
end;

procedure TFormUtama.TrackBarGChange(Sender: TObject);
begin
  LabelG.Caption := IntToStr(TrackBarG.Position);
end;

procedure TFormUtama.TrackBarBinaryChange(Sender: TObject);
begin
  LabelThreshold.Caption := IntToStr(TrackBarBinary.Position);
end;

procedure TFormUtama.TrackBarBrightnessChange(Sender: TObject);
begin
  LabelBrightness.Caption := IntToStr(TrackBarBrightness.Position);
end;

procedure TFormUtama.TrackBarContrastChange(Sender: TObject);
begin
  LabelP.Caption := IntToStr(TrackBarContrast.Position);
end;

end.

