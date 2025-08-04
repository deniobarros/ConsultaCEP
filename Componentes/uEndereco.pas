unit uEndereco;

interface

uses
  System.Generics.Collections;

type
  TEndereco = class
  private
    Fcep: string;
    Flogradouro: string;
    Fcomplemento: string;
    Funidade: string;
    Fbairro: string;
    Flocalidade: string;
    Fuf: string;
    Fibge: string;
    Fgia: string;
    Fddd: string;
    Fsiafi: string;
  public
    property cep: string read Fcep write Fcep;
    property logradouro: string read Flogradouro write Flogradouro;
    property complemento: string read Fcomplemento write Fcomplemento;
    property unidade: string read Funidade write Funidade;
    property bairro: string read Fbairro write Fbairro;
    property localidade: string read Flocalidade write Flocalidade;
    property uf: string read Fuf write Fuf;
    property ibge: string read Fibge write Fibge;
    property gia: string read Fgia write Fgia;
    property ddd: string read Fddd write Fddd;
    property siafi: string read Fsiafi write Fsiafi;
  end;

implementation

end.
