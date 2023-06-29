unit uAuxMetodosServer;

interface

uses
  System.SysUtils,
  System.Classes;

  function FormataValorSql(aValue: Double): string;
implementation

function FormataValorSql(aValue: Double): string;
begin
  if TFormatSettings.Create.CurrencyString = 'R$' then
    Result := aValue.Tostring.replace(',', '.').QuotedString
  else
    Result := aValue.Tostring.replace('.', ',').QuotedString;
end;

end.
