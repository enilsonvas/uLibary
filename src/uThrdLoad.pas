unit uThrdLoad;

interface

uses
  System.Classes, uFrmLoad, FMX.Forms, FMX.Layouts;

type
  LoadTela = class(TThread)
  private
    FaTexto: string;
    procedure SetaTexto(const Value: string);
    procedure CarregaTela;
  public
    property aTexto: string read FaTexto write SetaTexto;
    procedure RemoveObj;
  protected
    procedure Execute; override;
  end;

implementation

uses
  uFrmBase, System.UITypes;

{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

    procedure LoadTela.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; 
    
    or 
    
    Synchronize( 
      procedure 
      begin
        Form1.Caption := 'Updated in thread via an anonymous method' 
      end
      )
    );
    
  where an anonymous method is passed.
  
  Similarly, the developer can call the Queue method with similar parameters as 
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.
    
}

{ LoadTela }

procedure LoadTela.CarregaTela;
begin
 if FormLoad = nil then
   Application.CreateForm(TFormLoad, FormLoad);

  FormLoad.Mensagem.Text := FaTexto;

  FormLoad.ClientHeight := FormBase.ClientHeight;
  FormLoad.ClientWidth  := FormBase.ClientWidth;

  FormBase.lytPrincipal.AddObject(FormLoad.lyt);
end;

procedure LoadTela.Execute;
begin
  NameThreadForDebugging('LoadingTela');
  { Place thread code here }

  CarregaTela;
end;

procedure LoadTela.RemoveObj;
begin
  FormLoad.DisposeOf;
end;

procedure LoadTela.SetaTexto(const Value: string);
begin
  FaTexto := Value;
end;


end.
