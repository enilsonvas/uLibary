unit uLibary;

interface

uses
  System.NetEncoding;
type
  TpVerbo = (aGet, aPost, aPut, aDelete, aPacht);
  TpRequest = (reqQuery,
               reqPagtoForma,
               reqPagtoPrazo,
               reqCidades,
               reqProd,
               reqProdEmb,
               reqProdPreco,
               reqCli,
               reqClieEnder,
               reqPedidoId,
               reqPedido,
               reqPedidoItem,
               reqPesqpedidos,
               reqPesqCliente,
               reqPesqProduto);

  function StrTpRequest(aRequest: TpRequest): string;
  function Encode(aValue: string): string;
  function Decode(aValue: string): string;

implementation
function StrTpRequest(aRequest: TpRequest): string;
begin
  case aRequest of
    reqQuery: Result := '/query';
    reqPagtoPrazo  : Result := '/prazopagto';
    reqPagtoForma  : Result := '/formapagto';
    reqCidades     : Result := '/cidades';
    reqPedidoId   : Result := '/idpedido';
    reqPedido     : Result := '/pedido';
    reqPedidoItem : Result := '/pedidoitem';
    reqPesqpedidos: Result := '/pesqpedidos';
    reqPesqCliente: Result := '/pesqcliente';
    reqPesqProduto: Result := '/pesqproduto';
    reqProd       : Result := '/prod';
    reqProdEmb    : Result := '/prodemb';
    reqProdPreco  : Result := '/prodclasse';
    reqCli        : Result := '/cli';
    reqClieEnder  : Result := '/cliender';
  end;
end;
function Encode(aValue: string): string;
begin
  Result := TBase64Encoding.Base64.Encode(aValue);
end;
function Decode(aValue: string): string;
begin
  Result := TBase64Encoding.Base64.Decode(aValue);
end;
end.
