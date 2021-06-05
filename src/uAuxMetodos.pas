unit uAuxMetodos;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
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


  uFrmLoad,
  DataSetConverter4D.Helper,
  uThrdLoad,
  FMX.ListBox,
  uComboBox,
  uTipos;


  type
    TProcedureExcept = reference to procedure(const aException: string);

    function MessageSystem(aMsg: string; IconMsg: TpIconMsg; AButtons: TpBtnsMsg; AButtonsDef: TpBtnMsg): TpBtnMsg;

    procedure AbrirTela(aTForm: TComponentClass; var aForm);
    procedure FechaTela(var aForm);

    procedure AbrirTelaLoad(aTextoLoad: string);
    procedure FecharTelaLoad;

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
    function GetComboValue(aCombo: TComboBox):string;

    function GetFiltroData(aDt1, aDt2: TDateTime; aCampo: string; aFiltro: string=''): string;

    function ValorFormartado(aValue: Double): string;

var
  Ld: LoadTela;


implementation

uses uFrmBase;

function MessageSystem(aMsg: string; IconMsg: TpIconMsg; AButtons: TpBtnsMsg;
  AButtonsDef: TpBtnMsg): TpBtnMsg;
var
  rIconMsg: System.UITypes.TMsgDlgType;
  rButtonDef: System.UITypes.TMsgDlgBtn;
  mrButon: TModalResult;
  rButtons: TMsgDlgButtons;
begin
  case IconMsg of
    icConfimation:
      rIconMsg := System.UITypes.TMsgDlgType.mtConfirmation;
    icInfo:
      rIconMsg := System.UITypes.TMsgDlgType.mtInformation;
    icError:
      rIconMsg := System.UITypes.TMsgDlgType.mtWarning;
  end;

  case AButtonsDef of
    btrYes:
      rButtonDef := System.UITypes.TMsgDlgBtn.mbYes;
    btrNo:
      rButtonDef := System.UITypes.TMsgDlgBtn.mbNo;
    btrCancel:
      rButtonDef := System.UITypes.TMsgDlgBtn.mbCancel;
  end;

  if AButtons = [btrYes, btrNo, btrCancel] then
    rButtons := [System.UITypes.TMsgDlgBtn.mbYes,
      System.UITypes.TMsgDlgBtn.mbNo, System.UITypes.TMsgDlgBtn.mbCancel]
  else if AButtons = [btrYes, btrNo] then
    rButtons := [System.UITypes.TMsgDlgBtn.mbYes,
      System.UITypes.TMsgDlgBtn.mbNo]
  else if AButtons = [btrYes] then
    rButtons := [System.UITypes.TMsgDlgBtn.mbYes]
  else if AButtons = [btrNo] then
    rButtons := [System.UITypes.TMsgDlgBtn.mbNo]
  else if AButtons = [btrCancel] then
    rButtons := [System.UITypes.TMsgDlgBtn.mbCancel];

  TDialogService.MessageDialog(aMsg, rIconMsg, rButtons, rButtonDef, 0,
    procedure(const aResult: TModalResult)
    begin
      mrButon := aResult;
    end);

  case mrButon of
    mrYes:
      Result := btrYes;
    mrNo:
      Result := btrNo;
    mrCancel:
      Result := btrCancel;
  end;

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

procedure AbrirTela(aTForm: TComponentClass; var aForm);
begin
  if not Assigned(TForm(aForm)) then
    Application.CreateForm(aTForm, aForm);

  if FormBase.lytPrincipal.ControlsCount > 0 then
    FormBase.lytPrincipal.Controls.Items[FormBase.lytPrincipal.ControlsCount-1].Visible := False;

  FormBase.lytPrincipal.AddObject((TForm(aForm).FindComponent('lyt'+TForm(aForm).Name) as TLayout));
end;

procedure FechaTela(var aForm);
begin
  FormBase.lytPrincipal.RemoveObject((TForm(aForm).FindComponent('lyt'+TForm(aForm).Name) as TLayout));

  FormBase.lytPrincipal.Controls.Items[FormBase.lytPrincipal.ControlsCount-1].Visible := True;

  FreeAndNil(TForm(aForm));
end;

procedure AbrirTelaLoad(aTextoLoad: string);
begin
 if not Assigned(FormLoad) then
   Application.CreateForm(TFormLoad, FormLoad);


  FormLoad.rctPrincipal.Fill.Color := TAlphaColorRec.Alpha;

  FormLoad.rctPrincipal.Opacity := 99;
  FormLoad.lblProcesso.Text     := aTextoLoad;

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

function ValorFormartado(aValue: Double): string;
begin
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
end;

end.