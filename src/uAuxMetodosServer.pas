unit uAuxMetodosServer;

interface

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.StrUtils,
  System.VarUtils,
  System.Variants;

type

  TpDt = (aDtNone, aDtIni, aDtFim);

  function FormataValorSql(aValue: Double): string;
  function FormataDataSql(aValue: TDateTime; aFormat: TpDt=aDtNone): string;
  function StrVazioToNull(aValue: string): Variant;
  function RemoveMascaras(aInput: string): string;

  procedure CapturaErro(E: Exception; Modulo: string);


implementation

function FormataDataSql(aValue: TDateTime; aFormat: TpDt): string;
begin
  case aFormat of
    aDtNone: Result := aValue.Format('yyyy-mm-dd');
    aDtIni : Result := aValue.Format('yyyy-mm-dd 00:00:00');
    aDtFim : Result := aValue.Format('yyyy-mm-dd 23:59:59');
  end;
end;

procedure CapturaErro(E: Exception; Modulo: string);
begin
  var Erro := TStringList.Create;

  Erro.Add(E.Message);
  Erro.SaveToFile(ExtractFilePath(ParamStr(0))+'\LOG_'+Modulo+'_'+Now.Format('yyyy-mm-dd hh-nn-ss'));
end;

function FormataValorSql(aValue: Double): string;
begin
  if TFormatSettings.Create.CurrencyString = 'R$' then
    Result := aValue.Tostring.replace(',', '.').QuotedString
  else
    Result := aValue.Tostring.replace('.', ',').QuotedString;

end;

function StrVazioToNull(aValue: string): Variant;
begin
  Result := Null;
  if not aValue.IsEmpty then
    Result := aValue;
end;

function RemoveMascaras(aInput: string): string;
begin
  Result := aInput.Replace('(', '', [rfReplaceAll])
                  .Replace(')', '', [rfReplaceAll])
                  .Replace('-', '', [rfReplaceAll])
                  .Replace('.', '', [rfReplaceAll])
                  .Replace(' ', '', [rfReplaceAll])
                  .Replace('/', '', [rfReplaceAll]).Trim;
end;

end.
