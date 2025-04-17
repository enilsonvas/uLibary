unit uUrlMetodos;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.DateUtils,
  System.Variants,
  System.TypInfo,
  System.Rtti,
  System.NetEncoding,
  System.Generics.Collections,

  Data.DB,

  uTipos;

type
  TQryList = TDictionary<string, string>;

  //Funcões
  function RespostaMetodo(aStatusCode: Integer): string;

  procedure PreparaFiltro(aObj: TObject; aQuery: TQryList);

  function GetUrl(aUrl: tUrl): string;

  function Enconde(aValue: string): string;
  function Desenconde(aValue: string): string;


  function StrtoTp(aValue: string; const AString: array of string; const AEnumerados: array of variant): OleVariant;
  function TptoStr(aValue: variant; const AString: array of string; const AEnumerados: array of variant): OleVariant;

  function FileTpStrToPrm(aValue: string): tpFile;
  function FileTpPrmToStr(aValue: Variant): string;

  function PartStrToPrm(aValue: string): tPrmParticipante;
  function PartPrmToStr(aValue: Variant): string;

  function PartCCustoStrToPrm(aValue: string): tPrmPartCCusto;
  function PartCCustoPrmToStr(aValue: Variant): string;

  function BancoStrToPrm(aValue: string): tPrmBanco;
  function BancoPrmToStr(aValue: Variant): string;

  function ContaGrupoStrToPrm(aValue: string): tPrmContaGr;
  function ContaGrupoPrmToStr(aValue: Variant): string;

  function ContaStrToPrm(aValue: string): tPrmConta;
  function ContaPrmToStr(aValue: Variant): string;

  function CaixaStrToPrm(aValue: string): tPrmCaixa;
  function CaixaPrmToStr(aValue: Variant): string;

  function CaixaCCustoStrToPrm(aValue: string): tPrmCaixaCCusto;
  function CaixaCCustoPrmToStr(aValue: Variant): string;

  function FechaCaixaStrToPrm(aValue: string): tPrmCaixaFechamento;
  function FechaCaixaPrmToStr(aValue: Variant): string;

  function PagamentoStrToPrm(aValue: string): tPrmPagamento;
  function PagamentoPrmToStr(aValue: Variant): string;

  function PagCustoStrToPrm(aValue: string): tPrmPagCCusto;
  function PagCustoPrmToStr(aValue: Variant): string;

  function RecebimentoStrToPrm(aValue: string): tPrmRecebimento;
  function RecebimentoPrmToStr(aValue: Variant): string;

  function RecCustoStrToPrm(aValue: string): tPrmRecCCusto;
  function RecCustoPrmToStr(aValue: Variant): string;

  function UserStrToPrm(aValue: string): tPrmUser;
  function UserToStr(aValue: Variant): string;

  function CidStrToPrm(aValue: string): tPrmCid;
  function CidToStr(aValue: Variant): string;

  function FmPgtoStrToPrm(aValue: string): tPrmFormaPagto;
  function FmPgtoToStr(aValue: Variant): string;

  function EmpresaStrToPrm(aValue: string): tPrmEmpresa;
  function EmpresaToStr(aValue: Variant): string;

  function DreStrToPrm(aValue: string): tPrmDre;
  function DrePrmToStr(aValue: Variant): string;

  function DreTotStrToPrm(aValue: string): tPrmDreTot;
  function DreTotPrmToStr(aValue: Variant): string;

  function DreItemStrToPrm(aValue: string): tPrmDreItem;
  function DreITemPrmToStr(aValue: Variant): string;

  function EntCustStrToPrm(aValue: string): tPrmEntCust;
  function EntCustPrmToStr(aValue: Variant): string;

  function EntCustItemStrToPrm(aValue: string): tPrmEntCustItem;
  function EntCustItemPrmToStr(aValue: Variant): string;

  function EntCustCCustoStrToPrm(aValue: string): tPrmEntCCusto;
  function EntCustCCustoPrmToStr(aValue: Variant): string;

  function FlxSinteticoStrToPrm(aValue: string): tPrmFlxSintetico;
  function FlxSinteticoPrmToStr(aValue: Variant): string;

  function FlxAnaliticoStrToPrm(aValue: string): tPrmFlxAnalitico;
  function FlxAnaliticoPrmToStr(aValue: Variant): string;

  function CCustoStrToPrm(aValue: string): tPrmCCusto;
  function CCustoPrmToStr(aValue: Variant): string;

  procedure Erro(aErro: string);

