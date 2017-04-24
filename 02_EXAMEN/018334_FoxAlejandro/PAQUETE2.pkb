create or replace package body FOXTEST2.paquete2
as

procedure getgenreid(genreid out number)
as
begin
    select identificador into genreid from (select genero.MUSIC_GENRE_ID as identificador, genero.genre_name, count(concierto.concert_id) cuenta, row_number() over (ORDER BY count(concierto.concert_id) desc) as fila from MUDB.bands banda inner join MUDB.music_genres genero on banda.MUSIC_GENRE_ID = genero.MUSIC_GENRE_ID
    inner join MUDB.CONCERTS_BANDS concertbands on banda.BAND_ID = concertbands.BAND_ID inner join MUDB.concerts concierto on concertbands.CONCERT_ID = concierto.CONCERT_ID
    inner join MUDB.CONCERT_VENUES venue on venue.CONCERT_VENUE_ID = concierto.CONCERT_VENUE_ID
    where extract(year from concierto.concert_date)  >= 1950
    group by genero.genre_name, genero.music_genre_id) where fila = 1;
end getgenreid;

procedure sortbands(genreid in number, orden out sys_refcursor)
as
begin
   open orden for
    select banda.band_id/*, avg(venue.capacity)*/ from MUDB.bands banda inner join MUDB.music_genres genero on banda.MUSIC_GENRE_ID = genero.MUSIC_GENRE_ID
    inner join MUDB.CONCERTS_BANDS concertbands on banda.BAND_ID = concertbands.BAND_ID 
    inner join MUDB.concerts concierto on concertbands.CONCERT_ID = concierto.CONCERT_ID
    inner join MUDB.CONCERT_VENUES venue on venue.CONCERT_VENUE_ID = concierto.CONCERT_VENUE_ID
    where genero.MUSIC_GENRE_ID = genreid
    group by banda.band_id
    order by avg(venue.capacity) desc;
end sortbands;

procedure createconcert(fecha in date, lineup out sys_refcursor)
is
    type number_array is varray(1000) of number;
    arraybandas number_array;
    concertid number;
    genreid number;
    ordenados sys_refcursor;
    
begin
    concertid := MUDB.CONCERTS_SEQ.nextval;
    GETGENREID(genreid);
    SORTBANDS(genreid, ordenados);
    insert into MUDB.concerts values(concertid, 50, fecha, 10);
        fetch ordenados
        bulk collect into arraybandas;
    for i in arraybandas.first .. arraybandas.last
       loop
            insert into MUDB.CONCERTS_BANDS values (concertid, arraybandas(i),3,i);
       end loop;
    open lineup for
        select concertbands.CONCERT_ID, bandas.band_name, concertbands.BAND_ORDER from MUDB.CONCERTS_BANDS concertbands 
        inner join MUDB.BANDS bandas on concertbands.BAND_ID = bandas.BAND_ID where concertbands.CONCERT_ID = concertid
        order by concertbands.band_order;
    Commit;
end createconcert;
end paquete2;
