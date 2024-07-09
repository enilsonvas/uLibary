unit uMetodosGerais;

interface

uses
  System.UITypes,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,
  System.Threading,

  Winapi.Windows,
  Winapi.Messages,

  Vcl.Graphics,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Controls,

  Data.DB,

  uVclLoadTela;


  type

  TpCalc= (tVlr, tPer);

  function SoNumero(aValue: string): Boolean;
  procedure CarregaUF(aList: TStrings);
  procedure ZeraCampos(aDs: TDataSet);
  procedure CalcValorXPerc(aTipo: TpCalc; Total: Double; var Valor: Double; var Perc: Double);

  procedure CarregarTela(InstanceClass: TComponentClass; var Reference; Empresa: string=''; Maximizado: Boolean=true);
  procedure FecharTela(var Reference);

  function IncrementaSFiltro(aFiltro, sValor: string): string;

  procedure CarregamentoThread(AProcesso: TProc);
var
  IconSistema: TMemoryStream;
  aFormBase: TForm;

implementation

procedure CarregamentoThread(AProcesso: TProc);
begin
 TTask.Run(procedure ()
               begin
                  try
                    try
                      //INICIO
                      TThread.Synchronize(
                        TThread.CurrentThread,
                        procedure ()
                        begin
                          Application.CreateForm(TFormTelaLoad, FormTelaLoad);
                          {$IFDEF RELEASE THEN}
                          FormTelaLoad.Show;
                          {$IFEND}
                        end);

                      //PRINCIPAL
                      if Assigned(AProcesso) then
                        AProcesso;

                    except on E: Exception do
                      begin
                        TThread.Synchronize(
                          TThread.CurrentThread,
                          procedure ()
                          begin
                            FreeAndNil(FormTelaLoad);
                            Application.MessageBox(Pchar('Erro de execução:'+E.Message), 'Aviso', MB_OK+MB_ICONEXCLAMATION);
                          end);
                      end;
                    end;

                  finally
                    //COMPLETO
                    TThread.Synchronize(
                      TThread.CurrentThread,
                      procedure ()
                      begin
                        FreeAndNil(FormTelaLoad);
                      end);
                  end;
                end);
end;

function IncrementaSFiltro(aFiltro, sValor: string): string;
begin
  if aFiltro <> '' then
    Result := aFiltro+' - '+sValor
  else
    Result := sValor;
end;

procedure CalcValorXPerc(aTipo: TpCalc; Total: Double; var Valor: Double; var Perc: Double);
begin
  case aTipo of
    tVlr: Perc  := SimpleRoundTo((Valor / Total) * 100);
    tPer: Valor := SimpleRoundTo((Total * Perc) / 100);
  end;
end;

procedure ZeraCampos(aDs: TDataSet);
var
  I: Integer;
begin
  for I := 0 to aDs.FieldCount -1 do
    begin
      if aDs.Fields[i].IsNull then
        case aDs.Fields[i].DataType of
          ftInteger  : aDs.Fields[i].AsVariant := 0;
          ftFloat    : aDs.Fields[i].AsVariant := 0;
          ftCurrency : aDs.Fields[i].AsVariant := 0;
        end;
    end;
end;

procedure CarregaUF(aList: TStrings);
begin
  aList.Clear;
  aList.Add('');
  aList.Add('AC');
  aList.Add('AL');
  aList.Add('AM');
  aList.Add('AP');
  aList.Add('BA');
  aList.Add('CE');
  aList.Add('DF');
  aList.Add('ES');
  aList.Add('GO');
  aList.Add('MA');
  aList.Add('MG');
  aList.Add('MS');
  aList.Add('MT');
  aList.Add('PA');
  aList.Add('PB');
  aList.Add('PE');
  aList.Add('PI');
  aList.Add('PR');
  aList.Add('RJ');
  aList.Add('RN');
  aList.Add('RO');
  aList.Add('RR');
  aList.Add('RS');
  aList.Add('SC');
  aList.Add('SE');
  aList.Add('SP');
  aList.Add('TO');
end;

procedure CarregarTela(InstanceClass: TComponentClass; var Reference; Empresa: string=''; Maximizado: Boolean=true);
begin
   if not Assigned(TForm(Reference)) then
    Application.CreateForm(InstanceClass, Reference);

  {$IFDEF RELEASE THEN}
  TForm(Reference).FormStyle    := fsStayOnTop;
  {$ELSE IFDEF DEBUG THEN}
  TForm(Reference).FormStyle      := fsNormal;
  {$endif}
  TForm(Reference).DefaultMonitor := dmActiveForm;
  if Empresa <> '' then
    TForm(Reference).Caption        := 'Tech Nil - '+Empresa+' - '+TForm(Reference).Caption
  else
    TForm(Reference).Caption        := 'Tech Nil - '+TForm(Reference).Caption;


  if Maximizado then
    begin
      TForm(Reference).WindowState := TWindowState.wsMaximized;

      if aFormBase <> nil then
        begin
          TForm(Reference).WindowState := TWindowState.wsNormal;

          TForm(Reference).Height := aFormBase.Height;
          TForm(Reference).Width  := aFormBase.Width-50;
          TForm(Reference).Left   := aFormBase.Left+50;
          TForm(Reference).Top    := aFormBase.Top;
        end
      else
        TForm(Reference).Position := poMainFormCenter;
    end
  else
    TForm(Reference).Position := poMainFormCenter;

  if Assigned(IconSistema) then
    begin
      IconSistema.Position := 0;
      TForm(Reference).Icon.LoadFromStream(IconSistema);
    end;

  TForm(Reference).Show;
end;

procedure FecharTela(var Reference);
begin
  if Assigned(TForm(Reference)) then
    FreeAndNil(TForm(Reference));
end;

function SoNumero(aValue: string): Boolean;
var
  i: Integer;
  TemLetra, Temnumero: Boolean;
begin
  TemLetra  := False;
  Temnumero := False;

  for I := 1 to Length(aValue) do
    begin
      if (aValue[i] in ['0'..'9']) then
        Temnumero := True
      else
        TemLetra := True;
    end;

  Result := ((Temnumero) and not (TemLetra));
end;

end.
