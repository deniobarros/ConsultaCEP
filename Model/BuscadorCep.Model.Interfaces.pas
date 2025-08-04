unit BuscadorCep.Model.Interfaces;

interface

uses
  BuscadorCep.Model.Conexao.Enum.Driver, Data.DB, uBuscaCEP;

type
  iModelConexao = interface
    ['{28CEDB32-C143-4850-AB84-E70ADD63A6D3}']
    function Conectar: iModelConexao;
    function Desconectar: iModelConexao;
    function Conexao: TCustomConnection;
  end;

  iModelConexaoFactory = interface
    ['{5B9E37CB-AB46-4033-95E1-059E5CA21193}']
    function CriarConexao(ADriver: TConexaoDriver): iModelConexao;
  end;

  iModelEndereco = interface
    ['{B6B78219-42E7-4EB5-9DB6-2238C737E8B2}']
    function SetEndereco(AEndereco: string): iModelEndereco;
    function SetCidade(ACidade: string): iModelEndereco;
    function SetEstado(AEstado: string): iModelEndereco;
    function SetCEP(ACEP: String): iModelEndereco;
    function SetBuscaCEP(ABuscaCEP: TBuscaCEP): iModelEndereco;
    function DataSet: TDataSet;
    function ConsultarTodosRegistros: iModelEndereco;
    function ConsultarEnderecoNaBaseDados: Boolean;
    function ConsultarCEPNaBaseDados: Boolean;
    function ConsultarCEPNoWS: iModelEndereco;
    function ConsultarEnderecoNoWS: iModelEndereco;
  end;


implementation

end.
