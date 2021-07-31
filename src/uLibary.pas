unit uLibary;

interface

uses
  System.SysUtils,
  System.NetEncoding,

  IdHashMessageDigest,

  Data.DB;

  type
  TParamValue = class
    nParam: string;
    vParam: string;
    tParam: TField;
  end;

  TpPrmsProd = (pProdId, pProdNome,  pProdMarca, pProdGrupo, pProdSubgrupo);

  TpVerbo = (aGet, aPost, aPut, aDelete, aPacht);

  TpRequest = (reqConexao,
               reqQuery,
               reqPagtoForma,
               reqPagtoPrazo,
               reqCidades,

               //produtos
               {$region}
               reqProd,

               reqProdEmb,
               reqProdEmbId,

               reqProdPreco,
               reqProdPrecoId,
               {$endregion}

               reqCliGet,

               reqCli,
               reqCliId,
               reqCliQry,

               reqClieEnder,
               reqClieEnderId,
               reqClieEnderQry,

               reqCliVend,
               reqClieEnderVend,

               reqPedidoId,
               reqMovPedidos,
               reqMovPedidosItens,
               reqPedido,
               reqPedidoItem,
               reqPesqpedidos,

               reqPesqCliente,
               reqPesqProduto,

               reqUser,
               reqUserLoginId
               );

  function StrTpRequest(aRequest: TpRequest): string;

  function StrTpPrmsProd(aValue: string): TpPrmsProd;

  function TpPrmsProdStr(aValue: TpPrmsProd): string;

  function MontaPrms(aValue: string; aFilter: string=''): string;

  function Encode(aValue: string): string;
  function Decode(aValue: string): string;
  function CriptografiaMD5(Texto: string): string;
  function IsNumb(aText: string): Boolean;



implementation

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

function CriptografiaMD5(Texto: string): string;
var
  idMd5: TIdHashMessageDigest5;
begin
  Result := '';
  try
    idMd5 := TIdHashMessageDigest5.Create;
    if (Texto <> '') then
      begin
        Result := idMd5.HashStringAsHex(Texto);
      end;
  finally
    FreeAndNil(idMd5);
  end;
end;

function StrTpRequest(aRequest: TpRequest): string;
begin
  case aRequest of
    reqConexao: Result := '/conexao';
    reqQuery  : Result := '/query';

    reqPagtoPrazo  : Result := '/prazopagto';
    reqPagtoForma  : Result := '/formapagto';

    reqCidades     : Result := '/cidades';

    reqPedidoId        : Result := '/idpedido';
    reqMovPedidos      : Result := '/movpedidos';
    reqMovPedidosItens : Result := '/movpedidositens';
    reqPedido          : Result := '/pedido';
    reqPedidoItem      : Result := '/pedidoitem';

    reqPesqpedidos: Result := '/pesqpedidos';
    reqPesqCliente: Result := '/pesqcliente';
    reqPesqProduto: Result := '/pesqproduto';

    reqProd       : Result := '/prod';

    reqProdEmb    : Result := '/prodemb';
    reqProdEmbID  : Result := '/prodemb/:id';

    reqProdPreco    : Result := '/prodclasse';
    reqProdPrecoId  : Result := '/prodclasse/:id';

    reqCliGet        : Result := '/getcli';
    reqCli           : Result := '/cli';
    reqCliId         : Result := '/cli/:id';
    reqCliVend       : Result := '/clivend/:id';
    reqCliQry        : Result := '/cliqry/:qry';

    reqClieEnder     : Result := '/cliender';
    reqClieEnderId   : Result := '/cliender/:id';
    reqClieEnderQry  : Result := '/cliender/:qry';
    reqClieEnderVend : Result := '/cliendervend/:id';

    reqUser       : Result := '/user';
    reqUserLoginId: Result := '/user/:id/:password';

  end;
end;

function TpPrmsProdStr(aValue: TpPrmsProd): string;
begin
  case aValue of
    pProdId      : Result := 'prodid';
    pProdNome    : Result := 'prodnome';
    pProdMarca   : Result := 'prodmarca';
    pProdGrupo   : Result := 'prodgrupo';
    pProdSubgrupo: Result := 'prodsubgrupo';
  end;
end;

function StrTpPrmsProd(aValue: string): TpPrmsProd;
begin
  if aValue = 'prodid' then
    Result := pProdId
  else if aValue = 'prodnome' then
    Result := pProdNome
  else if aValue = 'prodmarca' then
    Result := pProdMarca
  else if aValue = 'prodgrupo' then
    Result := pProdGrupo
  else if aValue = 'prodsubgrupo' then
    Result := pProdSubgrupo;
end;

function Encode(aValue: string): string;
begin
  Result := TBase64Encoding.Base64.Encode(aValue);
end;

function Decode(aValue: string): string;
begin
  Result := TBase64Encoding.Base64.Decode(aValue);
end;

function MontaPrms(aValue: string; aFilter: string=''): string;
begin
  if aFilter <> '' then
    Result := aFilter+', '+aValue
  else
    Result := aValue;
end;

end.
