unit uEnumTipoRetornoConsulta;

interface

type
  TTipoRetornoConsulta = (rcJSON, rcXML);

  TTipoRetornoConsultaHelper = record helper for TTipoRetornoConsulta
    function PegarRecurso: String;
  end;


implementation

uses
  System.SysUtils;

function TTipoRetornoConsultaHelper.PegarRecurso: String;
begin
  case Self of
    rcJSON: Result := 'json' ;
    rcXML: Result := 'xml';
    else
      Result := emptystr;
  end;
end;

end.
