unit BuscadorCep.Model.Conexao.SQLite;

interface

uses
  BuscadorCep.Model.Interfaces,
  System.SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite;

type
  TModelConexaoSQLite = class(TInterfacedObject, iModelConexao)
  private
    FConexao: TFDConnection;
    function GetDiretorioBD: string;
    procedure PrepararConexao;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelConexao;
    function Conectar: iModelConexao;
    function Desconectar: iModelConexao;
    function Conexao: TCustomConnection;

  end;

implementation

uses
  BuscadorCep.Model.Conexao.Enum.Driver;

const
  sDIRETORIOBD = 'db';
  sDATABASE = 'dbEndereco.db';

function TModelConexaoSQLite.Conectar: iModelConexao;
begin
  Result := Self;
  FConexao.Open;
end;

procedure TModelConexaoSQLite.PrepararConexao;
begin
  FConexao.Connected := False;
  FConexao.Params.Clear;
  FConexao.Params.Values['DataBase'] := GetDiretorioBD;
  FConexao.Params.Values['DriverID'] := SQLite.ID;
  FConexao.LoginPrompt := False;
end;

function TModelConexaoSQLite.Conexao: TCustomConnection;
begin
  Result := FConexao;
end;

constructor TModelConexaoSQLite.Create;
begin
  FConexao := TFDConnection.Create(nil);
  PrepararConexao;
end;

function TModelConexaoSQLite.Desconectar: iModelConexao;
begin
  Result := Self;
  FConexao.Close;
end;

destructor TModelConexaoSQLite.Destroy;
begin
  FreeAndNil(FConexao);
  inherited;
end;

function TModelConexaoSQLite.GetDiretorioBD: string;
begin
  Result := ExtractFilePath(ExtractFileDir(GetCurrentDir)) + sDIRETORIOBD + '\'
    + sDATABASE;
end;

class function TModelConexaoSQLite.New: iModelConexao;
begin
  Result := Self.Create;
end;

end.
