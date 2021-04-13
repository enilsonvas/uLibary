unit uLibary;

interface

type
  TpVerbo = (aGet, aPost, aPut, aDelete, aPacht);

  TpRequest = (rProd, rProdEmb, rProdclasse);


  function StrTpRequest(aRequest: TpRequest): string;

implementation

function StrTpRequest(aRequest: TpRequest): string;
begin
  case aRequest of
    rProd      : Result := 'prod';
    rProdEmb   : Result := 'prodemb';
    rProdclasse: Result := 'prodclasse';
  end;
end;

end.
