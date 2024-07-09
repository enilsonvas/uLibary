unit uAuxMetodosServer;

interface

uses
  System.SysUtils,
  System.Classes;

  function FormataValorSql(aValue: Double): string;

  procedure CapturaErro(E: Exception; Modulo: string);


implementation

procedure CapturaErro(E: Exception; Modulo: string);
begin
  var Erro := TStringList.Create;

  Erro.Add(E.Message);
  Erro.SaveToFile(ExtractFilePath(ParamStr(0))+'ERRO_'+Modulo+'_'+DateTimeToStr(Now));
end;

function FormataValorSql(aValue: Double): string;
begin
  if TFormatSettings.Create.CurrencyString = 'R$' then
    Result := aValue.Tostring.replace(',', '.').QuotedString
  else
    Result := aValue.Tostring.replace('.', ',').QuotedString;

end;

end.
