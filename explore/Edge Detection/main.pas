unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonExecute: TButton;
    ButtonSaveImage: TButton;
    ButtonLoadImage: TButton;
    Image1: TImage;
    Image2: TImage;
    RadioGroupEdgeDetector: TRadioGroup;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

