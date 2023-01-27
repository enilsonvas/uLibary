unit uTipos;

interface

type
  TpIconMsg = (mtWarning, mtError, mtInformation, mtConfirmation);
  TpBtnIcon = (btiNao, btiCancelar, btiSim, btiOk);
  TpBtnMsg  = (btrNao=0, btrCancelar=1, btrSim=2, btrOk=3);

  tpDoc  = (RC, CX, PA, RE);

  tpFile = (fPDF, fXLSX, fDOC);

  TpRt = (rtPagGeral,
          rtPagAgrupado,
          rtPagVencindo,
          rtPagCustoVencindo,

          rtCxGeral,
          rtCxFechamento,
          rtCxFluxoAna,
          rtCxFluxoSint,

          rtRecGeral,
          rtRecAgrupCli,
          rtRecAgrupDia);


  tVerbo = (aGet, aPost, aPut, aDel, aPatch);


  tUrl = (urlDataHora,
          urlData,
          urlHora,

          urlConsCdCnpj,

          urlUser,
          urlUserEmp,
          urlUserLogin,
          urlUserStructure,
          urlUserEmpLogin,

          urlQuery,
          urlCidade,

          urlParticipante,
          urlParticipanteCC,
          urlPartCCusto,
          urlParticipantePesq,

          urlBanco,
          urlContaGrupo,
          urlConta,
          urlFormaPagto,
          urlEmpresa,
          urlEmpresaLogin,
          urlCCusto,
          urlRegra,

          urlEntCust,
          urlEntCustItem,
          urlEntCustCCusto,

          urlCaixa,
          urlCaixaDoc,
          urlCaixaCusto,
          urlCaixaSaldo,
          urlCaixaTransf,
          urlCxRtFechamento,

          urlPagamento,
          urlPagVolta,
          urlPagCusto,
          urlPagDoc,
          urlPagContas,

          urlPagRtGeral,
          urlPagRtAgrupado,
          urlPagRtVencimento,
          urlPagRtCCustoVencimento,

          urlRecebimento,
          urlRecVolta,
          urlRecDoc,
          urlRecCCusto,
          urlRecContas,

          urlRecRtGeral,
          urlRecRtAgrupCli,
          urlRecRtAgrupDia,

          urlFechamento,
          urlFechaDiario,
          urlFechaConciliacao,

          urlDre,
          urlDreItem,
          urlDreTot,
          urlDreGerencial,
          urlDreDoc,

          urlFlxSintetico,
          urlFlxAnalitico);

  TpFat = (tpfMult, tpfDiv);
  TpPrazo = (tSemanal, tMensal, tBimestral, tTrimestral, tAnual, tIntervalo);
  TpDtCompetencia = (tVencimento, tLancamento);

  tPrmCid = (IDMUNICIPIO=0, DESCRICAOMUNICIPIO=1, CODIGOUF=2, CODIGOIBGE=3);

  tPrmUser = (CDUSER_ID=0, CDUSER_NOME=1, CDUSER_SENHA=2, CDUSER_ATV=3);

  tPrmParticipante = (PART_ID=0, PART_CNPJ=1, PART_INSC=2, PART_RAZAO=3, PART_FANTASIA=4, PART_END=5, PART_BAIRRO=6, PART_ID_CID=7, PART_UF=8, PART_CEP=9, PART_FONE=10, PART_EMAIL=11, PART_TIPO=12, PART_DTCAD=13, PART_ATV=14);
  tPrmPartCCusto   = (PARTCCUSTO_ID=0, PARTCCUSTO_IDCUSTO=1);

  tPrmBanco   = (BANCO_ID=0, BANCO_NOME=1, BANCO_NBANCO=2, BANCO_CC=3, BANCO_CCDV=4, BANCO_AG=5, BANCO_AGDV=6, BANCO_ATV=7, BANCO_EMP=8);

  tPrmContaGr = (CONTGR_ID=0, CONTGR_NOME=1, CONTGR_ATV=2);
  tPrmConta   = (CONTAS_IDGR=0, CONTAS_ID=1, CONTAS_NOME=2, CONTAS_ATV=3);

  tPrmFormaPagto = (FORMPAGTO_ID=0, FORMPAGTO_NOME=1, FORMPAGTO_ATV=2);

  tPrmEmpresa = (EMP_ID=0, EMP_NOME=1, EMP_ATV=2);

  tPrmCCusto = (CDCCUSTO_ID=0, CDCCUSTO_DESC=1, CDCCUSTO_ATV=2);

  tPrmPagamento = (PAG_CONTROLE=0, PAG_ID=1, PAG_PARCIAL_ID=2);
  tPrmPagCCusto = (PAGCUSTO_CONT=0, PAGCUSTO_IDFAT=1, PAGCUSTO_IDCUSTO=2);

  tPrmRecebimento = (REC_CONTROLE=0, REC_ID=1, REC_PARCIAL_ID=2);
  tPrmRecCCusto   = (RECCUSTO_CONT=0, RECCUSTO_IDFAT=1,RECCUSTO_IDCUSTO=2);

  tPrmCaixa       = (CX_CONTROLE=0, CX_DOC=1, CX_DTLANC=2,CX_DTPAGO=3, CX_DTCOMPETENCIA=4, CX_CRED_DEB=5, CX_VALOR=6, CX_JUROS=7, CX_DESCONTO=8, CX_TOTAL=9, CX_BANCO_ID=10, CX_CONTA_ID=11, CX_CONTAGR_ID=12, CX_HISTORICO=13, CX_CONT_ORG=14, CX_EMPRESA=15, CX_PART_ID=16, CX_COMOPAGO_ID=17, CX_IDCUSTO=18, CX_TRANSF_CONT=19, CX_AUDITADO=20);
  tPrmCaixaCCusto = (CAIXACUSTO_CONT=0, CAIXACUSTO_IDCUSTO=1);

  tPrmCaixaFechamento = (CXFC_IDBANCO=0, CXFC_DTFECHAMENTO=1, CXFC_SLDINI=2, CXFC_VLRMOV=3, CXFC_SLDFIN=4, CXFC_USER=5, CXFC_DTMOVTO=6, DtfIni=7, DtfFim=8);


  tPrmDre     = (DREG_EMP=0, DREG_ANO=1, DREG_MES=2, DREG_IDTOT=3, DREG_GRUPO_ID=4, DREG_GRUPO_NOME=5, DREG_ATV=6);
  tPrmDreTot  = (DREGT_ID=0,DREGT_ANO=1, DREGT_MES=2, DREGT_DESCRICAO=3);
  tPrmDreItem = (DREGI_EMP=0, DREGI_ANO=1, DREGI_MES=2, DREGI_GRUPO_ID=3, DREGI_CONTA_ID=4, DREGI_CONTA_NOME=5, DREGI_CONTA_VLR=6, DREGI_CONTA_CD=7);

  tPrmEntCust     = (MEC_EMPRESA=0, MEC_CONTROLE=1, MEC_DTLANC=2, MEC_DTCOMP=3);
  tPrmEntCustItem = (MECI_EMPRESA=0, MECI_CONTROLE=1, MECI_ID=2, MECI_CONTAGR=3, MECI_CONTA=4, MECI_VALOR=5, MECI_TPMV=6);
  tPrmEntCCusto   = (MECC_CONTROLE=0, MECC_IDCUSTO=1, MECC_PERC=2, MECC_VALOR=3);

  tPrmFlxSintetico = (FLUXO_EMPRESA=0, FLUXO_DTMOV=1);
  tPrmFlxAnalitico = (FLXSINT_EMPRESA=0, FLXSINT_DTMOV=1);

  const
    tsPrmCid: array[0..3] of string =('IDMUNICIPIO', 'DESCRICAOMUNICIPIO', 'CODIGOUF', 'CODIGOIBGE');

    tsPrmParticipante: array[0..14] of string =('PART_ID', 'PART_CNPJ', 'PART_INSC', 'PART_RAZAO', 'PART_FANTASIA', 'PART_END', 'PART_BAIRRO', 'PART_ID_CID', 'PART_UF', 'PART_CEP', 'PART_FONE', 'PART_EMAIL', 'PART_TIPO', 'PART_DTCAD', 'PART_ATV');
    tsPrmPartCCusto  : array[0..1] of string =('PARTCCUSTO_ID', 'PARTCCUSTO_IDCUSTO');

    tsPrmBanco       : array[0..8] of string =('BANCO_ID', 'BANCO_NOME', 'BANCO_NBANCO', 'BANCO_CC', 'BANCO_CCDV', 'BANCO_AG', 'BANCO_AGDV', 'BANCO_ATV', 'BANCO_EMP');

    tsPrmContaGrupo  : array[0..2] of string =('CONTGR_ID', 'CONTGR_NOME', 'CONTGR_ATV');
    tsPrmConta       : array[0..3] of string =('CONTAS_IDGR', 'CONTAS_ID', 'CONTAS_NOME', 'CONTAS_ATV');

    tsPrmFormaPagto  : array[0..2] of string = ('FORMPAGTO_ID', 'FORMPAGTO_NOME', 'FORMPAGTO_ATV');
    tsPrmEmpresa     : array[0..2] of string = ('EMP_ID', 'EMP_NOME', 'EMP_ATV');
    tsPrmCCusto      : array[0..2] of string = ('CDCCUSTO_ID', 'CDCCUSTO_DESC', 'CDCCUSTO_ATV');


    tsPrmCaixa      : array[0..20] of string=('CX_CONTROLE', 'CX_DOC', 'CX_DTLANC', 'CX_DTPAGO', 'CX_DTCOMPETENCIA', 'CX_CRED_DEB', 'CX_VALOR', 'CX_JUROS', 'CX_DESCONTO', 'CX_TOTAL', 'CX_BANCO_ID', 'CX_CONTA_ID', 'CX_CONTAGR_ID', 'CX_HISTORICO', 'CX_CONT_ORG', 'CX_EMPRESA', 'CX_PART_ID', 'CX_COMOPAGO_ID', 'CX_IDCUSTO', 'CX_TRANSF_CONT', 'CX_AUDITADO');
    tsPrmCaixaCCusto: array[0..1] of string=('CAIXACUSTO_CONT', 'CAIXACUSTO_IDCUSTO');

    tsPrmCaixaFechamento : array[0..8] of string =('CXFC_IDBANCO', 'CXFC_DTFECHAMENTO', 'CXFC_SLDINI', 'CXFC_VLRMOV', 'CXFC_SLDFIN', 'CXFC_USER', 'CXFC_DTMOVTO', 'DtfIni', 'DtfFim');

    tsPrmPagamento   : array[0..2] of string =('PAG_CONTROLE', 'PAG_ID', 'PAG_PARCIAL_ID');
    tsPrmPagCCusto   : array[0..2] of string =('PAGCUSTO_CONT', 'PAGCUSTO_IDFAT', 'PAGCUSTO_IDCUSTO');

    tsPrmRecebimento : array[0..2] of string =('REC_CONTROLE', 'REC_ID', 'REC_PARCIAL_ID');
    tsPrmRecCCusto   : array[0..2] of string =('RECCUSTO_CONT', 'RECCUSTO_IDFAT','RECCUSTO_IDCUSTO');

    tsPrmUser : array[0..3] of string =('CDUSER_ID', 'CDUSER_NOME', 'CDUSER_SENHA', 'CDUSER_ATV');

    tsPrmDre    : array[0..6] of string=('DREG_EMP', 'DREG_ANO', 'DREG_MES', 'DREG_IDTOT', 'DREG_GRUPO_ID', 'DREG_GRUPO_NOME', 'DREG_ATV');
    tsPrmDreTot : array[0..3] of string=('DREGT_ID','DREGT_ANO', 'DREGT_MES', 'DREGT_DESCRICAO');
    tsPrmDreItem: array[0..7] of string=('DREGI_EMP', 'DREGI_ANO', 'DREGI_MES', 'DREGI_GRUPO_ID', 'DREGI_CONTA_ID', 'DREGI_CONTA_NOME', 'DREGI_CONTA_VLR', 'DREGI_CONTA_CD');

    tsPrmEntCust    : array[0..3] of string=('MEC_CONTROLE', 'MEC_DTLANC', 'MEC_DTCOMP', 'MEC_EMPRESA');
    tsPrmEntCustItem: array[0..6] of string=('MECI_EMPRESA', 'MECI_CONTROLE', 'MECI_ID', 'MECI_CONTAGR', 'MECI_CONTA', 'MECI_VALOR', 'MECI_TPMV');
    tsPrmEntCCusto  : array[0..3] of string=('MECC_CONTROLE', 'MECC_IDCUSTO', 'MECC_PERC', 'MECC_VALOR');

    tsPrmFlxSintetico: array[0..1] of string=('FLUXO_EMPRESA', 'FLUXO_DTMOV');
    tsPrmFlxAnalitico: array[0..1] of string=('FLXSINT_EMPRESA', 'FLXSINT_DTMOV');

implementation

end.
