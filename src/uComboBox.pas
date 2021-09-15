unit uComboBox;

interface

uses
  System.SysUtils,

  FMX.ListBox,

  Data.DB;

type
  a = (b);

  procedure LoadComboBox(aCombo: TComboBox; aID, aText: string);

  procedure LoadComboBoxDataSet(aCombo: TComboBox; aData: TDataSet;
    aFieldID, aFieldText: string);

  procedure SetIdComboBox(aCombo: TComboBox; aID: string);

  function GetIdComboBox(aCombo: TComboBox): string;

implementation

// PROCEDURES
procedure LoadComboBox(aCombo: TComboBox; aID, aText: string);
var
  aItem: TListBoxItem;
begin
  aItem := TListBoxItem.Create(aCombo);

  aItem.Parent          := aCombo;
  aItem.Name            := aCombo.Name + IntToStr((aCombo.Items.Count + 1));
  aItem.ItemData.Text   := aText;
  aItem.ItemData.Detail := aID;

  aCombo.Controls.Add(aItem)
end;

procedure LoadComboBoxDataSet(aCombo: TComboBox; aData: TDataSet;
  aFieldID, aFieldText: string);
var
  aItem: TListBoxItem;
begin

  try
    aCombo.Items.Clear;

//    aItem := TListBoxItem.Create(aCombo);
//
//    aItem.Parent := aCombo;
//    aItem.Name   := aCombo.Name + IntToStr((aCombo.Items.Count + 1));
//
//    aItem.ItemData.Text   := '';
//    aItem.ItemData.Detail := '';
//
//    aCombo.Controls.Add(aItem);

    aData.DisableControls;

    aData.First;
    while not aData.Eof do
      begin
        aItem := TListBoxItem.Create(aCombo);

        aItem.Parent := aCombo;
        aItem.Name   := aCombo.Name + IntToStr((aCombo.Items.Count + 1));

        aItem.ItemData.Text   := aData.FieldByName(aFieldText).AsString;
        aItem.ItemData.Detail := aData.FieldByName(aFieldID).AsString;

        aCombo.Controls.Add(aItem);

        aData.Next;
      end;

    aCombo.ItemIndex := -1;
  finally
    aData.EnableControls;
  end;
end;

procedure SetIdComboBox(aCombo: TComboBox; aID: string);
var
  I, Indice: Integer;

begin
  Indice := -1;
  for I := 0 to aCombo.Items.Count - 1 do
  begin
    if aCombo.ListItems[I].ItemData.Detail = aID then
    begin
      Indice := I;
      Continue;
    end;
  end;

  aCombo.ItemIndex := Indice;
end;

// FUNCOES
function GetIdComboBox(aCombo: TComboBox): string;
begin
  Result := aCombo.ListItems[aCombo.ItemIndex].ItemData.Detail;
end;

end.
