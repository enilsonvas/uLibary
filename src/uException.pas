unit uException;

interface

{$IFDEF MSWINDOWS}

uses
  System.SysUtils,
  System.Classes,
  Vcl.SvcMgr,
  Vcl.Forms;

type
  TException = class
  private
    FLogFile: String;
  public
    constructor Create;
    procedure GravarLog(value: String);
    procedure TrataException(Sender: TObject; E: Exception);
  end;
{$ENDIF}

implementation

{$IFDEF MSWINDOWS}

{ TException }

constructor TException.Create;
begin
  FLogFile := ChangeFileExt(ParamStr(0), '.log');
  Application.onException := TrataException;
end;

procedure TException.GravarLog(value: String);
var
  txtLog: TextFile;
begin
  AssignFile(txtLog, FLogFile);
  if FileExists(FLogFile) then
    Append(txtLog)
  else
    Rewrite(txtLog);
  Writeln(txtLog, FormatDateTime('dd-mm-yyyy hh:mm:ss', now) + value);
  CloseFile(txtLog);
end;

procedure TException.TrataException(Sender: TObject; E: Exception);
begin
  GravarLog('==================================');
  if TComponent(Sender) is TForm then
  begin
    GravarLog('Form: ' + TForm(Sender).Name);
    GravarLog('Caption: ' + TForm(Sender).Caption);
    GravarLog('Error: ' + E.ClassName);
    GravarLog('Error: ' + E.Message);
  end
  else
  begin
    GravarLog('Error class: ' + E.ClassName);
    GravarLog('Error: ' + E.Message);
  end;
  GravarLog('===================================');
end;

var
  MinhaException : TException;
initialization;
  MinhaException := TException.Create;
finalization;
  MinhaException.Free;

{$ENDIF}

end.
