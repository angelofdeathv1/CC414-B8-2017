/* Formatted on 4/21/2017 2:37:02 AM (QP5 v5.300) */
CREATE OR REPLACE PACKAGE BODY FOXTEST2.paquete1
AS
    PROCEDURE bandamenosintegrantes (bandid OUT NUMBER)
    AS
    BEGIN
        SELECT bandas.band_id
          INTO bandid
          FROM (  SELECT bandamusico.band_id,
                         COUNT (bandamusico.musician_id),
                         ROW_NUMBER ()
                         OVER (ORDER BY COUNT (bandamusico.musician_id) ASC)
                             AS fila
                    FROM MUDB.bands_musicians bandamusico
                GROUP BY bandamusico.band_id) bandas
         WHERE bandas.fila = 1;
    END bandamenosintegrantes;

procedure insertarmusico( nombre in varchar2, nacimiento in date, companeros out sys_refcursor)
is
    bandid number;
    musicianid number;
    bandmusicianid number;
    instrumentid number;
    cursor c1
        is
          select instrumentos.instrument_id from MUDB.instruments instrumentos where instrumentos.instrument_name like 'Accordion' or instrumentos.instrument_name like 'Banjo';  
begin
    musicianid := MUDB.musicians_seq.nextval;
    bandmusicianid := MUDB.BAND_MUSICIAN_SEQ.nextval;
    insert into MUDB.musicians values (musicianid, nombre, nacimiento, null, 100, 100);
    bandamenosintegrantes(bandid);
    insert into MUDB.BANDS_MUSICIANS values (bandmusicianid, bandid, musicianid);
    open c1;
        loop
        fetch c1 into instrumentid;
        exit when c1%notfound;
        insert into MUDB.BANDS_MUSICIANS_INSTRUMENTS values (bandmusicianid, instrumentid, 100);
        end loop;
    close c1;
    open companeros for
        select banda.band_name, musico.MUSICIAN_NAME from MUDB.musicians musico inner join MUDB.BANDS_MUSICIANS bandsmusicians on musico.MUSICIAN_ID = bandsmusicians.MUSICIAN_ID
        inner join MUDB.BANDS banda on bandsmusicians.BAND_ID = banda.BAND_ID
        where bandsmusicians.BAND_ID = bandid;
    Commit;
end insertarmusico;
END paquete1;