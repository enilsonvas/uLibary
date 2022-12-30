unit uAuxMetodos;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Threading,

  Data.DB,


  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.DialogService,
  FMX.VirtualKeyboard,
  FMX.Platform,
  FMX.ListBox,
  FMX.TabControl,

  uFrmLoad,
  RESTRequest4D,
  uThrdLoad,
  uComboBox,
  uTipos;


type
  TClassePreco = class
  private
    FPreco: Double;
    FClasse: string;
    procedure SetClasse(const Value: string);
    procedure SetPreco(const Value: Double);
  published
    property Classe: string read FClasse write SetClasse;
    property Preco: Double read FPreco write SetPreco;
  end;

    TProcedureExcept = reference to procedure(const aException: string);



//    function MessageSystem(aMsg: string; IconMsg: TpIconMsg; AButtons: TpBtnsMsg; AButtonsDef: TpBtnMsg): TpBtnMsg;

    procedure AbrirTela(aTForm: TComponentClass; var aForm; aProc: TProc=nil);
    procedure FechaTela(var aForm; aProc: TProc=nil);

    procedure AbrirTelaLoad(aTextoLoad: string);
    procedure FecharTelaLoad;

    procedure PintaRectangle(Sender: TObject);
    procedure DesPintaRectangle(Sender: TObject);

    procedure CloneRect(aRectBase: TRectangle; aVertScrooll: TVertScrollBox; var aPosicao: Single; aID: Integer); overload;
    procedure CloneRect(aRectBase: TRoundRect; aVertScrooll: TVertScrollBox; var aPosicao: Single; aID: Integer); overload;

    procedure LimpaListVbs(aRectBase: TRectangle; aVbs: TVertScrollBox); overload;
    procedure LimpaListVbs(aRectBase: TRoundRect; aVbs: TVertScrollBox); overload;

    procedure MultiThead(aStart,
                         AProcesso,
                         aTerminte: TProc;
                         AError   : TProcedureExcept = nil;
                         aCompleteInError: Boolean= true);

    procedure CarregaComboBox(aCombo: TComboBox; aDs: TDataSet; aID, aCampo: string);
    procedure SetComboValue(aCombo: TComboBox; aValue: string);
    function  GetComboValue(aCombo: TComboBox):string;

    function GetFiltroData(aDt1, aDt2: TDateTime; aCampo: string; aFiltro: string=''): string;

    function ValorFormartado(aValue: Double; Currency: Boolean=false): string;

    function MsgSystem(aMsg, aTitulo: string; aIcon: TpIconMsg; aButton: array of TpBtnMsg; aProc: TProc=nil): TpBtnMsg;

    function IsNumb(aText: string): Boolean;

    procedure TrocaTab(aTbc: TTabControl; aTbSrc: TTabItem);

    procedure EscondeTeclado;


var
  Ld: LoadTela;
  aBtnRes : TBtnResult;
  aProcExe: TProc;
  ThrID: Integer;


implementation

uses uFrmBase, uFrmMsg;

procedure PintaRectangle(Sender: TObject);
begin
  if Sender is TRectangle then
    (Sender as TRectangle).Fill.Kind := TBrushKind.Gradient
  else if Sender is TRoundRect then
    (Sender as TRoundRect).Fill.Kind := TBrushKind.Gradient
end;

procedure DesPintaRectangle(Sender: TObject);
begin
  if Sender is TRectangle then
    (Sender as TRectangle).Fill.Kind := TBrushKind.Solid
  else if Sender is TRoundRect then
    (Sender as TRoundRect).Fill.Kind := TBrushKind.Solid;
end;

procedure EscondeTeclado;
{$IFDEF ANDROID}
var
  FService: IFMXVirtualKeyboardService;
{$ENDIF}
begin
  {$IFDEF ANDROID}
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));

  if (FService <> nil) and
     (TVirtualKeyboardState.Visible in FService.VirtualKeyboardState) then
    FService.HideVirtualKeyboard;
  {$ENDIF}
end;

function IsNumb(aText: string): Boolean;
var
  I:Integer;
  Str: string;
begin
  Result := False;
  Str := aText;

  for I := 0 to Length(Str) do
    begin
      if not (Str[i] in ['0'..'9']) then
        Result := True
      else
        begin
          Result := False;
          Break;
        end;
    end;
end;

function MsgSystem(aMsg, aTitulo: string; aIcon: TpIconMsg; aButton: array of TpBtnMsg; aProc: TProc=nil): TpBtnMsg;
begin

  if not Assigned(TForm(FormMsg)) then
    Application.CreateForm(TFormMsg, FormMsg);

  FormMsg.CarregaIcon(aIcon);
  FormMsg.CarregaBtn(aButton);
  FormMsg.CarregaMsgCap(aMsg, aTitulo);
