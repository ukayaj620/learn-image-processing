unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, ComCtrls;

type
  Channel = record
    R, G, B: Byte;
  end;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonBlend: TButton;
    ButtonSave: TButton;
    ButtonLoadImage2: TButton;
    ButtonLoadImage1: TButton;
    ImageResult: TImage;
    ImageSource1: TImage;
    ImageSource2: TImage;
    Label1: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    TrackBarPercentage: TTrackBar;
    procedure ButtonBlendClick(Sender: TObject);
    procedure ButtonLoadImage1Click(Sender: TObject);
    procedure ButtonLoadImage2Click(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  private
    function BlendPixels(x, y: Integer): Channel;
    function Constrain(value: Double): Byte;
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

procedure TFormMain.ButtonBlendClick(Sender: TObject);
var
  x, y: Integer;
  blendedPixels: Channel;
begin
  ImageResult.Width:= ImageSource1.Width;
  ImageResult.Height:= ImageSource1.Height;

  for y:= 0 to ImageSource1.Height-1 do
  begin
    for x:= 0 to ImageSource1.Width-1 do
    begin
      blendedPixels:= BlendPixels(x, y);
      ImageResult.Canvas.Pixels[x, y]:= RGB(
        blendedPixels.R,
        blendedPixels.G,
        blendedPixels.B
      );
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

function TFormMain.Constrain(value: Double): Byte;
begin
  if value < 0 then Constrain:= 0
  else if value > 255 then Constrain:= 255
  else Constrain:= round(value);
end;

function TFormMain.BlendPixels(x, y: Integer): Channel;
var
  percentage: Double;
begin
  percentage:= TrackBarPercentage.Position * 0.01;
  BlendPixels.R:= Constrain(Image1[x, y].R * percentage + Image2[x, y].R * (1-percentage));
  BlendPixels.G:= Constrain(Image1[x, y].G * percentage + Image2[x, y].G * (1-percentage));
  BlendPixels.B:= Constrain(Image1[x, y].B * percentage + Image2[x, y].B * (1-percentage));
end;

end.

