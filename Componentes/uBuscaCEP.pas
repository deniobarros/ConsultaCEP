unit uBuscaCEP;

interface

{$M+}
{$TYPEINFO ON}

uses
  Vcl.StdCtrls, Vcl.ComStrs, uEnumTipoRetornoConsulta, REST.Client, REST.Consts,
  System.SysUtils, System.Classes, VCL.Forms, Winapi.Windows, uEndereco, Rest.JSON,
  System.JSON, system.Generics.Collections, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, Xml.Win.msxmldom,
  XML.XMLSchemaTags, uEnumTipoConsulta, system.NetEncoding;

type
  TBuscaCep = class(TComponent)
  private
    FTipoRetornoConsulta: TTipoRetornoConsulta;
    FEndereco: String;
    FEstado: String;
    FCidade: String;
    FCEP: String;
    FTipoConsulta: TTipoConsulta;
    function PegarRecursoCEP: string;
    procedure PreencherRecurso(ARESTRequest: TRESTRequest); overload;
    procedure PreencherRecurso(AXMLDocument: IXMLDocument); overload;
    procedure AdicionarRecursoCEP(ARESTRequest: TRESTRequest); overload;
    procedure AdicionarRecursoCEP(AXMLDocument: IXMLDocument); overload;
    procedure AdicionarRecursoEndereco(ARESTRequest: TRESTRequest); overload;
    procedure AdicionarRecursoEndereco(AXMLDocument: IXMLDocument); overload;
    procedure PreencherBaseURL(ARESTClient: TRESTClient); overload;
    procedure PreencherBaseURL(AXMLDocument: IXMLDocument); overload;
    procedure ExibirMensagem(AMensagem: string);
    procedure SetCEP(const Value: String);
    procedure SetEndereco(const Value: String);
    procedure SetEstado(const Value: String);
    procedure SetCidade(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    function ConsultarComRetornoJSON: string;
    function ConsultarComRetornoXML: string;
  published
    property TipoRetornoConsulta: TTipoRetornoConsulta read FTipoRetornoConsulta write FTipoRetornoConsulta;
    property TipoConsulta: TTipoConsulta read FTipoConsulta write FTipoConsulta;
    property Endereco: String read FEndereco write SetEndereco;
    property Estado: String read FEstado write SetEstado;
    property Cidade: String read FCidade write SetCidade;
    property CEP: String read FCEP write SetCEP;
  end;

  procedure Register;

implementation

uses
  uErro, REST.Types;

const
  nHTTP_STATUS_OK = 200;
  sCAPTION_MENSAGEM = 'Aviso';
  sPARAMETRO_CEP = 'CEP';
  sPARAMETRO_UF = 'UF';
  sPARAMETRO_CIDADE = 'CIDADE';
  sPARAMETRO_LOGRADOURO = 'LOGRADOURO';
  sMENSAGEM_ENDERECO_NAO_ENCONTRADO = 'Endereço ou CEP não existe ou não está cadastrado na base de dados do webservice';
  sMENSAGEM_FALHA_CONSULTA = 'Falha ao consultar Endereço ou CEP';
  sBASE_URL = 'https://viacep.com.br/ws/';
  sURL_CEP = '{CEP}/';
  sURL_ENDERECO = '{UF}/{CIDADE}/{LOGRADOURO}/';
  sTRUE = 'true';

procedure TBuscaCep.AdicionarRecursoCEP(ARESTRequest: TRESTRequest);
begin
  ARESTRequest.Resource := PegarRecursoCEP;
  ARESTRequest.Params.AddUrlSegment(sPARAMETRO_CEP, FCEP);
end;

procedure TBuscaCep.AdicionarRecursoCEP(AXMLDocument: IXMLDocument);
var
  sRecurso: string;
begin
  sRecurso := FCEP + '/';
  AXMLDocument.FileName := AXMLDocument.FileName + TNetEncoding.URL.Encode(sRecurso) + FTipoRetornoConsulta.PegarRecurso + '/';
end;

procedure TBuscaCep.AdicionarRecursoEndereco(AXMLDocument: IXMLDocument);
var
  sRecurso: string;
begin
  sRecurso := FESTADO + '/' + FCIDADE + '/'+
              FEndereco + '/';

  AXMLDocument.FileName := AXMLDocument.FileName + TNetEncoding.URL.Encode(sRecurso) + FTipoRetornoConsulta.PegarRecurso + '/';
end;

procedure TBuscaCep.AdicionarRecursoEndereco(ARESTRequest: TRESTRequest);
begin
  ARESTRequest.Resource := sURL_ENDERECO + FTipoRetornoConsulta.PegarRecurso;
  ARESTRequest.Params.AddUrlSegment(sPARAMETRO_UF, TNetEncoding.URL.Encode(FEstado));
  ARESTRequest.Params.AddUrlSegment(sPARAMETRO_CIDADE, TNetEncoding.URL.Encode(FCidade));
  ARESTRequest.Params.AddUrlSegment(sPARAMETRO_LOGRADOURO, TNetEncoding.URL.Encode(FEndereco));
end;

constructor TBuscaCep.Create(AOwner: TComponent);
begin
  inherited;
  FCep := emptystr;
  FEndereco := emptystr;
  FEstado := emptystr;
  FCidade := emptystr;
end;

function TBuscaCep.ConsultarComRetornoJSON: string;
var
  LRESTRequest: TRESTRequest;
  LRESTClient: TRESTClient;
  LRESTResponse: TRESTResponse;
begin
  Result := emptystr;
  FTipoRetornoConsulta := rcJSON;

  LRESTClient := nil;
  LRESTRequest := nil;
  LRESTResponse := nil;
  try
    LRESTClient := TRESTClient.Create(nil);
    LRESTRequest := TRESTRequest.Create(nil);
    LRESTResponse := TRESTResponse.Create(nil);
    try
      LRESTRequest.Client := LRESTClient;
      LRESTRequest.Response := LRESTResponse;
      LRESTRequest.Method := rmGET;

      PreencherBaseURL(LRESTClient);
      PreencherRecurso(LRESTRequest);

      LRESTRequest.Execute;

      if LRESTResponse.StatusCode <> nHTTP_STATUS_OK then
      begin
        ExibirMensagem(sMENSAGEM_ENDERECO_NAO_ENCONTRADO);
        Exit;
      end;

      Result := LRESTResponse.JSONValue.ToString;
    except
      raise Exception.Create(sMENSAGEM_FALHA_CONSULTA);
    end;
  finally
    LRESTClient.Free;
    LRESTResponse.Free;
    LRESTRequest.Free;
  end;
end;

function TBuscaCep.ConsultarComRetornoXML: String;
var
  LXMLDocument: IXMLDocument;
begin
  Result := emptystr;
  FTipoRetornoConsulta := rcXML;

  LXMLDocument := TXMLDocument.Create(nil);
  try
    PreencherBaseURL(LXMLDocument);
    PreencherRecurso(LXMLDocument);

    LXMLDocument.Active := True;

    Result := LXMLDocument.XML.Text;
  except
    raise Exception.Create(sMENSAGEM_FALHA_CONSULTA);
  end;
end;

procedure TBuscaCep.ExibirMensagem(AMensagem: string);
begin
  Application.MessageBox(PChar(AMensagem), sCAPTION_MENSAGEM, MB_OK + MB_ICONWARNING);
end;

function TBuscaCep.PegarRecursoCEP: string;
begin
  Result := sURL_CEP + FTipoRetornoConsulta.PegarRecurso;
end;

procedure TBuscaCep.PreencherBaseURL(ARESTClient: TRESTClient);
begin
  ARESTClient.BaseURL := sBASE_URL;
end;

procedure TBuscaCep.PreencherBaseURL(AXMLDocument: IXMLDocument);
begin
  AXMLDocument.FileName := sBASE_URL;
end;

procedure TBuscaCep.PreencherRecurso(AXMLDocument: IXMLDocument);
begin
  if (FTipoConsulta = tcCEP) then
    AdicionarRecursoCEP(AXMLDocument)
  else
    AdicionarRecursoEndereco(AXMLDocument);
end;

procedure TBuscaCep.SetCEP(const Value: String);
begin
  FCEP := Value;
end;

procedure TBuscaCep.SetCidade(const Value: String);
begin
  FCidade := Trim(Value);
end;

procedure TBuscaCep.SetEndereco(const Value: String);
begin
  FEndereco := Trim(Value);
end;

procedure TBuscaCep.SetEstado(const Value: String);
begin
  FEstado := Trim(Value);
end;

procedure TBuscaCep.PreencherRecurso(ARESTRequest: TRESTRequest);
begin
  if (FTipoConsulta = tcCEP) then
    AdicionarRecursoCEP(ARESTRequest)
  else
    AdicionarRecursoEndereco(ARESTRequest);
end;

procedure Register;
begin
  RegisterComponents('VIACEP', [TBuscaCep]);
end;

end.
