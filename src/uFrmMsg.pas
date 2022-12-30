unit uFrmMsg;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Actions,
  System.ImageList,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.ExtCtrls,
  FMX.ImgList,
  FMX.Ani,
  FMX.ActnList,
  uTipos;



type
  TFormMsg = class(TForm)
    ActionList1: TActionList;
    acSim: TAction;
    acNao: TAction;
    acCancel: TAction;
    acOK: TAction;
    ImageList1: TImageList;
    lytFormMsg: TLayout;
    rctPrincipal: TRectangle;
    lytCaption: TLayout;
    imgCaption: TImage;
    lblCaption: TLabel;
    lytBtnOk: TLayout;
    rctOk: TRoundRect;
    lblBtnOK: TLabel;
    lytBtn: TLayout;
    rctbtnSim: TRoundRect;
    lblBtnSim: TLabel;
    rctBtnCancelar: TRoundRect;
    lblBtnCancelar: TLabel;
    rctBtnNao: TRoundRect;
    lblBtnNao: TLabel;
    lblMsg: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure acSimExecute(Sender: TObject);
    procedure acNaoExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acOKExecute(Sender: TObject);
  private
    { Private declarations }
    procedure SetIcon(aId: Integer);
    procedure SetResult(aBtnResult: TpBtnMsg);
  public
    aBtnResult: TBtnResult;
    procedure CarregaIcon(aIcon: TpIconMsg);
    procedure CarregaBtn(aBtn: array of TpBtnMsg);
    procedure CarregaMsgCap(aTexto, aCaption: string);
    { Public declarations }
  end;

var
  FormMsg: TFormMsg;

implementation

{$R *.fmx}

uses  uAuxMetodos;

{ TFormMenssagem }

procedure TFormMsg.acCancelExecute(Sender: TObject);
begin
  SetResult(btrCancelar);
end;

procedure TFormMsg.acNaoExecute(Sender: TObject);
begin
  SetResult(btrNao);
end;

procedure TFormMsg.acOKExecute(Sender: TObject);
begin
  SetResult(btrOk);
end;

procedure TFormMsg.acSimExecute(Sender: TObject);
begin
  SetResult(btrSim);
end;

procedure TFormMsg.CarregaBtn(aBtn: array of TpBtnMsg);
var
  I: Integer;
begin
  for I := 0 to High(aBtn) do
    begin
      case aBtn[i] of
        btrSim     : rctbtnSim.Visible      := True;
        btrNao     : rctBtnNao.Visible      := True;
        btrCancelar: rctBtnCancelar.Visible := True;
        btrOk      :
          begin
            lytBtnOk.Visible := True;
            lytBtn.Visible   := False;
          end;
      end;
    end;
end;

procedure TFormMsg.CarregaIcon(aIcon: TpIconMsg);
begin
  case aIcon of
    mtConfirmation: SetIcon(0);
    mtInformation: SetIcon(1);
    mtError: SetIcon(2);
    mtWarning: SetIcon(3);
  end;
end;

procedure TFormMsg.CarregaMsgCap(aTexto, aCaption: string);
begin
  lblCaption.Text := aCaption;
  lblMsg.Text     := aTexto;
end;

procedure TFormMsg.FormCreate(Sender: TObject);
begin

  rctbtnSim.Visible      := false;
  rctBtnCancelar.Visible := false;
  rctBtnCancelar.Visible := false;
  lytBtnOk.Visible       := false;

  rctPrincipal.Width       := lytFormMsg.Width;
  rctPrincipal.Opacity     := 0;
  rctPrincipal.Visible     := true;
  rctPrincipal.Align       := TAlignLayout.Center;
  rctPrincipal.Fill.Kind   := TBrushKind.Solid;
  rctPrincipal.Stroke.Kind := TBrushKind.None;
  rctPrincipal.Visible     := true;
  rctPrincipal.Opacity     := 99;
  lytFormMsg.BringToFront;

end;

procedure TFormMsg.SetIcon(aId: Integer);
var
  s: TMemoryStream;
begin
  s := TMemoryStream.Create;

  ImageList1.Source.Items[aId].MultiResBitmap.Bitmaps[1].SaveToStream(s);

  s.Position := 0;

  imgCaption.MultiResBitmap.BeginUpdate;
  imgCaption.MultiResBitmap.Bitmaps[1].LoadFromStream(s);

  imgCaption.MultiResBitmap.EndUpdate;
end;

procedure TFormMsg.SetResult(aBtnResult: TpBtnMsg);
begin
  FechaTela(FormMsg);
end;

end.
