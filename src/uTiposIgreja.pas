unit uTiposIgreja;

interface

type
  tVerbo = (aGet, aPost, aPut, aDel, aPatch);

  tUrl = (urlMembro);

  function GetUrl(aUrl: tUrl): string;
implementation

function GetUrl(aUrl: tUrl): string;
begin
  case aUrl of
    urlMembro: Result := '/membro';
  end;
end;

end.
