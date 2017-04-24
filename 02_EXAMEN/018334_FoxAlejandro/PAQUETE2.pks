create or replace package foxtest2.paquete2
as
    procedure getgenreid(genreid out number);
    
    procedure sortbands(genreid in number, orden out sys_refcursor);
    
    procedure createconcert(fecha in date, lineup out sys_refcursor);
end paquete2;