//  FormMsg.aProcExec := aProc;

  if not Assigned(aBtnRes) then
    aBtnRes := TBtnResult.Create;

  FormMsg.aBtnResult := aBtnRes;

  FormBase.lytPrincipal.AddObject(FormMsg.lytFormMsg);
end;

procedure CarregaComboBox(aCombo: TComboBox; aDs: TDataSet; aID, aCampo: string);
begin
  LoadComboBoxDataSet(aCombo, aDs, aID, aCampo);
end;

function GetComboValue(aCombo: TComboBox):string;
begin
  Result := GetIdComboBox(aCombo);
end;

function GetFiltroData(aDt1, aDt2: TDateTime; aCampo: string; aFiltro: string=''): string;
begin
  if aFiltro <> '' then
    Result := aFiltro+' and ('+aCampo+' between '+FormatDateTime('yyyy-mm-dd 00:00:00', aDt1).QuotedString+' and '+FormatDateTime('yyyy-mm-dd 00:00:00', aDt2).QuotedString+')'
  else
    Result := '('+aCampo+' between '+FormatDateTime('yyyy-mm-dd 00:00:00', aDt1).QuotedString+' and '+FormatDateTime('yyyy-mm-dd 00:00:00', aDt2).QuotedString+')';
end;

procedure SetComboValue(aCombo: TComboBox; aValue: string);
begin
  SetIdComboBox(aCombo, aValue);
end;

procedure AbrirTela(aTForm: TComponentClass; var aForm; aProc: TProc=nil);
begin
  if not Assigned(TForm(aForm)) then
    Application.CreateForm(aTForm, aForm);

  if FormBase.lytPrincipal.ControlsCount > 0 then
    FormBase.lytPrincipal.Controls.Items[FormBase.lytPrincipal.ControlsCount-1].Visible := False;

  FormBase.lytPrincipal.AddObject((TForm(aForm).FindComponent('lyt'+TForm(aForm).Name) as TLayout));

  if Assigned(aProc) then
   aProc;
end;

procedure FechaTela(var aForm; aProc: TProc=nil);
begin
  FormBase.lytPrincipal.RemoveObject((TForm(aForm).FindComponent('lyt'+TForm(aForm).Name) as TLayout));

  FormBase.lytPrincipal.Controls.Items[FormBase.lytPrincipal.ControlsCount-1].Visible := True;

  if Assigned(aProc) then
    aProc;

  FreeAndNil(TForm(aForm));
end;

procedure AbrirTelaLoad(aTextoLoad: string);
begin
 if not Assigned(FormLoad) then
   Application.CreateForm(TFormLoad, FormLoad);


  FormLoad.rctPrincipal.Fill.Color := TAlphaColorRec.Alpha;
  FormLoad.rctPrincipal.Opacity := 99;
  FormLoad.Mensagem.Text     := aTextoLoad;

  FormBase.lytPrincipal.AddObject(FormLoad.lyt);
end;

procedure FecharTelaLoad;
begin
  FormBase.lytPrincipal.RemoveObject(FormLoad.lyt);
  FormLoad.DisposeOf;
  FormLoad := nil;
end;

procedure CloneRect(aRectBase: TRectangle; aVertScrooll: TVertScrollBox; var aPosicao: Single; aID: Integer);
var
  aRectClone: TRectangle;
  I: Integer;
begin
  aRectClone            := TRectangle(aRectBase.Clone(aVertScrooll));
  aRectClone.Parent     := aVertScrooll;
  aRectClone.Tag        := aID;
  aRectClone.Name       := aRectBase.Name+'_'+aID.ToString;
  aRectClone.Position.Y := aPosicao;
  aRectClone.Position.X := 4;
  aRectClone.Height     := aRectBase.Height;
  aRectClone.Width      := aVertScrooll.Width - 12;

  for I := 0 to aRectBase.ChildrenCount -1 do
    begin
      if (aRectBase.Children.Items[i] is TImage) then
        begin
          (aRectClone.Children.Items[i] as TImage).OnClick := (aRectBase.Children.Items[i] as TImage).OnClick;
          (aRectClone.Children.Items[i] as TImage).Name    := (aRectBase.Children.Items[i] as TImage).Name+'_img'+aID.ToString;
          (aRectClone.Children.Items[i] as TImage).Tag     := aID;
        end;

    end;

  aRectClone.Opacity     := 1;

  aRectClone.Visible := True;
  aPosicao := aPosicao + aRectBase.Height + 4;

  aVertScrooll.AddObject(aRectClone);
end;

procedure CloneRect(aRectBase: TRoundRect; aVertScrooll: TVertScrollBox; var aPosicao: Single; aID: Integer);
var
  aRectClone: TRoundRect;
  I: Integer;