implementation


procedure Erro(aErro: string);
var
  sMsg: TStringList;
begin
  sMsg := TStringList.Create;
  sMsg.Add(aErro);
  sMsg.SaveToFile(ExtractFilePath(ParamStr(0))+'Erro_'+now.Format('dd_mm_yyyy_hh_nn_ss')+'.txt');
  sMsg.DisposeOf;
end;

procedure PreparaFiltro(aObj: TObject; aQuery: TQryList);
var
  oPropList: TPropList;
  I: Integer;
begin
  for I := Low(oPropList) to High(oPropList) do
    begin
      if oPropList[I] <> nil then
        oPropList[I] := nil
      end;

  GetPropList(aObj.ClassInfo, tkProperties, @oPropList);

  for I := Low(oPropList) to High(oPropList) do
    begin
      if not Assigned(oPropList[I]) then
        Break;

      if aQuery.ContainsKey(oPropList[I]^.Name) then
        begin
          case oPropList[I]^.PropType^.Kind of
            tkUString, tkString, tkWChar, tkLString, tkWString, tkChar:
              SetPropValue(aObj, oPropList[I]^.Name,  Desenconde(aQuery.Items[oPropList[I]^.Name]));
            tkFloat:
              SetPropValue(aObj, oPropList[I]^.Name,  StrToFloatDef(Desenconde(aQuery.Items[oPropList[I]^.Name]), 0));
            tkInteger:
              SetPropValue(aObj, oPropList[I]^.Name,  StrToIntDef(Desenconde(aQuery.Items[oPropList[I]^.Name]), 0));
          end;
        end;
    end;
end;

