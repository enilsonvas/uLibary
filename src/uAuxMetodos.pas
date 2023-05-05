unit uAuxMetodos;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Threading,
  System.Generics.Collections,

  Data.DB,

  FMX.Edit,
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
  FMX.TabControl

  {$IFDEF IGREJA THEN}
  ,uTiposIgreja
  {$ELSE}
  ,uTipos
  {$ENDIF}

  ,uFrmLoad,
  RESTRequest4D,
  uThrdLoad,
  uComboBox;

type
  TProcedureExcept = reference to procedure(const aException: string);

  procedure AbrirTela(aTForm: TComponentClass; var aForm; aCaption: string='';  aProc: TProc=nil);
  procedure FechaTela(var aForm; aProc: TProc=nil);

  procedure PintaRectangle(Sender: TObject);
  procedure DesPintaRectangle(Sender: TObject);

  procedure CloneRect(aRectBase: TRectangle; aVertScrooll: TVertScrollBox; var aPosicao: Single; aID: Integer); overload;
  procedure CloneRect(aRectBase: TRoundRect; aVertScrooll: TVertScrollBox; var aPosicao: Single; aID: Integer); overload;

  procedure ClonaListBox(aListBox: TListBox; aListBoxItemBase: TListBoxItem; aCodigo, aDescricao: string);

  procedure LimpaListVbs(aRectBase: TRectangle; aVbs: TVertScrollBox); overload;
  procedure LimpaListVbs(aRectBase: TRoundRect; aVbs: TVertScrollBox); overload;

  procedure MultiThead(aStart,
                       AProcesso,
                       aTerminte: TProc;
                       AError   : TProcedureExcept = nil;
                       aCompleteInError: Boolean= true);

  procedure AbrirTelaLoad(aLyt: TLayout=nil);
  procedure FecharTelaLoad(aLyt: TLayout=nil);
  procedure SetAba(aTbc: TTabControl; aTbi: TTabItem);

  procedure CarregaComboBox(aCombo: TComboBox; aDs: TDataSet; aID, aCampo: string);
  procedure SetComboValue(aCombo: TComboBox; aValue: string);
  function  GetComboValue(aCombo: TComboBox):string;

  function GetFiltroData(aDt1, aDt2: TDateTime; aCampo: string; aFiltro: string=''): string;

  function ValorFormartado(aValue: Double; Currency: Boolean=false): string;

  procedure MsgSystem(aMsg, aTitulo: string;
                      aIcon: TpIconMsg;
                      aButton: array of TpBtnIcon;
                      aStyle: TStyleBook=nil;
                      aProc: TProc=nil);

  function IsNumb(aText: string): Boolean;

  procedure EscondeTeclado;

  function InputMaskCnpjCpf(sValor: string): string;

  function ThreadExecution(aProccessment: TProc) : TThread;
  function LimparMascara(aText: string): string;

var
  Ld: LoadTela;
  aProcTeclado, aProcBackButton, AfterTeclado: TProc;
  ThrID: Integer;

implementation

uses uFrmBase, uFrmMsg;

function LimparMascara(aText: string): string;
begin
  Result := aText.Replace('R$', '').Replace('.', '').Trim;
end;

function ThreadExecution(aProccessment: TProc) : TThread;
begin
  Result := TThread.CreateAnonymousThread(
  procedure
  begin
    aProccessment;
  end);

  Result.FreeOnTerminate := True;

end;

function InputMaskCnpjCpf(sValor: string): string;
var
  sTemp: string;
begin
  sTemp := sValor;
  if Length(sTemp) = 14 then
    Result := Copy(sTemp, 1, 2)+'.'+Copy(sTemp, 3, 3)+'.'+Copy(sTemp, 6, 3)+'/'+Copy(sTemp, 9, 4)+'-'+Copy(sTemp, 13, 2)
  else if Length(sTemp) = 11 then
    Result := Copy(sTemp, 1, 3)+'.'+Copy(sTemp, 4, 3)+'.'+Copy(sTemp, 7, 3)+'-'+Copy(sTemp, 10, 2);
end;

procedure SetAba(aTbc: TTabControl; aTbi: TTabItem);
begin
  aTbc.ActiveTab := aTbi;
end;

procedure ClonaListBox(aListBox: TListBox; aListBoxItemBase: TListBoxItem; aCodigo, aDescricao: string);
var
  LListClone: TListBoxItem;
begin
  LListClone := TListBoxItem(aListBoxItemBase.Clone(aListBox));

  LListClone.Parent          := aListBox;
  LListClone.ItemData.Detail := aCodigo;
  LListClone.ItemData.Text   := aDescricao;
  LListClone.Visible         := true;
  LListClone.Tag             := aCodigo.ToInteger;

  aListBox.Content.AddObject(LListClone);
end;

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

