unit BuscadorCep.Model.Endereco;

interface

uses
  BuscadorCep.Model.Interfaces,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, uBuscaCep, uEndereco, System.JSON,
  System.SysUtils, Vcl.Forms, Winapi.Windows, uEnumTipoRetornoConsulta,
  System.Generics.Collections, uErro, REST.JSON, Xml.XMLIntf, uEnumTipoConsulta;

type
  TModelEndereco = class(TInterfacedObject, iModelEndereco)
  private
  const
    {$REGION 'SQL_CONSULTA_ENDERECO'}
    sSQL_CONSULTA_ENDERECO =
      '  SELECT                                                 ' +
      '         CODIGO,                                         ' +
      '         CEP,                                            ' +
      '         LOGRADOURO,                                     ' +
      '         COMPLEMENTO,                                    ' +
      '         BAIRRO,                                         ' +
      '         LOCALIDADE,                                     ' +
      '         UF                                              ' +
      '  FROM                                                   ' +
      '        ENDERECO                                         ' +
      '  WHERE LOGRADOURO LIKE :LOGRADOURO   AND                ' +
      '        LOCALIDADE LIKE :LOCALIDADE   AND                ' +
      '        UF LIKE :UF                                      ';
    {$ENDREGION}
    {$REGION 'SQL_CONSULTA_CEP'}
    sSQL_CONSULTA_CEP =
      '  SELECT                                                 ' +
      '         CODIGO,                                         ' +
      '         CEP,                                            ' +
      '         LOGRADOURO,                                     ' +
      '         COMPLEMENTO,                                    ' +
      '         BAIRRO,                                         ' +
      '         LOCALIDADE,                                     ' +
      '         UF                                              ' +
      '  FROM                                                   ' +
      '         ENDERECO                                        ' +
      '  WHERE                                                  ' +
      '        CEP = :CEP                                       ';
    {$ENDREGION}
    {$REGION 'SQL_CONSULTA_TODOS_REGISTROS'}
    sSQL_CONSULTA_TODOS_REGISTROS=
      '  SELECT                                                 ' +
      '         CODIGO,                                         ' +
      '         CEP,                                            ' +
      '         LOGRADOURO,                                     ' +
      '         COMPLEMENTO,                                    ' +
      '         BAIRRO,                                         ' +
      '         LOCALIDADE,                                     ' +
      '         UF                                              ' +
      '  FROM                                                   ' +
      '        ENDERECO                                         ' ;
    {$ENDREGION}
    nMINIMO_CARACTERES = 3;
    sMSG_CAMPO_INCORRETO = 'Campo %s informado incorretamente.';
    sCAPTION_AVISO = 'Aviso';
    sMENSAGEM_NAO_ENCONTRADO = '%s não foi encontrado';
    sCEP_INVALIDO = 'CEP Inválido';
    nQUANTIDADE_DIGITOS_CEP = 8;
  var
    FQuery: TFDQuery;
    FCEP: String;
    FCidade: string;
    FEstado: string;
    FEndereco: string;
    FMensagemValidacao: string;
    FBuscaCEP: TBuscaCep;
    function RetornarSomenteNumerosCEP(ACEP: string): string;
    function ValidarSeConteudoRetornoJSONTemRegistros(AJSONValue: TJSONValue): Boolean;
    function ValidarParametrosEndereco(AExibirMensagem: Boolean = true): Boolean;
    function ValidarSeEnderecoConstaNaBaseDeDadosWS(AJSONValue: TJSONValue) : Boolean; overload;
    function ValidarSeEnderecoConstaNaBaseDeDados(AXMLDocument: IXMLDocument): Boolean; overload;
    function ValidarSeConteudoRetornoJSONNaoOcorreuErro(AJSONValue: TJSONValue): Boolean; overload;
    function PreencherListaDeEnderecosSeHouver(AJSONValue: TJSONValue; AListaEnderecos: TObjectList<TEndereco>): Boolean; overload;
    function PreencherListaDeEnderecosSeHouver(ANodeEnderecos: IXMLNode; ANodeRoot: IXMLNode; AListaEnderecos: TObjectList<TEndereco>): Boolean; overload;
    function ValidarCEP(AExibirMensagem: Boolean = true): boolean;
    function GravarEnderecos(AListaEnderecos: TObjectList<TEndereco>): Boolean;
    function PegarMensagemNaoEncontrado: string;
    procedure ExecutarConsultaWS(AListaEnderecos: TObjectList<TEndereco>);
    procedure PreencherQueryComEndereco(AQuery: TFDQuery; AEndereco: TEndereco);
    procedure AdicionarMensagemValidacao(ACampo: string);
    procedure RemoverMensagemValidacao(ACampo: string);
    procedure ExibirMensagem(AMensagem: string);
    procedure PreencherEnderecosPorJson(AJsonRetorno: string; AListaEnderecos: TObjectList<TEndereco>);
    procedure PreencherEnderecosPorXML(AXML: string; AListaEnderecos: TObjectList<TEndereco>);
    procedure PreencherEndereco(AJSONValue: TJSONValue; AListaEnderecos: TObjectList<TEndereco>); overload;
    procedure PreencherEndereco(ANodeEnderecos: IXMLNode; ANodeRoot: IXMLNode; AListaEnderecos: TObjectList<TEndereco>); overload;
    procedure PreencherEnderecoPorNodeXML(ANodeXML: IXMLNode; AEndereco: TEndereco);
  public
    constructor Create(AConexao: TCustomConnection);
    destructor Destroy; override;
    class function New(AConexao: TCustomConnection): iModelEndereco;
    function SetEndereco(AEndereco: string): iModelEndereco;
    function SetCidade(ACidade: string): iModelEndereco;
    function SetEstado(AEstado: string): iModelEndereco;
    function SetBuscaCEP(ABuscaCEP: TBuscaCep): iModelEndereco;
    function SetCEP(ACEP: String): iModelEndereco;
    function DataSet: TDataSet;
    function ConsultarEnderecoNaBaseDados: Boolean;
    function ConsultarCEPNaBaseDados: Boolean;
    function ConsultarCEPNoWS: iModelEndereco;
    function ConsultarEnderecoNoWS: iModelEndereco;
    function ConsultarTodosRegistros: iModelEndereco;
  end;