function GetUrl(aUrl: tUrl): string;
begin
  case aUrl of
    urlParticipante     : Result := '/participante';
    urlParticipanteCC   : Result := '/participanteccusto';
    urlPartCCusto       : Result := '/partccusto';
    urlParticipantePesq : Result := '/participantePesq';

    urlBanco         : Result := '/banco';
    urlBancoQry      : Result := '/bancoqry';

    urlContaList     : Result := '/contalist';
    urlConta         : Result := '/conta';

    urlContaGrupoList: Result := '/contagrupolist';
    urlContaGrupo    : Result := '/contagrupo';

    urlFormaPagto    : Result := '/formapagto';
    urlFormaPagtoList: Result := '/formapagtolist';

    urlPrazoPagto    : Result := '/prazopagto';
    urlPrazoPagtoList: Result := '/prazopagtolist';

    urlOperacaoVendas    : Result := '/operacaovendas';
    urlOperacaoVendasList: Result := '/operacaovendaslist';

    urlEmp     : Result := '/emp';
    urlEmpQry  : Result := '/empqry';
    urlEmpCombo: Result := '/empcombo';

    urlEmpDados     : Result := '/empdados';
    urlEmpDadosCombo: Result := '/empdadoscombo';
    urlEmpDadosList : Result := '/empdadoslist';
    urlEmpDadosLogin: Result := '/empdadoslogin';

    urlCCusto        : Result := '/ccusto';
    urlCCustoList    : Result := '/ccustolist';

    urlRegra         : Result := '/regra';

    urlUser          : Result := '/user';
    urlUserEmp       : Result := '/useremp';
    urlUserLogin     : Result := '/userlogin';
    urlUserEmpLogin  : Result := '/useremplogin';
    urlUserQry       : Result := '/userqry';
    urlUserStructure : Result := '/userstructure';
    urlUserPermissoes: Result := '/userpermissoes';

    urlEntCust      : Result := '/entcust';
    urlEntCustItem  : Result := '/entcustitem';
    urlEntCustCCusto: Result := '/entcustccusto';

    urlCaixa             : Result := '/caixa';
    urlCaixaQry          : Result := '/caixaqry';
    urlCaixaDoc          : Result := '/caixadoc';
    urlCaixaCusto        : Result := '/caixacusto';
    urlCaixaContas       : Result := '/contas';
    urlCaixaSaldo        : Result := '/caixasaldo';
    urlCaixaTransf       : Result := '/caixatransf';
    urlCaixaFechamento   : Result := '/caixafechamento';
    urlCaixaFechamentoMv : Result := '/caixafechamentomv';

    urlCxRtFechamento: Result := '/cxrtfechamento';

    urlPagamentoOrd         : Result := '/pagord';
    urlPagamentoQry         : Result := '/pagqry';
    urlPagamento            : Result := '/pag';
    urlPagVolta             : Result := '/pagvolta';
    urlPagCusto             : Result := '/pagcusto';
    urlPagDoc               : Result := '/pagdoc';
    urlPagBxGlobal          : Result := '/pagbxglobal';
    urlPagContas            : Result := '/pagcontas';

    urlPagRtGeral           : Result := '/pagrtgeral';
    urlPagRtAgrupado        : Result := '/pagrtagrupado';
    urlPagRtVencimento      : Result := '/pagrtvencimento';
    urlPagRtCCustoVencimento: Result := '/pagrtccustovencimento';

    urlRecebimentoQry   : Result := '/recqry';
    urlRecebimento      : Result := '/rec';
    urlRecVolta         : Result := '/recvolta';
    urlRecDoc           : Result := '/recdoc';
    urlRecCCusto        : Result := '/reccusto';
    urlRecContas        : Result := '/reccontas';

    urlRecData      : Result := '/recdata';
    urlRecDataItem  : Result := '/recdataitem';

    urlRecRtGeral   : Result := '/recrtgeral';
    urlRecRtAgrupCli: Result := '/recrtagrupcli';
    urlRecRtAgrupDia: Result := '/recrtagrupdia';

    urlRecQry          : Result := '/recqry';
    urlRecQryAgrupVenc : Result := '/recqryagrupvenc';
    urlRecQryAgrupPart : Result := '/recqryagruppart';

    urlFechamento      : Result := '/fechamento';
    urlFechaDiario     : Result := '/fechadiario';
    urlFechaDiarioConta: Result := '/fechadiarioconta';
    urlFechaDiarioMov  : Result := '/fechadiariomov';
    urlFechaConciliacao: Result := '/fechaconciliacao';

    urlQuery       : Result := '/query';
    urlCidade      : Result := '/cidade';

    urlDataHora    : Result := '/datahora';
    urlData        : Result := '/data';
    urlHora        : Result := '/hora';

    urlConsCdCnpj  : Result := '/conscadCnpjCpf';

    urlDre         : Result := '/dre';
    urlDreItem     : Result := '/dreitem';
    urlDreTot      : Result := '/dretot';
    urlDreMov      : Result := '/dremov';
    urlDreDoc      : Result := '/dredoc';


    urlFlxSintetico: Result := '/flxsintetico';
    urlFlxAnalitico: Result := '/flxanalitico';

    urlCliente      : Result := '/cliente';

    urlProduto        : Result := '/prod';
    urlProdutoField   : Result := '/prodfields';
    urlProdutoQry     : Result := '/prodqry';
    urlProdutoGrupo   : Result := '/prodgrupo';
    urlProdutoSubGrupo: Result := '/prodsubgrupo';
    urlProdutoMarca   : Result := '/prodmarca';
    urlProdutoSaldo   : Result := '/prodsaldo';

    urlProdutoEmb   : Result := '/prodemb';
    urlProdutoPreco : Result := '/prodpreco';
    urlProdutoImg   : Result := '/prodimg';

    urlPedido       : Result := '/pedido';
    urlPedidoItem   : Result := '/pedidoitem';
    urlPedidoQry    : Result := '/pedidoqry';

    urlOfx: Result := '/ofx';

    urlGrafGeralRecDesp   : Result := '/grafrecdesp';
    urlGrafGeralRecDespDia: Result := '/grafrecdespdia';
    urlGrafGeralRecDespMes: Result := '/grafrecdespmes';

    urlGrafGeralMovContas: Result := '/grafmovcontas';

    urlGrafGeralFlxProjetado : Result := '/grafflxprojdia';

    urlGraficoContasDia: Result := '/grafcontasdia';
    urlGraficoContasMes: Result := '/grafcontasmes';
    urlGraficoContasAno: Result := '/grafcontasano';

    urlBiDre    : Result := '/bidre';
    urlBiDreItem: Result := '/bidreitem';

    urlBiFluxo    : Result := '/bifluxo';
    urlBiFluxoItem: Result := '/bifluxotem';

    urlAcbrConsCnpj : Result := '/conscnpj';
    urlAcbrConsCpf  : Result := '/conscpf';
    urlAcbrConsInsc : Result := '/consinsc';
    urlAcbrConsCep  : Result := '/acbrconscep';

    urlRepositoryImagem : Result := '/repimg';
  end;
