unit BuscadorCep.Controller.Endereco;

interface

uses
  BuscadorCep.Controller.Interfaces, BuscadorCep.Model.Interfaces,
  Data.DB, uBuscaCEP;

type
  TControllerEndereco = class(TInterfacedObject, iControllerEndereco)
  private
    FModelEndereco: iModelEndereco;
  public
    constructor Create(AControllerConexao: iControllerConexao);
    class function New(AControllerConexao: iControllerConexao): iControllerEndereco;
    function SetEndereco(AEndereco: string): iControllerEndereco;
    function SetCidade(ACidade: string): iControllerEndereco;
    function SetEstado(AEstado: string): iControllerEndereco;
    function SetCEP(ACEP: String): iControllerEndereco;
    function DataSet: TDataSet;
    function SetBuscaCEP(ABuscaCEP: TBuscaCep): iControllerEndereco;
    function ConsultarEnderecoNaBaseDados: Boolean;
    function ConsultarEnderecoNoWS: iControllerEndereco;
    function ConsultarCEPNaBaseDados: Boolean;
    function ConsultarCEPNoWS: iControllerEndereco;
    function ConsultarTodosRegistros: iControllerEndereco;
  end;

implementation

uses
  BuscadorCep.Model.Endereco;


function TControllerEndereco.ConsultarCEPNaBaseDados: Boolean;
begin
  Result := FModelEndereco.ConsultarCEPNaBaseDados;
end;

function TControllerEndereco.ConsultarCEPNoWS: iControllerEndereco;
begin
  Result := Self;
  FModelEndereco.ConsultarCEPNoWS;
end;

function TControllerEndereco.ConsultarEnderecoNaBaseDados: Boolean;
begin
  Result := FModelEndereco.ConsultarEnderecoNaBaseDados;
end;

function TControllerEndereco.ConsultarEnderecoNoWS: iControllerEndereco;
begin
  Result := Self;
  FModelEndereco.ConsultarEnderecoNoWS;
end;

function TControllerEndereco.ConsultarTodosRegistros: iControllerEndereco;
begin
  Result := Self;
  FModelEndereco.ConsultarTodosRegistros;
end;

constructor TControllerEndereco.Create(AControllerConexao: iControllerConexao);
begin
  FModelEndereco := TModelEndereco.New(AControllerConexao.Conexao);
end;

class function TControllerEndereco.New(AControllerConexao: iControllerConexao): iControllerEndereco;
begin
  Result := Self.Create(AControllerConexao);
end;

function TControllerEndereco.DataSet: TDataSet;
begin
  Result := FModelEndereco.DataSet;
end;

function TControllerEndereco.SetBuscaCEP(
  ABuscaCEP: TBuscaCep): iControllerEndereco;
begin
  Result := Self;
  FModelEndereco.SetBuscaCEP(ABuscaCEP);
end;

function TControllerEndereco.SetCEP(ACEP: String): iControllerEndereco;
begin
  Result := Self;
  FModelEndereco.SetCEP(ACEP);
end;

function TControllerEndereco.SetCidade(ACidade: string): iControllerEndereco;
begin
  Result := Self;
  FModelEndereco.SetCidade(ACidade);
end;

function TControllerEndereco.SetEndereco(
  AEndereco: string): iControllerEndereco;
begin
  Result := Self;
  FModelEndereco.SetEndereco(AEndereco);
end;

function TControllerEndereco.SetEstado(AEstado: string): iControllerEndereco;
begin
  Result := Self;
  FModelEndereco.SetEstado(AEstado);
end;

end.