implementation

uses
  Xml.XMLDoc;

procedure TModelEndereco.AdicionarMensagemValidacao(ACampo: string);
begin
  if (FMensagemValidacao = emptystr) then
  begin
    if Pos(ACampo, FMensagemValidacao) = 0 then
      FMensagemValidacao := Format(sMSG_CAMPO_INCORRETO, [ACampo]) + sLineBreak;
    Exit;
  end;

  if Pos(ACampo, FMensagemValidacao) = 0 then
    FMensagemValidacao := FMensagemValidacao + Format(sMSG_CAMPO_INCORRETO,
                          [ACampo]) + sLineBreak;
end;

function TModelEndereco.ConsultarCEPNaBaseDados: Boolean;
begin
  Result := False;

  if not ValidarCEP then
    Exit;

  FQuery.SQL.Clear;
  FQuery.SQL.Text := sSQL_CONSULTA_CEP;
  FQuery.ParamByName('CEP').AsString := FCEP;
  FQuery.Open;

  Result := not FQuery.IsEmpty;
end;

function TModelEndereco.ConsultarCEPNoWS: iModelEndereco;
var
  LListaEnderecos: TObjectList<TEndereco>;
begin
  Result := Self;

  LListaEnderecos := TObjectList<TEndereco>.Create;
  try
    if not ValidarCEP(False) then
      Exit;

    FBuscaCEP.CEP := RetornarSomenteNumerosCEP(FCEP);
    FBuscaCEP.TipoConsulta := tcCEP;

    ExecutarConsultaWS(LListaEnderecos);

    if GravarEnderecos(LListaEnderecos) then
      ConsultarCEPNaBaseDados;
  finally
    LListaEnderecos.Destroy;
  end;
end;

function TModelEndereco.ConsultarEnderecoNaBaseDados: Boolean;
begin
  Result := False;

  if not ValidarParametrosEndereco then
    Exit;

  FQuery.SQL.Clear;
  FQuery.SQL.Text := sSQL_CONSULTA_ENDERECO;
  FQuery.ParamByName('LOGRADOURO').AsString := '%' + FEndereco + '%';
  FQuery.ParamByName('LOCALIDADE').AsString := '%' + FCidade + '%';
  FQuery.ParamByName('UF').AsString := '%' + FEstado + '%';
  FQuery.Open;

  Result := not FQuery.IsEmpty;
end;

function TModelEndereco.ConsultarEnderecoNoWS;
var
  LListaEnderecos: TObjectList<TEndereco>;