end;

function RespostaMetodo(aStatusCode: Integer): string;
begin
  case aStatusCode of
    100: Result := 'Continue';                                 {do not localize}
    101: Result := 'Switching Protocols';                      {do not localize}
    200: Result := 'OK';                                       {do not localize}
    201: Result := 'Created';                                  {do not localize}
    202: Result := 'Accepted';                                 {do not localize}
    203: Result := 'Non-Authoritative Information';            {do not localize}
    204: Result := 'No Content';                               {do not localize}
    205: Result := 'Reset Content';                            {do not localize}
    206: Result := 'Partial Content';                          {do not localize}
    300: Result := 'Multiple Choices';                         {do not localize}
    301: Result := 'Moved Permanently';                        {do not localize}
    302: Result := 'Moved Temporarily';                        {do not localize}
    303: Result := 'See Other';                                {do not localize}
    304: Result := 'Not Modified';                             {do not localize}
    305: Result := 'Use Proxy';                                {do not localize}
    400: Result := 'Bad Request';                              {do not localize}
    401: Result := 'Unauthorized';                             {do not localize}
    402: Result := 'Payment Required';                         {do not localize}
    403: Result := 'Forbidden';                                {do not localize}
    404: Result := 'Not Found';                                {do not localize}
    405: Result := 'Method Not Allowed';                       {do not localize}
    406: Result := 'None Acceptable';                          {do not localize}
    407: Result := 'Proxy Authentication Required';            {do not localize}
    408: Result := 'Request Timeout';                          {do not localize}
    409: Result := 'Conflict';                                 {do not localize}
    410: Result := 'Gone';                                     {do not localize}
    411: Result := 'Length Required';                          {do not localize}
    412: Result := 'Unless True';                              {do not localize}
    500: Result := 'Internal Server Error';                    {do not localize}
    501: Result := 'Not Implemented';                          {do not localize}
    502: Result := 'Bad Gateway';                              {do not localize}
    503: Result := 'Service Unavailable';                      {do not localize}
    504: Result := 'Gateway Timeout';                          {do not localize}
    else
      Result := '';
  end

end;

function Enconde(aValue: string): string;
begin
  Result := TBase64URLEncoding.Base64.Encode(aValue);

//  {$IFDEF RELELASE THEN}
//  Result := TBase64URLEncoding.Base64.Encode(aValue);
//  {$ELSE}
//  Result := aValue;
//  {$IFEND}
end;

function Desenconde(aValue: string): string;
begin
  Result := TBase64URLEncoding.Base64.Decode(aValue);

//  {$IFDEF RELELASE THEN}
//  Result := TBase64URLEncoding.Base64.Decode(aValue);
//  {$ELSE}
//  Result := aValue;
//  {$IFEND}
end;

function StrtoTp(aValue: string; const AString: array of string; const AEnumerados: array of variant): OleVariant;
var
  I: Integer;
begin
  Result := -1;

  for i := Low(AString) to High(AString) do
   begin
     if AnsiSameText(aValue, AString[i]) then
       begin
         result := AEnumerados[i];
         Continue;
       end
   end;
end;

function TptoStr(aValue: variant; const AString: array of string; const AEnumerados: array of variant): OleVariant;
var
  I: Integer;
begin
  for i := Low(AEnumerados) to High(AEnumerados) do
    begin
      if aValue = AEnumerados[i] then
        begin
          result := AString[i];
          Continue;
        end;
    end;
end;


function FileTpStrToPrm(aValue: string): tpFile;
begin
  Result := StrtoTp(aValue, ['fPDF', 'fXLSX', 'fDOC'], [fPDF, fXLSX, fDOC]);
end;

function FileTpPrmToStr(aValue: Variant): string;
begin
  Result := TpToStr(aValue, ['fPDF', 'fXLSX', 'fDOC'], [fPDF, fXLSX, fDOC]);
end;

//PARTICIPANTE
{$Region Participante}
function PartStrToPrm(aValue: string): tPrmParticipante;
begin
  Result := StrtoTp(aValue, tsPrmParticipante, [PART_ID, PART_CNPJ, PART_INSC, PART_RAZAO, PART_FANTASIA, PART_END, PART_BAIRRO, PART_ID_CID, PART_UF, PART_CEP, PART_FONE, PART_EMAIL, PART_TIPO, PART_DTCAD, PART_ATV]);
end;

function PartPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmParticipante, [PART_ID, PART_CNPJ, PART_INSC, PART_RAZAO, PART_FANTASIA, PART_END, PART_BAIRRO, PART_ID_CID, PART_UF, PART_CEP, PART_FONE, PART_EMAIL, PART_TIPO, PART_DTCAD, PART_ATV])
end;

function PartCCustoStrToPrm(aValue: string): tPrmPartCCusto;
begin
  Result := StrtoTp(aValue, tsPrmPartCCusto, [PARTCCUSTO_ID, PARTCCUSTO_IDCUSTO]);
end;

function PartCCustoPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmPartCCusto, [PARTCCUSTO_ID, PARTCCUSTO_IDCUSTO]);
end;
{$EndRegion Participante}

//BANCO
{$region}
function BancoStrToPrm(aValue: string): tPrmBanco;
begin
  Result := StrtoTp(aValue, tsPrmbanco, [BANCO_ID, BANCO_NOME, BANCO_NBANCO,BANCO_CC, BANCO_CCDV, BANCO_AG, BANCO_AGDV, BANCO_ATV, BANCO_EMP]);
end;

function BancoPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmbanco, [BANCO_ID, BANCO_NOME, BANCO_NBANCO,BANCO_CC, BANCO_CCDV, BANCO_AG, BANCO_AGDV, BANCO_ATV, BANCO_EMP]);
end;
{$endregion}

//CONTA GRUPO
{$region}
function ContaGrupoStrToPrm(aValue: string): tPrmContaGr;
begin
  Result := StrtoTp(aValue, tsPrmContaGrupo, [CONTGR_ID, CONTGR_NOME, CONTGR_ATV]);
end;

function ContaGrupoPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmContaGrupo, [CONTGR_ID, CONTGR_NOME, CONTGR_ATV]);
end;
{$endregion}

//CONTAS
{$region}
function ContaStrToPrm(aValue: string): tPrmConta;
begin
  Result := StrtoTp(aValue, tsPrmConta, [CONTAS_IDGR, CONTAS_ID, CONTAS_NOME, CONTAS_ATV]);
end;

function ContaPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmConta, [CONTAS_IDGR, CONTAS_ID, CONTAS_NOME, CONTAS_ATV]);
end;
{$endregion}

//CAIXA
{$region}
function CaixaStrToPrm(aValue: string): tPrmCaixa;
begin
  Result := StrtoTp(aValue, tsPrmCaixa, [CX_CONTROLE, CX_DOC, CX_DTLANC,CX_DTPAGO, CX_DTCOMPETENCIA, CX_CRED_DEB, CX_VALOR, CX_JUROS, CX_DESCONTO, CX_TOTAL, CX_BANCO_ID, CX_CONTA_ID, CX_CONTAGR_ID, CX_HISTORICO, CX_CONT_ORG, CX_EMPRESA, CX_PART_ID, CX_COMOPAGO_ID, CX_IDCUSTO, CX_TRANSF_CONT, CX_AUDITADO]);
end;

function CaixaPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmCaixa, [CX_CONTROLE, CX_DOC, CX_DTLANC,CX_DTPAGO, CX_DTCOMPETENCIA, CX_CRED_DEB, CX_VALOR, CX_JUROS, CX_DESCONTO, CX_TOTAL, CX_BANCO_ID, CX_CONTA_ID, CX_CONTAGR_ID, CX_HISTORICO, CX_CONT_ORG, CX_EMPRESA, CX_PART_ID, CX_COMOPAGO_ID, CX_IDCUSTO, CX_TRANSF_CONT, CX_AUDITADO]);
end;

function CaixaCCustoStrToPrm(aValue: string): tPrmCaixaCCusto;
begin
  Result := StrtoTp(aValue, tsPrmPartCCusto, [CAIXACUSTO_CONT, CAIXACUSTO_IDCUSTO]);
end;

function CaixaCCustoPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmPartCCusto, [CAIXACUSTO_CONT, CAIXACUSTO_IDCUSTO]);
end;
{$endregion}

//CAIXA FECHAMENTO
{$region}
function FechaCaixaStrToPrm(aValue: string): tPrmCaixaFechamento;
begin
  Result := StrtoTp(aValue, tsPrmCaixaFechamento, [CXFC_IDBANCO, CXFC_DTFECHAMENTO, CXFC_SLDINI, CXFC_VLRMOV, CXFC_SLDFIN, CXFC_USER, CXFC_DTMOVTO, DtfIni, DtfFim]);
