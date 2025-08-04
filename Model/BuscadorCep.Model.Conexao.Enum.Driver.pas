unit BuscadorCep.Model.Conexao.Enum.Driver;

interface

Type
  TConexaoDriver = (FB, SQLite, MySQL, SQLServer, Oracle);

  TConexaoDriverHelper = record helper for TConexaoDriver
    function ID: string;
  end;


implementation

uses
  System.SysUtils;

function TConexaoDriverHelper.ID: string;
begin
  case Self of
    FB: Result := 'FB';
    SQLite: Result := 'SQLite';
    MySQL: Result := 'MySQL';
    SQLServer: Result := 'MSSQL';
    Oracle: Result := 'Oracle';
    else
      Result := emptystr;
  end;
end;

end.
