unit uConversorBase64.Interfaces;

interface

uses
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
  iBase64Converter = interface
    ['{FA4A859B-B1E8-4C8D-A2C8-2B3903FC5E92}']
    function BlobToBase64(aField: TField): string;
    function Base64ToBitmap(aValue : string) : TBitmap;
    function Base64ToStream(aValue : string) : TStream;
    function Base64ToImage(aValue : string; aOwner : TComponent = nil) : TImage;
  end;

  iBase64ConverterFactory = interface
    ['{6B985B7B-C59C-4EDD-8282-26F090B655B3}']
    function Base64: iBase64Converter;
  end;

implementation

end.
