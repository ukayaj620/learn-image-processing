unit utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtDlgs, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
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
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

