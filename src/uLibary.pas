unit uLibary;

interface

uses
  System.NetEncoding,

  Data.DB;

  type
  TParamValue = class
    nParam: string;
    vParam: string;
    tParam: TField;
  end;

  TpVerbo = (aGet, aPost, aPut, aDelete, aPacht);
  TpRequest = (reqConexao,
               reqQuery,
               reqPagtoForma,
               reqPagtoPrazo,
               reqCidades,

               //produtos
               {$region}
               reqProd,
               reqProdId,

               reqProdEmb,
               reqProdEmbId,

               reqProdPreco,
               reqProdPrecoId,
               {$endregion}

               reqCliGet,
               reqCli,
               reqClieEnder,
               reqCliVend,
               reqClieEnderVend,

               reqPedidoId,
               reqMovPedidos,
               reqMovPedidosItens,
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
    reqProdID     : Result := '/prod/:id';

    reqProdEmb    : Result := '/prodemb';
    reqProdEmbID  : Result := '/prodemb/:id';

    reqProdPreco   : Result := '/prodclasse';
    reqProdPrecoId : Result := '/prodclasse/:id';

    reqCliGet        : Result := '/getcli';
    reqCli           : Result := '/cli';
    reqClieEnder     : Result := '/cliender';
    reqCliVend       : Result := '/clivend';
    reqClieEnderVend : Result := '/cliendervend';

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