end;

function FechaCaixaPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmCaixaFechamento, [CXFC_IDBANCO, CXFC_DTFECHAMENTO, CXFC_SLDINI, CXFC_VLRMOV, CXFC_SLDFIN, CXFC_USER, CXFC_DTMOVTO, DtfIni, DtfFim]);
end;

{$endregion}

//PAGAMENTO
{$region}
function PagamentoStrToPrm(aValue: string): tPrmPagamento;
begin
  Result := StrtoTp(aValue, tsPrmPagamento, [PAG_CONTROLE, PAG_ID, PAG_PARCIAL_ID]);
end;

function PagamentoPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmPagamento, [PAG_CONTROLE, PAG_ID, PAG_PARCIAL_ID]);
end;

function PagCustoStrToPrm(aValue: string): tPrmPagCCusto;
begin
  Result := StrtoTp(aValue, tsPrmPagCCusto, [PAGCUSTO_CONT, PAGCUSTO_IDFAT, PAGCUSTO_IDCUSTO]);
end;

function PagCustoPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmPagCCusto, [PAGCUSTO_CONT, PAGCUSTO_IDFAT, PAGCUSTO_IDCUSTO]);
end;
{$endregion}

//RECEBIMENTO
{$region}
function RecebimentoStrToPrm(aValue: string): tPrmRecebimento;
begin
  Result := StrtoTp(aValue, tsPrmRecebimento, [REC_CONTROLE, REC_ID, REC_PARCIAL_ID]);
end;

function RecebimentoPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmRecebimento, [REC_CONTROLE, REC_ID, REC_PARCIAL_ID]);
end;

function RecCustoStrToPrm(aValue: string): tPrmRecCCusto;
begin
  Result := StrtoTp(aValue, tsPrmRecCCusto, [RECCUSTO_CONT, RECCUSTO_IDFAT, RECCUSTO_IDCUSTO]);
end;

function RecCustoPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmRecCCusto, [RECCUSTO_CONT, RECCUSTO_IDFAT, RECCUSTO_IDCUSTO]);
end;
{$endregion}

//USUARIO
{$region}
function UserStrToPrm(aValue: string): tPrmUser;
begin
  Result := StrtoTp(aValue, tsPrmUser, [CDUSER_ID, CDUSER_NOME, CDUSER_SENHA, CDUSER_ATV]);
end;

function UserToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmUser, [CDUSER_ID, CDUSER_NOME, CDUSER_SENHA, CDUSER_ATV]);
end;
{$endregion}

//CIDADE
{$region}
function CidStrToPrm(aValue: string): tPrmCid;
begin
  Result := StrtoTp(aValue, tsPrmCid, [IDMUNICIPIO, DESCRICAOMUNICIPIO, CODIGOUF, CODIGOIBGE]);
end;

function CidToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmCid, [IDMUNICIPIO, DESCRICAOMUNICIPIO, CODIGOUF, CODIGOIBGE]);
end;

{$endregion}

//FORMA PAGTO
{$region}
function FmPgtoStrToPrm(aValue: string): tPrmFormaPagto;
begin
  Result := StrtoTp(aValue, tsPrmFormaPagto, [FORMPAGTO_ID, FORMPAGTO_NOME, FORMPAGTO_ATV]);
end;

function FmPgtoToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmFormaPagto, [FORMPAGTO_ID, FORMPAGTO_NOME, FORMPAGTO_ATV]);
end;
{$endregion}

//EMPRESA
{$region}
function EmpresaStrToPrm(aValue: string): tPrmEmpresa;
begin
  Result := StrtoTp(aValue, tsPrmEmpresa, [EMP_ID, EMP_NOME, EMP_ATV]);
end;

function EmpresaToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmEmpresa, [EMP_ID, EMP_NOME, EMP_ATV]);
end;
{$endregion}

//CCUSTO
{$region}
function CCustoStrToPrm(aValue: string): tPrmCCusto;
begin
  Result := StrtoTp(aValue, tsPrmCCusto, [CDCCUSTO_ID, CDCCUSTO_DESC, CDCCUSTO_ATV]);
end;

function CCustoPrmToStr(aValue: Variant): string;
begin
  Result := TpToStr(aValue, tsPrmCCusto, [CDCCUSTO_ID, CDCCUSTO_DESC, CDCCUSTO_ATV]);
end;
{$endregion}

