unit BuscadorCep.Model.Conexao.Factory;

interface

uses
  BuscadorCep.Model.Interfaces, BuscadorCep.Model.Conexao.Enum.Driver;

type
  TModelConexaoFactory = class(TInterfacedObject, iModelConexaoFactory)
    private
    public
      class function New: iModelConexaoFactory;
      function CriarConexao(ADriver: TConexaoDriver): iModelConexao;
  end;

implementation

uses
  BuscadorCep.Model.Conexao.SQLite, System.SysUtils;

function TModelConexaoFactory.CriarConexao(ADriver: TConexaoDriver): iModelConexao;
begin
  case ADriver of
    FB:
      raise Exception.Create('Conex�o n�o implementada para Firebird');
    SQLite:
      Result := TModelConexaoSQLite.New;
    MySQL:
      raise Exception.Create('Conex�o n�o implementada para MySQL') ;
    SQLServer:
      raise Exception.Create('Conexao n�o implementada para SQLServer');
    Oracle:
      raise Exception.Create('Conexao n�o implementada para Oracle');
  end;
end;

class function TModelConexaoFactory.New: iModelConexaoFactory;
begin
  Result := Self.Create;
end;

end.
