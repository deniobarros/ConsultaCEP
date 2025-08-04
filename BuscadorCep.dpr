program BuscadorCep;

uses
  Vcl.Forms,
  BuscadorCep.Model.Conexao.Enum.Driver in 'Model\BuscadorCep.Model.Conexao.Enum.Driver.pas',
  BuscadorCep.Model.Conexao.Factory in 'Model\BuscadorCep.Model.Conexao.Factory.pas',
  BuscadorCep.Model.Conexao.SQLite in 'Model\BuscadorCep.Model.Conexao.SQLite.pas',
  BuscadorCep.Model.Interfaces in 'Model\BuscadorCep.Model.Interfaces.pas',
  BuscadorCep.Controller.Conexao in 'Controller\BuscadorCep.Controller.Conexao.pas',
  BuscadorCep.View.Principal in 'View\BuscadorCep.View.Principal.pas' {ViewPrincipal},
  BuscadorCep.Controller.Interfaces in 'Controller\BuscadorCep.Controller.Interfaces.pas',
  BuscadorCep.Model.Endereco in 'Model\BuscadorCep.Model.Endereco.pas',
  BuscadorCep.Controller.Endereco in 'Controller\BuscadorCep.Controller.Endereco.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.Run;
end.
