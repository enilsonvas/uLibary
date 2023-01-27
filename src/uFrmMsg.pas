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
  uTipos,
  uAuxMetodos;

type
  TFormMsg = class(TForm)
    ActionList1: TActionList;
    acSim: TAction;
    acNao: TAction;
    acCancel: TAction;
    acOK: TAction;
    ImageList1: TImageList;
    lyt: TLayout;
    rectMsg: TRectangle;
    lytCaption: TLayout;
    imgCaption: TImage;
    lblCaption: TLabel;
    lytMsg: TLayout;
    lytBtn: TLayout;
    lblMsg: TLabel;
    lytSimNaoCanc: TLayout;
    rountRectSncSim: TRoundRect;
    lblSim: TLabel;
    rountRectSncNao: TRoundRect;
    lblNao: TLabel;
    rountRectSncCancelar: TRoundRect;
    lblCancelar: TLabel;
    lytSimNao: TLayout;
    rountRectSnSim: TRoundRect;
    Label1: TLabel;
    rountRectSnNao: TRoundRect;
    Label2: TLabel;
    lytOk: TLayout;
    rountRectOkOK: TRoundRect;
    Label3: TLabel;
    Rectangle1: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure acSimExecute(Sender: TObject);
    procedure acNaoExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acOKExecute(Sender: TObject);
    procedure rountRectSncSimMouseEnter(Sender: TObject);
    procedure rountRectSncSimMouseLeave(Sender: TObject);
  private
    { Private declarations }
    procedure SetIcon(aId: Integer);
    procedure SetResult(aBtn: TpBtnMsg);
  public
    aProc: TProc;
    procedure CarregaIcon(aIcon: TpIconMsg);
    procedure CarregaBtn(aBtn: array of TpBtnIcon);
    procedure CarregaMsgCap(aTexto, aCaption: string);
    procedure CarregaStyle(aStyle: TStyleBook);
    { Public declarations }
  end;

var
  FormMsg: TFormMsg;

implementation

{$R *.fmx}

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

procedure TFormMsg.CarregaBtn(aBtn: array of TpBtnIcon);
var
  I: Integer;
  lSim, lNao, lCanc, lOk: Boolean;
begin
  lSim  := False;
  lNao  := False;
  lCanc := False;
  lOk   := False;

  lytSimNaoCanc.Visible := False;
  lytSimNao.Visible     := False;
  lytOk.Visible         := False;

  for I := Low(aBtn) to High(aBtn) do
    begin
      case aBtn[i] of
        btiSim     : lSim  := True;
        btiNao     : lNao  := True;
        btiOk      : lOk   := True;
        btiCancelar: lCanc := True;
      end;
    end;

  if lSim and lNao and lCanc then
    lytSimNaoCanc.Visible := True
  else if lSim and lNao then
    lytSimNao.Visible := True
  else if lOk then
    lytOk.Visible := True
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

procedure TFormMsg.CarregaStyle(aStyle: TStyleBook);
begin
//  FormMsg.StyleBook := aStyle;
//  FormMsg.UpdateStyleBook;
  FormMsg.StyleLookup := 'backgroundstyle';
  FormMsg.SetStyleBookWithoutUpdate(aStyle);
  FormMsg.ApplyStyleLookup;
end;

procedure TFormMsg.FormCreate(Sender: TObject);
var
  LWhitSnc, LWhitSn: Integer;
begin

  rectMsg.Width       := lyt.Width;
//  rectMsg.Align       := TAlignLayout.Center;
//  rectMsg.Fill.Kind   := TBrushKind.Solid;
//  rectMsg.Stroke.Kind := TBrushKind.None;
  rectMsg.Visible     := true;
  rectMsg.Opacity     := 99;

  lyt.BringToFront;

  LWhitSnc := round(lytBtn.Width / 3);
  LWhitSn  := round(lytBtn.Width / 2);

  rountRectSncSim.Width      := LWhitSnc;
  rountRectSncNao.Width      := LWhitSnc;
  rountRectSncCancelar.Width := LWhitSnc;

  rountRectSnSim.Margins.Left  := Round(lytBtn.Width / 14);
  rountRectSnNao.Margins.Right := Round(lytBtn.Width / 14);
end;

procedure TFormMsg.rountRectSncSimMouseEnter(Sender: TObject);
begin
  PintaRectangle(Sender);
end;

procedure TFormMsg.rountRectSncSimMouseLeave(Sender: TObject);
begin
  DesPintaRectangle(Sender);
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

procedure TFormMsg.SetResult(aBtn: TpBtnMsg);
begin
  case aBtn of
    btrSim,btrOk:
      begin
        if Assigned(aProc) then
          aProc;
      end;
  end;
  FechaTela(FormMsg);
end;

end.
