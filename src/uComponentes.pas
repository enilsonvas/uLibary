unit uComponentes;

interface

uses
  System.Sysutils,

  Data.DB,

  FMX.Objects, FMX.Edit, FMX.DateTimeCtrls, FMX.ListBox, FMX.StdCtrls,
  FMX.Memo, uComboBox, System.Classes;

type
  a = (b);

  procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TEdit); overload;
  procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TDateEdit); overload;
  procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TComboBox); overload;
  procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TCheckBox); overload;
  procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TMemo); overload;
  procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TImage); overload;

  procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TEdit); overload;
  procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TDateEdit); overload;
  procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TComboBox); overload;
  procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TCheckBox); overload;
  procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TMemo); overload;
  procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TImage); overload;

implementation

//DATA SETS
procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TEdit);
begin
  aData.FieldByName(tgtCampo).AsVariant := srcComp.Text;
end;

procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TDateEdit);
begin
  aData.FieldByName(tgtCampo).AsVariant := srcComp.Text;
end;

procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TComboBox);
begin
  aData.FieldByName(tgtCampo).AsVariant := GetIdComboBox(srcComp)
end;

procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TCheckBox);
begin
  if srcComp.IsChecked then
    aData.FieldByName(tgtCampo).AsVariant := 'S'
  else
    aData.FieldByName(tgtCampo).AsVariant := 'N';
end;

procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TMemo);
begin
  aData.FieldByName(tgtCampo).AsVariant := srcComp.Text;
end;

procedure CompToDataSet(aData: TDataSet; tgtCampo: string; srcComp: TImage);
var
  imgMemory: TMemoryStream;
begin
  try
    imgMemory := TMemoryStream.Create;

    srcComp.MultiResBitmap.SaveToStream(imgMemory);

    (aData.FieldByName(tgtCampo) as TBlobField).LoadFromStream(imgMemory);
  finally
    FreeAndNil(imgMemory);
  end;
end;

//componentes
procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TEdit);
begin
  tgtComp.Text := aData.FieldByName(srcCampo).AsString;
end;

procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TDateEdit);
begin
  tgtComp.DateTime := aData.FieldByName(srcCampo).AsDateTime;
end;

procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TComboBox);
begin
  SetIdComboBox(tgtComp, aData.FieldByName(srcCampo).AsString);
end;

procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TCheckBox);
begin
  tgtComp.IsChecked := (aData.FieldByName(srcCampo).AsString = 'S');
end;

procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TMemo);
begin
  tgtComp.Text := aData.FieldByName(srcCampo).AsString;
end;

procedure DataSetToComp (aData: TDataSet; srcCampo: string; tgtComp: TImage);
var
  imgMemory: TMemoryStream;
begin
  try
    imgMemory := TMemoryStream.Create;

    (aData.FieldByName(srcCampo) as TBlobField).SaveToStream(imgMemory);

    imgMemory.Position := 0;
    tgtComp.MultiResBitmap.LoadFromStream(imgMemory);
  finally
    FreeAndNil(imgMemory);
  end;
end;

end.
