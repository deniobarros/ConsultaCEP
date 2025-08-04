unit uEnumTipoConsulta;

interface

type
  TTipoConsulta = (tcCEP, tcEndereco);

  TTipoConsultaHelper = record helper for TTipoConsulta
    function PegarDescricao: string;
  end;

implementation

uses
  System.SysUtils;

{ TTipoConsultaHelper }

function TTipoConsultaHelper.PegarDescricao: string;
begin
  case Self of
    tcCEP: Result := 'CEP';
    tcEndereco: Result := 'Endereço completo';
    else
      Result := emptystr;
  end;
end;

end.
