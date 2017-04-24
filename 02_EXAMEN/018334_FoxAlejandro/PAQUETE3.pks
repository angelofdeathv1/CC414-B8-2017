create or replace package foxtest2.paquete3
as
    procedure getmembers(miembros out sys_refcursor);
    
    procedure getinstrument(miembroid in number, instrumentid out number);
    
    procedure createband(nombre in varchar2, fecha in date, consulta out sys_refcursor);
    
    procedure altabanda (nombre in varchar2, fecha in date, musico in number, bandid out number);
   
    
end paquete3;