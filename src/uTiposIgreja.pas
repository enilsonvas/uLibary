unit uTiposIgreja;

interface

type
  TpIconMsg = (mtWarning, mtError, mtInformation, mtConfirmation);
  TpBtnIcon = (btiNao, btiCancelar, btiSim, btiOk);
  TpBtnMsg  = (btrNao=0, btrCancelar=1, btrSim=2, btrOk=3);

  tVerbo = (aGet, aPost, aPut, aDel, aPatch);

  tUrl = (urlMembro,
          urlMembroQry,

          urlCelula);

  function GetUrl(aUrl: tUrl): string;

implementation

function GetUrl(aUrl: tUrl): string;
begin
  case aUrl of
    urlMembro   : Result := '/membro';
    urlMembroQry: Result := '/membroqry';

    urlCelula   : Result := '/celula';
  end;
end;

end.
