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
    Label1: TLabel;
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
    procedure ButtonLoadClick(Sender: TObject);
    procedure TrackBarGChange(Sender: TObject);
    procedure TrackBarBinaryChange(Sender: TObject);
    procedure TrackBarBrightnessChange(Sender: TObject);
    procedure TrackBarContrastChange(Sender: TObject);
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
  AssignBitmapBinary();
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

procedure TFormUtama.AssignBitmapBinary();
var
  x, y, threshold, gray : integer;
begin
  threshold := TrackBarBinary.Position;
  for y := 0 to ImageSource.Height-1 do
  begin
    for x := 0 to ImageSource.Width-1 do
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

end.