begin
  Result := Self;

  LListaEnderecos := TObjectList<TEndereco>.Create;
  try
    if not ValidarParametrosEndereco(False) then
      Exit;

    FBuscaCEP.Estado := FEstado;
    FBuscaCEP.Cidade := FCidade;
    FBuscaCEP.Endereco := FEndereco;
    FBuscaCEP.TipoConsulta := tcEndereco;

    ExecutarConsultaWS(LListaEnderecos);

    if GravarEnderecos(LListaEnderecos) then
      ConsultarEnderecoNaBaseDados;
  finally
    LListaEnderecos.Destroy;
  end;
end;

function TModelEndereco.ConsultarTodosRegistros: iModelEndereco;
begin
  Result := Self;

  FQuery.SQL.Clear;
  FQuery.SQL.Text := sSQL_CONSULTA_TODOS_REGISTROS;
  FQuery.Open;
end;

constructor TModelEndereco.Create(AConexao: TCustomConnection);
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TFDConnection(AConexao);
end;

destructor TModelEndereco.Destroy;
begin
  FreeAndNil(FQuery);
  inherited;
end;

procedure TModelEndereco.ExecutarConsultaWS(AListaEnderecos: TObjectList<TEndereco>);
var
  LJSONEnderecos: string;
  LXML: string;
begin
  case FBuscaCEP.TipoRetornoConsulta of
    rcJSON:
      begin
        LJSONEnderecos := FBuscaCEP.ConsultarComRetornoJSON;
        PreencherEnderecosPorJson(LJSONEnderecos, AListaEnderecos);
      end;

    rcXML:
      begin
        LXML := FBuscaCEP.ConsultarComRetornoXML;
        PreencherEnderecosPorXML(LXML, AListaEnderecos);
      end;
  end;
end;

procedure TModelEndereco.ExibirMensagem(AMensagem: string);
begin
  Application.MessageBox(PChar(AMensagem), sCAPTION_AVISO, MB_OK + MB_ICONWARNING);
end;

function TModelEndereco.GravarEnderecos(AListaEnderecos: TObjectList<TEndereco>): Boolean;
var
  I: integer;
  LEndereco: TEndereco;
begin
  Result := False;

  if AListaEnderecos.IsEmpty then
    Exit;

  for I := 0 to AListaEnderecos.Count -1 do
  begin
    LEndereco := AListaEnderecos.Items[I];
    FCEP := RetornarSomenteNumerosCEP(LEndereco.cep);

    if ConsultarCEPNaBaseDados then
      FQuery.Edit
    else
      FQuery.Append;

    PreencherQueryComEndereco(FQuery, LEndereco);

    FQuery.Post;
  end;

  Result := True;
end;

class function TModelEndereco.New(AConexao: TCustomConnection): iModelEndereco;
begin
  Result := Self.Create(AConexao);
end;

procedure TModelEndereco.PreencherEndereco(AJSONValue: TJSONValue;
  AListaEnderecos: TObjectList<TEndereco>);
var
  LJSONObjectEndereco: TJSONObject;
  LEndereco: TEndereco;
begin
  if not Assigned(AJSONValue) then
    Exit;

  LJSONObjectEndereco := (AJSONValue as TJSONObject);
  LEndereco := TJSON.JsonToObject<TEndereco>(LJSONObjectEndereco);
  AListaEnderecos.Add(LEndereco);
end;

function TModelEndereco.PegarMensagemNaoEncontrado: string;
begin
  Result := Format(sMENSAGEM_NAO_ENCONTRADO, [FBuscaCEP.TipoConsulta.PegarDescricao]);
end;

procedure TModelEndereco.PreencherEndereco(ANodeEnderecos, ANodeRoot: IXMLNode;
  AListaEnderecos: TObjectList<TEndereco>);
var
 LEndereco: TEndereco;
begin
  if not Assigned(ANodeEnderecos) then
  begin
    LEndereco := TEndereco.Create;

    PreencherEnderecoPorNodeXML(ANodeRoot, LEndereco);
    AListaEnderecos.Add(LEndereco);
  end;
end;

procedure TModelEndereco.PreencherEnderecoPorNodeXML(ANodeXML: IXMLNode;
  AEndereco: TEndereco);
begin
  AEndereco.cep         := ANodeXML.ChildNodes['cep'].Text;
  AEndereco.logradouro  := ANodeXML.ChildNodes['logradouro'].Text;
  AEndereco.complemento := ANodeXML.ChildNodes['complemento'].Text;
  AEndereco.unidade     := ANodeXML.ChildNodes['unidade'].Text;
  AEndereco.bairro      := ANodeXML.ChildNodes['bairro'].Text;
  AEndereco.localidade  := ANodeXML.ChildNodes['localidade'].Text;
  AEndereco.uf          := ANodeXML.ChildNodes['uf'].Text;
  AEndereco.ibge        := ANodeXML.ChildNodes['ibge'].Text;
  AEndereco.gia         := ANodeXML.ChildNodes['gia'].Text;
  AEndereco.ddd         := ANodeXML.ChildNodes['ddd'].Text;
  AEndereco.siafi       := ANodeXML.ChildNodes['siafi'].Text;
