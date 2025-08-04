unit BuscadorCep.Controller.Interfaces;

interface

uses
  BuscadorCep.Model.interfaces, Data.DB, uBuscaCEP;

type
  iControllerConexao = interface
    ['{3D48222E-C714-442B-98BF-9AE4F692AA71}']
    function Conectar: iControllerConexao;
    function Desconectar: iControllerConexao;
    function Conexao: TCustomConnection;
  end;

  iControllerEndereco = interface
    ['{7DB7C3DC-90DF-4180-993B-260B3B992DA5}']
    function SetEndereco(AEndereco: string): iControllerEndereco;
    function SetCidade(ACidade: string): iControllerEndereco;
    function SetEstado(AEstado: string): iControllerEndereco;
    function SetCEP(ACEP: String): iControllerEndereco;
    function SetBuscaCEP(ABuscaCEP: TBuscaCEP): iControllerEndereco;
    function DataSet: TDataSet;
    function ConsultarEnderecoNaBaseDados: Boolean;
    function ConsultarEnderecoNoWS: iControllerEndereco;
    function ConsultarCEPNaBaseDados: Boolean;
    function ConsultarCEPNoWS: iControllerEndereco;
    function ConsultarTodosRegistros: iControllerEndereco;
  end;

implementation

end.
