unit uConversorBase64;

interface

uses
  uConversorBase64.Interfaces,
  Data.DB,
  System.NetEncoding,
  System.Classes
  {$IFDEF VCL}
    , VCL.Graphics
  {$ELSE}
    , FMX.Graphics,
    FMX.Objects
  {$ENDIF}
  ;

type
  TBase64Converter = class(TInterfacedObject, iBase64Converter)
    class function New : iBase64Converter;
    function BlobToBase64(aField: TField): string;
    function Base64ToBitmap(aValue : string) : TBitmap;
    function Base64ToStream(aValue : string) : TStream;
    function Base64ToImage(aValue : string; aOwner : TComponent = nil) : TImage;
  end;

implementation

uses
  System.SysUtils;

{ TBase64Converter }

function TBase64Converter.Base64ToBitmap(aValue : string) : TBitmap;
var
  lInput, lOutPut : TStringStream;
begin
  Result := nil;
  if aValue.Trim.IsEmpty then
    Exit;

  lInput := TStringStream.Create(aValue);
  lOutPut := TStringStream.Create;
  try
    lInput.Position := 0;
    TNetEncoding.Base64.Decode(lInput, lOutput);
    lOutput.Position := 0;
    Result := TBitmap.Create;
    Result.LoadFromStream(lOutput);
  finally
    if Assigned(lInput) then
      lInput.DisposeOf;

    if Assigned(lOutPut) then
      lOutPut.DisposeOf;
  end;
end;

function TBase64Converter.Base64ToImage(aValue : string; aOwner : TComponent) : TImage;
var
  lInput, lOutPut : TStringStream;
begin
  Result := nil;
  if aValue.Trim.IsEmpty then
    Exit;

  lInput := TStringStream.Create(aValue);
  lOutPut := TStringStream.Create;
  try
    lInput.Position := 0;
    TNetEncoding.Base64.Decode(lInput, lOutput);
    lOutput.Position := 0;
    Result := TImage.Create(aOwner);
    Result.MultiResBitmap.LoadItemFromStream(lOutput, 1);
  finally
    if Assigned(lInput) then
      lInput.DisposeOf;

    if Assigned(lOutPut) then
      lOutPut.DisposeOf;
  end;
end;

function TBase64Converter.Base64ToStream(aValue: string): TStream;
var
  lInput : TStringStream;
begin
  Result := nil;
  if aValue.Trim.IsEmpty then
    Exit;

  lInput := TStringStream.Create(aValue);
  Result := TStringStream.Create;
  try
    try
      lInput.Position := 0;
      TNetEncoding.Base64.Decode(lInput, Result);
      Result.Position := 0;
    except on E: Exception do
      if Assigned(Result) then
        Result.DisposeOf;
    end;
  finally
    if Assigned(lInput) then
      lInput.DisposeOf;
  end;
end;

function TBase64Converter.BlobToBase64(aField: TField): string;
var
  lInput, lOutput : TStringStream;
begin
  lInput := TStringStream.Create;
  lOutput := TStringStream.Create;
  try
    TBlobField(aField).SaveToStream(lInput);
    lInput.Position := 0;
    TNetEncoding.Base64.Encode(LInput, LOutput);
    lOutput.Position := 0;
    Result := lOutput.DataString;
  finally
    lInput.DisposeOf;
    lOutput.DisposeOf;
  end;
end;

class function TBase64Converter.New: iBase64Converter;
begin
  Result := Self.Create;
end;

end.
