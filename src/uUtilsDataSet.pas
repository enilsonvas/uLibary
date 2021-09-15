unit uUtilsDataSet;

interface

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,

  Data.DB,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

  procedure ConfigConnFD(aFDConn: TFDConnection; aDS: TFDQuery; aDbDrive, aPath, aUser, aSenha: string);
  procedure ConfigFDPrms(aDs: TFDQuery; aTpParam: TParamType; aTpField: TFieldType; aNmParam, aVlrParams: string; aSize: Integer=0);

implementation

procedure ConfigConnFD(aFDConn: TFDConnection; aDS: TFDQuery; aDbDrive, aPath, aUser, aSenha: string);
begin
//Database=D:\Vega System\Dados\QUALY\DISTRIBUICAO.FDB
//User_Name=sysdba
//Password=masterkey
//DriverID=FB

  aFDConn.Params.Values['DriverID']  := aDbDrive;
  aFDConn.Params.Values['Database']  := aPath;
  aFDConn.Params.Values['User_Name'] := aUser;
  aFDConn.Params.Values['Password']  := aSenha;

  aDS.Connection := aFDConn;

end;

procedure ConfigFDPrms(aDs: TFDQuery; aTpParam: TParamType; aTpField: TFieldType; aNmParam, aVlrParams: string; aSize: Integer);
begin
  aDs.Params.BeginUpdate;
  aDs.Params.ParamByName(aNmParam).ParamType := aTpParam;
  aDs.Params.ParamByName(aNmParam).DataType  := aTpField;
  if aSize > 0 then  
    aDs.Params.ParamByName(aNmParam).Size      := aSize;

  case aTpField of
    ftString  : aDs.Params.ParamByName(aNmParam).AsString   := aVlrParams;
    ftInteger : aDs.Params.ParamByName(aNmParam).AsInteger  := aVlrParams.ToInteger;
    ftFloat   : aDs.Params.ParamByName(aNmParam).AsFloat    := aVlrParams.ToDouble;
    ftDate    : aDs.Params.ParamByName(aNmParam).AsDate     := StrToDate(aVlrParams);
    ftTime    : aDs.Params.ParamByName(aNmParam).AsTime     := StrToTime(aVlrParams);
    ftDateTime: aDs.Params.ParamByName(aNmParam).AsDateTime := StrToDateTime(aVlrParams);
  end;
  aDs.Params.EndUpdate;
end;

end.