end;

procedure TModelEndereco.PreencherEnderecosPorJson(AJsonRetorno: string;
  AListaEnderecos: TObjectList<TEndereco>);
var
  LJSONValue: TJSONValue;
begin
  LJSONValue := TJSONObject.ParseJSONValue(AJsonRetorno);
  try
    if not ValidarSeEnderecoConstaNaBaseDeDadosWS(LJSONValue) then
      Exit;

    if PreencherListaDeEnderecosSeHouver(LJSONValue, AListaEnderecos) then
      Exit;

    PreencherEndereco(LJSONValue, AListaEnderecos);
  finally
    if Assigned(LJSONValue) then
      LJSONValue.Destroy;
  end;
end;

procedure TModelEndereco.PreencherEnderecosPorXML(AXML: string; AListaEnderecos: TObjectList<TEndereco>);
var
  nodeEnderecos: IXMLNode;
  nodeRoot: IXMLNode;
  LXMLDocument: IXMLDocument;
begin
  LXMLDocument := NewXMLDocument;
  LXMLDocument.LoadFromXML(AXML);

  if not ValidarSeEnderecoConstaNaBaseDeDados(LXMLDocument) then
    Exit;

  if LXMLDocument.IsEmptyDoc then
    Exit;

  nodeRoot := LXMLDocument.DocumentElement;

  nodeEnderecos := nodeRoot.ChildNodes.FindNode('enderecos');

  if PreencherListaDeEnderecosSeHouver(nodeEnderecos, nodeRoot, AListaEnderecos) then
    Exit;

  PreencherEndereco(nodeEnderecos, nodeRoot, AListaEnderecos);
end;

function TModelEndereco.PreencherListaDeEnderecosSeHouver(ANodeEnderecos: IXMLNode; ANodeRoot: IXMLNode; AListaEnderecos: TObjectList<TEndereco>): Boolean;
var
 LEndereco: TEndereco;
 LnodeEndereco: IXMLNode;
 I: integer;
begin
  Result := False;

  if not Assigned(ANodeEnderecos) then
    Exit;
  
  for I := 0 to ANodeEnderecos.ChildNodes.Count -1 do
  begin
    LnodeEndereco := ANodeEnderecos.ChildNodes[I];

    LEndereco := TEndereco.Create;
    PreencherEnderecoPorNodeXML(LnodeEndereco, LEndereco);

    AListaEnderecos.Add(LEndereco);
  end;

  Result := True;
end;

procedure TModelEndereco.PreencherQueryComEndereco(AQuery: TFDQuery;
  AEndereco: TEndereco);
begin
  FQuery.FieldByName('CEP').AsString         := RetornarSomenteNumerosCEP(AEndereco.cep);
  FQuery.FieldByName('LOGRADOURO').AsString  := AEndereco.logradouro;
  FQuery.FieldByName('COMPLEMENTO').AsString := AEndereco.complemento;
  FQuery.FieldByName('BAIRRO').AsString      := AEndereco.bairro;
  FQuery.FieldByName('LOCALIDADE').AsString  := AEndereco.localidade;
  FQuery.FieldByName('UF').AsString          := AEndereco.uf;
end;

procedure TModelEndereco.RemoverMensagemValidacao(ACampo: string);
var
  LMensagem: string;
begin
  LMensagem := Format(sMSG_CAMPO_INCORRETO, [ACampo]) + sLineBreak;

  FMensagemValidacao := StringReplace(FMensagemValidacao, LMensagem, emptystr,[rfReplaceAll]);
end;

function TModelEndereco.RetornarSomenteNumerosCEP(ACEP: string): string;
begin
  Result := StringReplace(ACEP, '-', '', [rfReplaceAll]);
  Result := StringReplace(Result, '_', '', [rfReplaceAll]);
end;

function TModelEndereco.PreencherListaDeEnderecosSeHouver
  (AJSONValue: TJSONValue; AListaEnderecos: TObjectList<TEndereco>) : Boolean;
var
  LJSONArrayEnderecos: TJSONArray;
  LEndereco: TEndereco;
  I: Integer;
