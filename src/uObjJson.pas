unit uObjJson;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  System.TypInfo,
  System.Rtti;

type
  TJsonObj =  class
  private

  public
    procedure JsonToObj(aJson: TJSONObject; var aObj: TObject); overload;
    procedure JsonToObj(aJson: TJSONArray; var aObj: TObjectList<TObject>); overload;
  end;

implementation

{ TJsonObj }

procedure TJsonObj.JsonToObj(aJson: TJSONArray; var aObj: TObjectList<TObject>);
var
  oPropList: TPropList;
  vJsonObj: TJSONObject;
  J,I,X,Y: Integer;
begin
  vJsonObj := TJSONObject.Create;

  for Y := 0 to aObj.Count-1 do
    begin
      for X := Low(oPropList) to High(oPropList) do
        begin
          if oPropList[X] <> nil then
            oPropList[X] := nil
        end;

      GetPropList(aObj[i].ClassInfo, tkProperties, @oPropList);

      vJsonObj := TJSONObject(aJson.Items[Y]);

      for I := Low(oPropList) to High(oPropList) do
        begin
          case oPropList[I]^.PropType^.Kind of
            tkUString, tkString, tkWChar, tkLString, tkWString, tkChar:
              SetPropValue(aObj.Items[i], oPropList[I]^.Name, vJsonObj.GetValue<string>(oPropList[I]^.Name));
            tkInteger:
              SetPropValue(aObj.Items[i], oPropList[I]^.Name, vJsonObj.GetValue<Integer>(oPropList[I]^.Name));
            tkFloat:
              begin

                SetPropValue(aObj.Items[i], oPropList[I]^.Name, vJsonObj.GetValue<Double>(oPropList[I]^.Name));
              end;

          end;

        end;

    end;
end;
procedure TJsonObj.JsonToObj(aJson: TJSONObject; var aObj: TObject);
begin

end;

end.