begin
  aRectClone            := TRoundRect(aRectBase.Clone(aVertScrooll));
  aRectClone.Parent     := aVertScrooll;
  aRectClone.Tag        := aID;
  aRectClone.Name       := aRectBase.Name+'_'+aID.ToString;
  aRectClone.Position.Y := aPosicao;
  aRectClone.Position.X := 3;
  aRectClone.Height     := aRectBase.Height;
  aRectClone.Width      := aVertScrooll.Width - 5;
  aRectClone.HitTest    := false;


  for I := 0 to aRectBase.ChildrenCount -1 do
    begin
      if (aRectBase.Children.Items[i] is TImage) then
        begin
          (aRectClone.Children.Items[i] as TImage).OnClick := (aRectBase.Children.Items[i] as TImage).OnClick;
          (aRectClone.Children.Items[i] as TImage).Name    := (aRectBase.Children.Items[i] as TImage).Name+'_img'+aID.ToString;
          (aRectClone.Children.Items[i] as TImage).Tag     := aID;
        end;

    end;

  aRectBase.Opacity     := 1;

  aRectClone.Visible := True;
  aPosicao := aPosicao + aRectBase.Height + 4;
end;

procedure LimpaListVbs(aRectBase: TRectangle; aVbs: TVertScrollBox);
var
  I: Integer;
  IFrame: TRectangle;
begin
  aVbs.Visible := False;
  aVbs.BeginUpdate;
  for I := pred(aVbs.Content.ChildrenCount) downto 0 do
    begin
      if (aVbs.Content.Children[i] is TRectangle) then
        begin
          if not (TRectangle(aVbs.Content.Children[i]).Name = aRectBase.Name) then
            begin
              IFrame := (aVbs.Content.Children[i] as TRectangle);
              IFrame.DisposeOf;
              IFrame := nil;
            end;
        end;
    end;
   aVbs.EndUpdate;
   aVbs.Visible := True;
end;

procedure LimpaListVbs(aRectBase: TRoundRect; aVbs: TVertScrollBox); overload;
var
  I: Integer;
  IFrame: TRoundRect;
begin
  aVbs.Visible := False;
  aVbs.BeginUpdate;
  for I := pred(aVbs.Content.ChildrenCount) downto 0 do
  begin
    if (aVbs.Content.Children[i] is TRoundRect) then
      begin
        if not (TRoundRect(aVbs.Content.Children[i]).Name = aRectBase.Name) then
          begin
            IFrame := (aVbs.Content.Children[i] as TRoundRect);
            IFrame.DisposeOf;
            IFrame := nil;
          end;
      end;
  end;
  aVbs.EndUpdate;
  aVbs.Visible := True;
end;

function ValorFormartado(aValue: Double; Currency: Boolean=false): string;
begin
  if Currency then
    Result := FormatCurr('R$ ,#0.00', aValue)
  else
    Result := FormatCurr(',#0.00', aValue);
end;

procedure MultiThead(aStart,
                     AProcesso,
                     aTerminte: TProc;
                     AError   : TProcedureExcept = nil;
                     aCompleteInError: Boolean= true);
var
  LThread: TThread;
begin
  LThread := TThread.CreateAnonymousThread(
              procedure ()
                var
                  LComplete: Boolean;
                begin
                  try
                    try
                      //INICIO
                      LComplete := true;
                      if Assigned(aStart) then
                        begin
                          TThread.Synchronize(
                            TThread.CurrentThread,
                            procedure ()
                            begin
                              aStart;
                            end);
                        end;

                      //PRINCIPAL
                      if Assigned(AProcesso) then
                        AProcesso;


                    except on E: Exception do
                      begin
                        LComplete := aCompleteInError;

                        if Assigned(AError) then
                          begin
                            TThread.Synchronize(
                              TThread.CurrentThread,
                              procedure ()
                              begin
                                AError(e.Message);
                              end);
                          end;

                      end;
                    end;

                  finally
                    //COMPLETO
                    if Assigned(aTerminte) then
                      begin
                        TThread.Synchronize(
                          TThread.CurrentThread,
                          procedure ()
                          begin
                            aTerminte;
                          end);
                      end;

                  end;
                end
              {fim});
  LThread.FreeOnTerminate := True;
  LThread.Start;
  ThrID := LThread.ThreadID;
end;

procedure TrocaTab(aTbc: TTabControl; aTbSrc: TTabItem);
begin
  aTbc.ActiveTab := aTbSrc;
end;

{ TClassePreco }

procedure TClassePreco.SetClasse(const Value: string);
begin
  FClasse := Value;
end;

procedure TClassePreco.SetPreco(const Value: Double);
begin
  FPreco := Value;
end;

end.
