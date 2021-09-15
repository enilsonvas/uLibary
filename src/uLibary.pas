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

  TpVerbo = (aGet, aPost, aPut, aDelete, aPacht);


  tpPrmsEmpresa = (pEmpId);

  TpPrmsUser = (pUserEmp,
                pUserId,
                pUserNome,
                pUserSenha);

  TpPrmsProd = (pProdEmp,
                pProdId,
                pProdNome,
                pProdMarca,
                pProdGrupo,
                pProdSubgrupo);

  TpPrmsCliente = (pCliEmp,
                   pCliId,
                   pCliCnpjCpf,
                   pCliInsEst,
                   pCliNome,
                   pCliFantasia,
                   pCliEnd,
                   pCliBairro,
                   pCliCidade,
                   pCliUf,
                   pCliContato,
                   pCliVendedor);


  TpRequest = (reqEmpresa,
               reqConexao,
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

               reqUser
               );

  function StrTpRequest(aRequest: TpRequest): string;

  function PrmsProdTp(aValue: string): TpPrmsProd;
  function PrmsProdStr(aValue: TpPrmsProd): string;

  function PrmsCliTp(aValue: string): TpPrmsCliente;
  function PrmsCliStr(aValue: TpPrmsCliente): string;

  function PrmsUserTp(aValue: string): TpPrmsUser;
  function PrmsUserStr(aValue: TpPrmsUser): string;

  function PrmsEmpTp(aValue: string): tpPrmsEmpresa;
  function PrmsEmpStr(aValue: tpPrmsEmpresa): string;

  function MontaPrms(aValue: string; aFilter: string=''): string;

  function Encode(aValue: string): string;
  function Decode(aValue: string): string;
  function CriptografiaMD5(Texto: string): string;
  function IsNumb(aText: string): Boolean;
  function CnpjCpfMask(aValue: string): string;



implementation

function CnpjCpfMask(aValue: string): string;
begin
  if Length(aValue) = 14 then
    Result := Copy(aValue, 1, 2)+'.'+Copy(aValue, 3, 3)+'.'+Copy(aValue, 6, 3)+'/'+Copy(aValue, 9, 4)+'-'+Copy(aValue, 12, 2)
  else if Length(aValue) = 11 then
    Result := Copy(aValue, 1, 3)+'.'+Copy(aValue, 4, 3)+'.'+Copy(aValue, 7, 3)+'-'+Copy(aValue, 10, 2)+'-'+Copy(aValue, 12, 2);
end;

function PrmsEmpTp(aValue: string): tpPrmsEmpresa;
begin
  if aValue = 'empid' then
    Result := pEmpId;
end;

function PrmsEmpStr(aValue: tpPrmsEmpresa): string;
begin
  case aValue of
    pEmpId: Result := 'empid';
  end;
end;

function PrmsUserTp(aValue: string): TpPrmsUser;
begin
  if aValue = 'userid' then
    Result := pUserEmp
  else if aValue = 'userid' then
    Result := pUserId
  else if aValue = 'usernome' then
    Result := pUserNome
  else if aValue = 'usersenha' then
    Result := pUserSenha;
end;

function PrmsUserStr(aValue: TpPrmsUser): string;
begin
  case aValue of
    pUserEmp  : Result := 'useremp';
    pUserId   : Result := 'userid';
    pUserNome : Result := 'usernome';
    pUserSenha: Result := 'usersenha';
  end;
end;

function PrmsCliTp(aValue: string): TpPrmsCliente;
begin
  if aValue = 'cliemp' then
    Result := pCliEmp
  else if aValue = 'cliid' then
    Result := pCliId
  else if aValue = 'clicnpjcpf' then
    Result := pCliCnpjCpf
  else if aValue = 'cliinscest' then
    Result := pCliInsEst
  else if aValue = 'clinome' then
    Result := pCliNome
  else if aValue = 'clifantasia' then
    Result := pCliFantasia
  else if aValue = 'cliendereco' then
    Result := pCliEnd
  else if aValue = 'clibairro' then
    Result := pCliBairro
  else if aValue = 'clicidade' then
    Result := pCliCidade
  else if aValue = 'cliuf' then
    Result := pCliUf
  else if aValue = 'clicontato' then
    Result := pCliContato
  else if aValue = 'clivend' then
    Result := pCliVendedor;
end;

function PrmsCliStr(aValue: TpPrmsCliente): string;
begin
  case aValue of
    pCliEmp     : Result := 'cliemp';
    pCliId      : Result := 'cliid';
    pCliCnpjCpf : Result := 'clicnpjcpf';
    pCliInsEst  : Result := 'cliinscest';
    pCliNome    : Result := 'clinome';
    pCliFantasia: Result := 'clifantasia';
    pCliEnd     : Result := 'cliendereco';
    pCliBairro  : Result := 'clibairro';
    pCliCidade  : Result := 'clicidade';
    pCliUf      : Result := 'cliuf';
    pCliContato : Result := 'clicontato';
    pCliVendedor: Result := 'clivend';
  end;
end;

function PrmsProdStr(aValue: TpPrmsProd): string;
begin
  case aValue of
    pProdEmp     : Result := 'prodemp';
    pProdId      : Result := 'prodid';
    pProdNome    : Result := 'prodnome';
    pProdMarca   : Result := 'prodmarca';
    pProdGrupo   : Result := 'prodgrupo';
    pProdSubgrupo: Result := 'prodsubgrupo';
  end;
end;

function PrmsProdTp(aValue: string): TpPrmsProd;
begin
  if aValue = 'prodemp' then
    Result := pProdEmp
  else if aValue = 'prodid' then
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
    reqEmpresa: Result := '/empresa';
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

function MontaPrms(aValue: string; aFilter: string=''): string;
begin
  if aFilter <> '' then
    Result := aFilter+', '+aValue
  else
    Result := aValue;
end;

end.
