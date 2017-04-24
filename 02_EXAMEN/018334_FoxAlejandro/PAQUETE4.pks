create or replace package foxtest2.paquete4
is
type array_number is varray(100) of number;
procedure getvenues(pais in varchar2, venues out sys_refcursor);
procedure getbands(bandas out sys_refcursor);
procedure getmembers (miembros out sys_refcursor);
procedure getinstrument(miembro in number, instrumento out number);
procedure createband (nombre in varchar2, fecha in date, bandid out number);
procedure getnextsunday(fecha in date, sunday out date);
procedure createconcert(fecha in date, venue in number, concertid out number);
procedure createtour(lineup out sys_refcursor);
procedure createtourpais(pais in varchar2, bandas in array_number, fecha in date, fechainterna out date, arrayconcierto out array_number);
end paquete4;