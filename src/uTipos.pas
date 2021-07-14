unit uTipos;

interface

type
  TpAcaoAbas = (acPrincial, acItem);

  TpAcaoDados = (adInsert, adEdit, adDelete);

  TpIconMsg = (mtWarning, mtError, mtInformation, mtConfirmation);
  TpBtnMsg = (btrSim=0, btrNao=1, btrCancelar=2, btrOk=3);

  TpBtnsMsg = set of TpBtnMsg;

  TBtnResult = class
  private
    FaBtnResult: TpBtnMsg;
    procedure SetaBtnResult(const Value: TpBtnMsg);
  published
    property aBtnResult: TpBtnMsg read FaBtnResult write SetaBtnResult;
  end;


implementation

{ TBtnResult }

procedure TBtnResult.SetaBtnResult(const Value: TpBtnMsg);
begin
  FaBtnResult := Value;
end;

end.
