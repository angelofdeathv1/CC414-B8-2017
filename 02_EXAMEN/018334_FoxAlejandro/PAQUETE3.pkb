create or replace package body FOXTEST2.paquete3
as
    procedure getmembers(miembros out sys_refcursor)
        as
        begin
            open miembros for
                select musician_id from (select musicos.*, row_number() over (order by cuenta desc) as fila 
                from (select distinct musician_id, cuenta from(select bm.MUSICIAN_ID, bm.band_id, 
                count(bmi.instrument_id) over (partition by bm.musician_id) as cuenta, bmi.INSTRUMENT_ID 
                from MUDB.BANDS_MUSICIANS_INSTRUMENTS bmi
                inner join MUDB.BANDS_MUSICIANS bm on bm.BAND_MUSICIAN_ID = bmi.BAND_MUSICIAN_ID inner join MUDB.MUSICIANS musi on musi.MUSICIAN_ID = bm.MUSICIAN_ID
                where musi.DATE_DIED is null))musicos) where fila <=6;
        end getmembers;
        
    procedure getinstrument(miembroid in number, instrumentid out number)
        as
        begin
            select instrument_id into instrumentid from (select bandid.band_id, bmi.INSTRUMENT_ID, row_number() over (order by bmi.instrument_id) as fila from (select bandas.band_creation_date, bandas.band_id, row_number() over (order by bandas.band_creation_date) as fila
            from MUDB.BANDS bandas inner join MUDB.BANDS_MUSICIANS bm on bandas.BAND_ID = bm.BAND_ID
            where bm.musician_id = miembroid) bandid inner join MUDB.BANDS_MUSICIANS bm on bm.BAND_ID = bandid.BAND_ID inner join MUDB.BANDS_MUSICIANS_INSTRUMENTS bmi
            on bm.BAND_MUSICIAN_ID = bmi.BAND_MUSICIAN_ID where fila = 1) where fila = 1;
        end getinstrument;
        
    procedure createband(nombre in varchar2, fecha in date, consulta out sys_refcursor)
    is
        miembros sys_refcursor;
        temp number;
        tempinstrument number;
        type array_number is varray(6) of number;
        arraymiembros array_number;
        arrayinstrumentos array_number;
        bandid number;
        bandmusicianid number;
    begin
        arrayinstrumentos := array_number();
        arrayinstrumentos.extend(6);
        FOXTEST2.PAQUETE3.getmembers(miembros);
            fetch miembros
            bulk collect into arraymiembros;
        FOXTEST2.PAQUETE3.altabanda(nombre, fecha, arraymiembros(1), bandid);
        for i in arraymiembros.first .. arraymiembros.last
            loop
            bandmusicianid := MUDB.BAND_MUSICIAN_SEQ.nextval;
            FOXTEST2.PAQUETE3.getinstrument(arraymiembros(i), tempinstrument);
            arrayinstrumentos(i) := tempinstrument;
            insert into MUDB.BANDS_MUSICIANS values (bandmusicianid, bandid, arraymiembros(i));
            insert into MUDB.BANDS_MUSICIANS_INSTRUMENTS values (bandmusicianid, tempinstrument, 1);
            end loop;
        open consulta for
            select musicos.MUSICIAN_NAME, instru.INSTRUMENT_NAME from MUDB.BANDS_MUSICIANS bm inner join MUDB.MUSICIANS musicos on bm.MUSICIAN_ID = musicos.MUSICIAN_ID
            inner join MUDB.BANDS_MUSICIANS_INSTRUMENTS bmi on bm.BAND_MUSICIAN_ID = bmi.BAND_MUSICIAN_ID
            inner join MUDB.INSTRUMENTS instru on instru.INSTRUMENT_ID = bmi.INSTRUMENT_ID
            where bm.band_id = bandid;
        Commit;
    end createband;
    
    procedure altabanda(nombre in varchar2, fecha in date, musico in number, bandid out number)
    as
    begin
        bandid := MUDB.BANDS_SEQ.nextval;
        insert into MUDB.bands values (bandid, nombre, 1, 1, fecha, musico); 
    end altabanda;
    
end paquete3;