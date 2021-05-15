unit uLibary;

interface

type
  TpVerbo = (aGet, aPost, aPut, aDelete, aPacht);

  TpRequest = (reqQuery,

               reqCondPagto,
               reqFormaPagto,

               reqPedidoId,
               reqPedido,
               reqPedidoItem,
               reqPesqpedidos,

               reqPesqCliente,
               reqPesqProduto);


  function StrTpRequest(aRequest: TpRequest): string;

implementation

function StrTpRequest(aRequest: TpRequest): string;
begin
  case aRequest of
    reqQuery: Result := '/query';

    reqCondPagto  : Result := '/prazopagto';
    reqFormaPagto : Result := '/formapagto';

    reqPedidoId   : Result := '/idpedido';

    reqPedido     : Result := '/pedido';
    reqPedidoItem : Result := '/pedidoitem';
    reqPesqpedidos: Result := '/pesqpedidos';

    reqPesqCliente: Result := '/pesqcliente';
    reqPesqProduto: Result := '/pesqproduto';
  end;
end;

end.
