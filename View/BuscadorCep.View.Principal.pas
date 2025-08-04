unit BuscadorCep.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Data.DB, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, BuscadorCep.Controller.Interfaces,
  Vcl.StdCtrls, System.UITypes, uBuscaCEP, Vcl.Mask;

type
  TViewPrincipal = class(TForm)
    dsEndereco: TDataSource;
    pnPrincipal: TPanel;
    pnCamposEndereco: TPanel;
    pnGrid: TPanel;
    grEnderecos: TDBGrid;
    edtEndereco: TEdit;
    rgResultadoConsulta: TRadioGroup;
    edtEstado: TEdit;
    edtCidade: TEdit;
    lblEndereco: TLabel;
    lblCidade: TLabel;
    lblEstado: TLabel;
    btnPesquisaEndereco: TButton;
    DBNavigator1: TDBNavigator;
    lblCep: TLabel;
    btnPesquisaCEP: TButton;
    btnLimparCampos: TButton;
    BuscaCep: TBuscaCep;
    edtCEP: TMaskEdit;
    btnPesquisaEnderecosInseridos: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPesquisaEnderecoClick(Sender: TObject);
    procedure rgResultadoConsultaClick(Sender: TObject);
    procedure btnPesquisaCEPClick(Sender: TObject);
    procedure btnLimparCamposClick(Sender: TObject);
    procedure btnPesquisaEnderecosInseridosClick(Sender: TObject);
  private
    FControllerConexao: iControllerConexao;
    FControllerEndereco: iControllerEndereco;
    procedure ConsultarEndereco;
    procedure ConsultarCEP;
    procedure LimparCampos;
    function ExibirMensagemAtualizarInformacoesEndereco: Boolean;
    function ExibirMensagemPersonalizada(AMensagem, ATitulo, ABotao1Texto, ABotao2Texto: string): TModalResult;
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

{$R *.dfm}


uses BuscadorCep.Controller.Conexao, BuscadorCep.Controller.Endereco,
  Vcl.Dialogs, uEnumTipoRetornoConsulta;

procedure TViewPrincipal.btnLimparCamposClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TViewPrincipal.btnPesquisaCEPClick(Sender: TObject);
begin
  ConsultarCEP;
end;

procedure TViewPrincipal.btnPesquisaEnderecoClick(Sender: TObject);
begin
  ConsultarEndereco;
end;

procedure TViewPrincipal.btnPesquisaEnderecosInseridosClick(Sender: TObject);
begin
  FControllerEndereco.ConsultarTodosRegistros;
end;

procedure TViewPrincipal.ConsultarCEP;
var
  LExisteEndereco: Boolean;
begin
  FControllerEndereco.DataSet.DisableControls;
  try
    LExisteEndereco := FControllerEndereco.SetBuscaCEP(BuscaCep)
                                          .SetCEP(edtCep.Text)
                                          .ConsultarCEPNaBaseDados;
    if LExisteEndereco then
    begin
      if ExibirMensagemAtualizarInformacoesEndereco then
        FControllerEndereco.ConsultarCEPNoWS;

      Exit;
    end;

    FControllerEndereco.ConsultarCEPNoWS;
  finally
    FControllerEndereco.DataSet.EnableControls;
  end;
end;

procedure TViewPrincipal.ConsultarEndereco;
var
  LExisteEndereco: Boolean;
begin
  FControllerEndereco.DataSet.DisableControls;
  try
    LExisteEndereco := FControllerEndereco.SetBuscaCEP(BuscaCep)
                                          .SetEndereco(edtEndereco.Text)
                                          .SetCidade(edtCidade.Text)
                                          .SetEstado(edtEstado.Text)
                                          .ConsultarEnderecoNaBaseDados;
    if LExisteEndereco then
    begin
      if ExibirMensagemAtualizarInformacoesEndereco then
        FControllerEndereco.ConsultarEnderecoNoWS;

      Exit;
    end;

    FControllerEndereco.ConsultarEnderecoNoWS;
  finally
    FControllerEndereco.DataSet.EnableControls;
  end;
end;

function TViewPrincipal.ExibirMensagemAtualizarInformacoesEndereco: Boolean;
const
  sMENSAGEM_PERGUNTA = 'O que você deseja fazer?';
  sMENSAGEM_ESCOLHA_OPCAO = 'Escolha uma opção';
  sMENSAGEM_ENDERECO_BASE = 'Mostrar o(s) endereço(s) encontrado na base';
  sMENSAGEM_ENDERECO_WS = 'Mostrar endereço(s) atualizado(s) via webservice';
  mrEnderecoAtualizado = 7;
begin
  Result := ExibirMensagemPersonalizada(sMENSAGEM_PERGUNTA, sMENSAGEM_ESCOLHA_OPCAO,
                                        sMENSAGEM_ENDERECO_BASE, sMENSAGEM_ENDERECO_WS) = mrEnderecoAtualizado;
end;

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin
  FControllerConexao := TControllerConexao.New;
  FControllerConexao.Conectar;

  FControllerEndereco := TControllerEndereco.New(FControllerConexao)
                                            .SetBuscaCEP(BuscaCEP);

  dsEndereco.DataSet := FControllerEndereco.DataSet;
  rgResultadoConsulta.OnClick(rgResultadoConsulta);

  edtCEP.ValidateEdit;

  FControllerEndereco.ConsultarTodosRegistros;
end;

procedure TViewPrincipal.FormDestroy(Sender: TObject);
begin
  FControllerConexao.Desconectar;
  inherited;
end;

procedure TViewPrincipal.LimparCampos;
begin
  edtEndereco.Text := emptystr;
  edtCidade.Text := emptystr;
  edtEstado.Text := emptystr;
  edtCep.Text := emptystr;
end;

procedure TViewPrincipal.rgResultadoConsultaClick(Sender: TObject);
var
  LrgResultadoConsulta: TRadioGroup absolute Sender;
begin
  BuscaCEP.TipoRetornoConsulta := TTipoRetornoConsulta(LrgResultadoConsulta.ItemIndex);
end;

function TViewPrincipal.ExibirMensagemPersonalizada(AMensagem, ATitulo, ABotao1Texto,
  ABotao2Texto: string): TModalResult;
var
  LDialog: TForm;
  LBtn1, LBtn2: TButton;
begin
  LDialog := CreateMessageDialog(AMensagem, mtConfirmation, []);
  try
    LDialog.Caption := ATitulo;
    LDialog.BorderIcons := [];
    LDialog.Position := poMainFormCenter;
    LDialog.ClientHeight := 200;
    LDialog.ClientWidth:= 500;

    LBtn1 := TButton.Create(LDialog);
    LBtn1.Parent := LDialog;
    LBtn1.Caption := ABotao1Texto;
    LBtn1.ModalResult := mrYes;
    LBtn1.Left := (LDialog.ClientWidth - LBtn1.Width) div 5;
    LBtn1.Top := 80;
    LBtn1.Width := 340;

    LBtn2 := TButton.Create(LDialog);
    LBtn2.Parent := LDialog;
    LBtn2.Caption := ABotao2Texto;
    LBtn2.ModalResult := mrNo;
    LBtn2.Left := (LDialog.ClientWidth - LBtn2.Width) div 5;
    LBtn2.Top := LBtn1.Top + LBtn1.Height + 10;
    LBtn2.Width := 340;

    Result := LDialog.ShowModal;
  finally
    LDialog.Free;
  end;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