//DRE TOT
{$region}
function DreTotStrToPrm(aValue: string): tPrmDreTot;
begin
  Result := StrtoTp(aValue, tsPrmDreTot, [DREGT_ID,DREGT_ANO, DREGT_MES, DREGT_DESCRICAO]);
end;

function DreTotPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmDreTot, [DREGT_ID,DREGT_ANO, DREGT_MES, DREGT_DESCRICAO]);
end;
{$endregion}

//DRE
{$region}
function DreStrToPrm(aValue: string): tPrmDre;
begin
  Result := StrtoTp(aValue, tsPrmDre, [DREG_EMP, DREG_ANO, DREG_MES, DREG_IDTOT, DREG_GRUPO_ID, DREG_GRUPO_NOME, DREG_ATV]);
end;

function DrePrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmDre, [DREG_EMP, DREG_ANO, DREG_MES, DREG_IDTOT, DREG_GRUPO_ID, DREG_GRUPO_NOME, DREG_ATV]);
end;
{$endregion}

//DRE ITEM
{$region}
function DreItemStrToPrm(aValue: string): tPrmDreItem;
begin
  Result := StrtoTp(aValue, tsPrmDreItem, [DREGI_EMP, DREGI_ANO, DREGI_MES, DREGI_GRUPO_ID, DREGI_CONTA_ID, DREGI_CONTA_NOME, DREGI_CONTA_VLR, DREGI_CONTA_CD])
end;

function DreITemPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmDreItem, [DREGI_EMP, DREGI_ANO, DREGI_MES, DREGI_GRUPO_ID, DREGI_CONTA_ID, DREGI_CONTA_NOME, DREGI_CONTA_VLR, DREGI_CONTA_CD])
end;
{$endregion}

//ENTCUST
{$region}
function EntCustStrToPrm(aValue: string): tPrmEntCust;
begin
  Result := StrtoTp(aValue, tsPrmEntCCusto, [MECC_CONTROLE, MECC_IDCUSTO, MECC_PERC, MECC_VALOR]);
end;

function EntCustPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmEntCCusto, [MECC_CONTROLE, MECC_IDCUSTO, MECC_PERC, MECC_VALOR]);
end;
{$endregion}

//ENTCUSTITEM
{$region}
function EntCustItemStrToPrm(aValue: string): tPrmEntCustItem;
begin
  Result := StrtoTp(aValue, tsPrmEntCustItem, [MECI_EMPRESA, MECI_CONTROLE, MECI_ID, MECI_CONTAGR, MECI_CONTA, MECI_VALOR, MECI_TPMV]);
end;

function EntCustItemPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmEntCustItem, [MECI_EMPRESA, MECI_CONTROLE, MECI_ID, MECI_CONTAGR, MECI_CONTA, MECI_VALOR, MECI_TPMV]);
end;
{$endregion}

//ENTCUSTCENTRO
{$region}
function EntCustCCustoStrToPrm(aValue: string): tPrmEntCCusto;
begin
  Result := StrtoTp(aValue, tsPrmEntCust, [MEC_EMPRESA, MEC_CONTROLE, MEC_DTLANC, MEC_DTCOMP]);
end;

function EntCustCCustoPrmToStr(aValue: Variant): string;
begin
  Result := TpToStr(aValue, tsPrmEntCust, [MEC_EMPRESA, MEC_CONTROLE, MEC_DTLANC, MEC_DTCOMP]);
end;
{$endregion}
//FLUXO SINTETICO
{$region}
function FlxSinteticoStrToPrm(aValue: string): tPrmFlxSintetico;
begin
  Result := StrtoTp(aValue, tsPrmFlxSintetico, [FLUXO_EMPRESA, FLUXO_DTMOV]);
end;

function FlxSinteticoPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmFlxSintetico, [FLUXO_EMPRESA, FLUXO_DTMOV]);
end;
{$endregion}

//FLUXO ANALITICO
{$region}
function FlxAnaliticoStrToPrm(aValue: string): tPrmFlxAnalitico;
begin
  Result := StrtoTp(aValue, tsPrmFlxAnalitico, [FLXSINT_EMPRESA, FLXSINT_DTMOV]);
end;

function FlxAnaliticoPrmToStr(aValue: Variant): string;
begin
  Result := TptoStr(aValue, tsPrmFlxAnalitico, [FLXSINT_EMPRESA, FLXSINT_DTMOV]);
end;
{$endregion}

end.
