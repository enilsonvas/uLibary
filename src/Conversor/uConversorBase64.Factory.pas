unit uConversorBase64.Factory;

interface

uses
  System.SysUtils,
  System.Classes,

  uConversorBase64.Interfaces,
  uConversorBase64;

type
  TBase64Factory = class(TInterfacedObject, iBase64ConverterFactory)
    class function New: iBase64ConverterFactory;
    function Base64: iBase64Converter;
  end;

implementation

{ TBase64Factory }

function TBase64Factory.Base64: iBase64Converter;
begin
  Result := TBase64Converter.New;
end;

class function TBase64Factory.New: iBase64ConverterFactory;
begin
  Result := Self.Create;
end;

end.
