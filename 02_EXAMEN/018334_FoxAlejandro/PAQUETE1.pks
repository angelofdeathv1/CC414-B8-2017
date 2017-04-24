create or replace package foxtest2.paquete1
as
    procedure bandamenosintegrantes(bandid out number);
    
    procedure insertarmusico( nombre in varchar2, nacimiento in date, companeros out sys_refcursor);
    
end paquete1;