begin
  Result := False;

  if AJSONValue is TJSONArray then
  begin
    LJSONArrayEnderecos := (AJSONValue as TJSONArray);
    for I := 0 to LJSONArrayEnderecos.Count - 1 do
    begin
      LEndereco := TJSON.JsonToObject<TEndereco>(LJSONArrayEnderecos.Items[I].ToString);
      AListaEnderecos.Add(LEndereco)
    end;

    Result := True;
  end;
end;

function TModelEndereco.DataSet: TDataSet;
begin
  Result := TDataSet(FQuery);
end;

function TModelEndereco.SetBuscaCEP(ABuscaCEP: TBuscaCep): iModelEndereco;
begin
  Result := Self;
  FBuscaCEP := ABuscaCEP;
end;

function TModelEndereco.SetCEP(ACEP: String): iModelEndereco;
begin
  Result := Self;
  FCEP := ACEP;
end;

function TModelEndereco.SetCidade(ACidade: string): iModelEndereco;
begin
  Result := Self;
  FCidade := ACidade;

  if Length(FCidade) < nMINIMO_CARACTERES then
  begin
    AdicionarMensagemValidacao('Cidade');
    Exit;
  end;

  RemoverMensagemValidacao('Cidade');
end;

function TModelEndereco.SetEndereco(AEndereco: string): iModelEndereco;
begin
  Result := Self;
  FEndereco := AEndereco;

  if Length(FEndereco) < nMINIMO_CARACTERES then
  begin
    AdicionarMensagemValidacao('Endereco');
    Exit;
  end;

  RemoverMensagemValidacao('Endereco');
end;

function TModelEndereco.SetEstado(AEstado: string): iModelEndereco;
begin
  Result := Self;
  FEstado := AEstado;

  if (FEstado = emptystr) then
  begin
    AdicionarMensagemValidacao('Estado');
    Exit;
  end;

  RemoverMensagemValidacao('Estado');
end;

function TModelEndereco.ValidarCEP(AExibirMensagem: Boolean): boolean;
begin
  Result := False;

  if (Length(RetornarSomenteNumerosCEP(FCEP)) <> nQUANTIDADE_DIGITOS_CEP) then
  begin
    if AExibirMensagem then
      ExibirMensagem(sCEP_INVALIDO);
    Exit;
  end;

  Result := True;
end;

function TModelEndereco.ValidarParametrosEndereco(AExibirMensagem: Boolean): Boolean;
begin
  Result := False;

  if (FMensagemValidacao <> emptystr) then
  begin
    if AExibirMensagem then
      ExibirMensagem(FMensagemValidacao);
    Exit;
  end;

  Result := True;
end;

function TModelEndereco.ValidarSeConteudoRetornoJSONNaoOcorreuErro
  (AJSONValue: TJSONValue): Boolean;
var
  LErro: TErro;
begin
  Result := False;

  if not(AJSONValue is TJSONObject) then
    Exit(True);

  if Assigned((AJSONValue as TJSONObject).FindValue('erro')) then
  begin
    LErro := TJSON.JsonToObject<TErro>(AJSONValue as TJSONObject);
    try
      if LErro.erro then
      begin
        ExibirMensagem(PegarMensagemNaoEncontrado);
        Exit;
      end;
    finally
      FreeAndNil(LErro);
    end;
  end;

  Result := True;
end;

function TModelEndereco.ValidarSeConteudoRetornoJSONTemRegistros
  (AJSONValue: TJSONValue): Boolean;
begin
  Result := False;

  if (AJSONValue is TJSONArray) then
  begin
    if TJSONArray(AJSONValue).IsEmpty then
    begin
      ExibirMensagem(PegarMensagemNaoEncontrado);

      Exit;
    end;
  end;

  Result := True;
end;

function TModelEndereco.ValidarSeEnderecoConstaNaBaseDeDados(
  AXMLDocument: IXMLDocument): Boolean;
var
  LRootNode: IXMLNode;
begin
  Result := False;
  LRootNode := AXMLDocument.DocumentElement;

  if Assigned(LRootNode.ChildNodes.FindNode(('erro'))) then
  begin
    ExibirMensagem(PegarMensagemNaoEncontrado);
    Exit;
  end;

  Result := True;
end;

function TModelEndereco.ValidarSeEnderecoConstaNaBaseDeDadosWS
  (AJSONValue: TJSONValue): Boolean;
begin
  Result := False;

  if not ValidarSeConteudoRetornoJSONTemRegistros(AJSONValue) then
    Exit;

  if not ValidarSeConteudoRetornoJSONNaoOcorreuErro(AJSONValue) then
    Exit;

  Result := True;
end;

end.