procedure MsgSystem(aMsg, aTitulo: string;
                    aIcon: TpIconMsg;
                    aButton: array of TpBtnIcon;
                    aStyle: TStyleBook;
                    aProc: TProc);
begin
  if not Assigned(TForm(FormMsg)) then
    Application.CreateForm(TFormMsg, FormMsg);

  FormMsg.CarregaStyle(aStyle);

  FormMsg.CarregaIcon(aIcon);
  FormMsg.CarregaBtn(aButton);
  FormMsg.CarregaMsgCap(aMsg, aTitulo);

  FormMsg.aProc := aProc;

  FormBase.lytPrincipal.AddObject(FormMsg.lyt);
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

procedure AbrirTela(aTForm: TComponentClass; var aForm; aCaption: string; aProc: TProc);
var
  idx: Integer;
begin
  if not Assigned(TForm(aForm)) then
    Application.CreateForm(aTForm, aForm);

  idx := 0;
  if FormBase.lytPrincipal.ControlsCount > 0 then
    begin
      FormBase.lytPrincipal.Controls.Items[FormBase.lytPrincipal.ControlsCount-1].Visible := False;
      idx := FormBase.lytPrincipal.ControlsCount;
    end;

  if TForm(aForm).FindComponent('lyt'+TForm(aForm).Name) <> nil then
    begin
      FormBase.lytPrincipal.InsertObject(idx,(TForm(aForm).FindComponent('lyt'+TForm(aForm).Name) as TLayout));
      FormBase.lytPrincipal.Controls[idx].BringToFront;
    end
  else
    raise Exception.Create('componente layout não configurado.');

  if TForm(aForm).FindComponent('lblTitulo') <> nil then
    TLabel(TForm(aForm).FindComponent('lblTitulo')).Text := aCaption;

  if Assigned(aProc) then
   aProc;
end;

procedure FechaTela(var aForm; aProc: TProc=nil);
begin
  FormBase.lytPrincipal.RemoveObject((TForm(aForm).FindComponent('lyt'+TForm(aForm).Name) as TLayout));

  if FormBase.lytPrincipal.ControlsCount > 0 then
    FormBase.lytPrincipal.Controls.Items[FormBase.lytPrincipal.ControlsCount-1].Visible := True;

  if Assigned(aProc) then
    aProc;

  FreeAndNil(TForm(aForm));
end;

procedure AbrirTelaLoad(aLyt: TLayout);
begin
 if not Assigned(FormLoad) then
   Application.CreateForm(TFormLoad, FormLoad);


  FormLoad.rctPrincipal.Fill.Color := TAlphaColorRec.Alpha;
  FormLoad.rctPrincipal.Opacity := 99;
  FormLoad.Mensagem.Text        := 'Carregando dados';

  if aLyt = nil then
    FormBase.lytPrincipal.AddObject(FormLoad.lytLoad)
  else
    aLyt.AddObject(FormLoad.lytLoad);
end;

procedure FecharTelaLoad(aLyt: TLayout);
begin
  if aLyt = nil then
    FormBase.lytPrincipal.RemoveObject(FormLoad.lytLoad)
  else
    aLyt.RemoveObject(FormLoad.lytLoad);

  FreeAndNil(FormLoad);
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

  aPosicao := aPosicao + aRectBase.Height + 4;

  aRectClone.Visible := True;

  aVertScrooll.Content.AddObject(aRectClone);
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
  for I := aVbs.Content.ChildrenCount-1 downto 0 do
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

 TTask.Run(procedure ()
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
                end);

//  LThread := TThread.CreateAnonymousThread(
//              procedure ()
//                var
//                  LComplete: Boolean;
//                begin
//                  try
//                    try
//                      //INICIO
//                      LComplete := true;
//                      if Assigned(aStart) then
//                        begin
//                          TThread.Synchronize(
//                            TThread.CurrentThread,
//                            procedure ()
//                            begin
//                              aStart;
//                            end);
//                        end;
//
//                      //PRINCIPAL
//                      if Assigned(AProcesso) then
//                        AProcesso;
//
//                    except on E: Exception do
//                      begin
//                        LComplete := aCompleteInError;
//
//                        if Assigned(AError) then
//                          begin
//                            TThread.Synchronize(
//                              TThread.CurrentThread,
//                              procedure ()
//                              begin
//                                AError(e.Message);
//                              end);
//                          end;
//
//                      end;
//                    end;
//
//                  finally
//                  //COMPLETO
//                    if Assigned(aTerminte) then
//                      begin
//                        TThread.Synchronize(
//                          TThread.CurrentThread,
//                          procedure ()
//                          begin
//                            aTerminte;
//                          end);
//                      end;
//                  end;
//                end
//              {fim});
//  LThread.FreeOnTerminate := True;
//  LThread.Start;
//  ThrID := LThread.ThreadID;
end;


end.
