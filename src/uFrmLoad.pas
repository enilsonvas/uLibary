unit uFrmLoad;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Ani;

type
  TFormLoad = class(TForm)
    lytLoad: TLayout;
    Mensagem: TLabel;
    rctPrincipal: TRectangle;
    Animacao: TFloatAnimation;
    Arco: TArc;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLoad: TFormLoad;

implementation

{$R *.fmx}

procedure TFormLoad.FormCreate(Sender: TObject);
begin
  rctPrincipal.Opacity     := 0;
  rctPrincipal.Visible     := true;
  rctPrincipal.Align       := TAlignLayout.Contents;
  rctPrincipal.Fill.Color  := TAlphaColorRec.Gray;
  rctPrincipal.Fill.Kind   := TBrushKind.Solid;
  rctPrincipal.Stroke.Kind := TBrushKind.None;
  rctPrincipal.Visible     := true;

//  Mensagem.Align                  := TAlignLayout.Top;
//  Mensagem.Position.Y             := trunc((lyt.Width - Mensagem.Width) / 2);
//  Mensagem.Height                 := 265;
//  Mensagem.Width                  := Self.Width - 100;
  Mensagem.Font.Size              := 30;
  Mensagem.Font.Style             := [TFontStyle.fsBold];
  Mensagem.FontColor              := $FFFEFFFF;
  Mensagem.TextSettings.HorzAlign := TTextAlign.Center;
  Mensagem.TextSettings.VertAlign := TTextAlign.Trailing;
  Mensagem.StyledSettings         := [TStyledSetting.Family, TStyledSetting.Style];
  Mensagem.Trimming               := TTextTrimming.None;
  Mensagem.TabStop                := false;
  Mensagem.SetFocus;

  // Arco da animacao...
  Arco.Visible          := true;
  Arco.Parent           := lytLoad;
  Arco.Height           := Arco.Width;
//  Arco.Width            := lyt.Width - 200;
//  Arco.Margins.Top      := Mensagem.Width + trunc((lyt.Width - Arco.Width) / 2);
//  Arco.Margins.Left     := trunc((lyt.Width - Arco.Width) / 2);
//  Arco.Margins.Right    := trunc((lyt.Width - Arco.Width) / 2);
//  Arco.Align            := TAlignLayout.Top;
//  Arco.Position.Y       := trunc((lyt.Width - Arco.Height) / 2);
//  Arco.Position.X       := trunc((lyt.Width - Arco.Width) / 2);

  Arco.EndAngle         := 150;
  Arco.Stroke.Color     := $FFFEFFFF;
  Arco.Stroke.Thickness := 4;

  Animacao.Parent        := Arco;
  Animacao.StartValue    := 0;
  Animacao.StopValue     := 360;
  Animacao.Duration      := 0.8;
  Animacao.Loop          := true;
  Animacao.PropertyName  := 'RotationAngle';
  Animacao.AnimationType := TAnimationType.InOut;
  Animacao.Interpolation := TInterpolationType.Linear;
  Animacao.Start;

  rctPrincipal.AnimateFloat('Opacity', 0.7);
  lytLoad.AnimateFloat('Opacity', 1);
  lytLoad.BringToFront;
  lytLoad.Align := TAlignLayout.Contents;
end;

end.
