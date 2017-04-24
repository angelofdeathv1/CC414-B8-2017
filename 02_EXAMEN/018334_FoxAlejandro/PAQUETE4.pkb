create or replace package body FOXTEST2.paquete4
is
    
    procedure getvenues(pais in varchar2, venues out sys_refcursor)
        as
        begin
            open venues for
                select venues.CONCERT_VENUE_ID
                from MUDB.concert_venues venues inner join MUDB.cities ciudad on ciudad.CITY_ID = venues.CITY_ID where venues.capacity >= 180000
                and ciudad.country_name like pais;
        end getvenues;
    
    procedure getbands (bandas out sys_refcursor)
    as
    begin
        open bandas for
            select band_id from (select bandas.BAND_id, genero.genre_name, bandas.BAND_CREATION_DATE, row_number() over 
            (partition by genero.genre_name order by bandas.BAND_CREATION_DATE desc) as fila from MUDB.bands bandas 
            inner join MUDB.MUSIC_GENRES genero on bandas.MUSIC_GENRE_ID = genero.MUSIC_GENRE_ID 
            where genero.GENRE_NAME like 'Arena Rock' or genero.genre_name like 'Chicano' or genero.genre_name like 'J-Pop') where fila = 1;
    end getbands;
    
    procedure getmembers(miembros out sys_refcursor)
    as
    begin
        open miembros for
            select musician_id from (select compo.MUSICIAN_ID, count(compo.composition_id) as cuenta, row_number() over (order by count(compo.composition_id) desc) as fila 
            from MUDB.COMPOSITIONS_MUSICIANS compo group by compo.MUSICIAN_ID) where fila <=5;
    end getmembers;
    
    procedure getinstrument (miembro in number, instrumento out number)
    as
    begin
        select instrument_id into instrumento from (select bm.MUSICIAN_ID, bmi.INSTRUMENT_ID, 
        row_number () over (order by bmi.instrument_id) as fila from MUDB.BANDS_MUSICIANS bm 
        inner join MUDB.BANDS_MUSICIANS_INSTRUMENTS bmi on bm.BAND_MUSICIAN_ID = bmi.BAND_MUSICIAN_ID 
        where bm.MUSICIAN_ID = miembro) where fila = 1;
    end getinstrument;
    
    procedure createband (nombre in varchar2, fecha in date, bandid out number)
    is
        arraymiembros array_number;
        miembros sys_refcursor;
        bandmusicianid number;
        instrumento number;
    begin
        bandid := MUDB.BANDS_SEQ.nextval; 
        getmembers(miembros);
        fetch miembros
            bulk collect into arraymiembros;
        insert into MUDB.BANDS values (bandid, nombre, 1, 1, fecha, arraymiembros(1));
        for i in arraymiembros.first .. arraymiembros.last
        loop
            bandmusicianid := MUDB.BAND_MUSICIAN_SEQ.nextval;
            getinstrument(arraymiembros(i), instrumento);
            insert into MUDB.BANDS_MUSICIANS values (bandmusicianid, bandid, arraymiembros(i));
            insert into MUDB.BANDS_MUSICIANS_INSTRUMENTS values (bandmusicianid, instrumento, 1);
        end loop;
    end createband;
    
    procedure getnextsunday(fecha in date, sunday out date)
    is
        dow number;
    begin
            select to_char(fecha,'D') into dow from dual;
            sunday := fecha + (8-dow);
    end;
    
    procedure createconcert(fecha in date, venue in number, concertid out number)
    as
    begin
        concertid := MUDB.CONCERTS_SEQ.nextval;
        insert into MUDB.CONCERTS values (concertid, venue, fecha, 1);
    end createconcert;
    
    procedure createtour(lineup out sys_refcursor)
    is
        newband number;
        bandas sys_refcursor;
        arraybandas array_number;
        arrayconcierto1 array_number;
        arrayconcierto2 array_number;
        arrayconcierto3 array_number;
        fecha date;
        consulta varchar2(4000);
    begin
        createband('Test2', '28/AUG/1995', newband);
        getbands(bandas);
        fetch bandas
            bulk collect into arraybandas;
        arraybandas.extend();
        arraybandas(arraybandas.last) := newband;
        createtourpais('Mexico', arraybandas, '21/APR/2017', fecha, arrayconcierto1);
        getnextsunday(fecha,fecha);
        createtourpais('Argentina', arraybandas, fecha, fecha, arrayconcierto2);
        getnextsunday(fecha,fecha);
        createtourpais('Germany', arraybandas, fecha, fecha, arrayconcierto3);
        consulta := 'select venues.VENUE_NAME, ciudad.CITY_NAME, ciudad.COUNTRY_NAME ,concierto.CONCERT_DATE from MUDB.CONCERTS concierto inner join MUDB.CONCERT_VENUES venues on concierto.CONCERT_VENUE_ID = venues.CONCERT_VENUE_ID
                     inner join MUDB.CITIES ciudad on venues.CITY_ID = ciudad.CITY_ID';
        for i in arrayconcierto1.first .. arrayconcierto1.last
        loop
            if arrayconcierto1(i) is not null then
                if i = 1 then
                consulta := consulta || ' where concierto.concert_id =' || arrayconcierto1(i);
                else
                    consulta := consulta || ' or concierto.concert_id =' || arrayconcierto1(i);
                end if;
            else
                exit;
            end if;
        end loop;
        for i in arrayconcierto2.first .. arrayconcierto2.last
        loop
            if arrayconcierto2(i) is not null then
                    consulta := consulta || ' or concierto.concert_id =' || arrayconcierto2(i);
            else
                exit;
            end if;
        end loop;
        for i in arrayconcierto3.first .. arrayconcierto3.last
        loop
            if arrayconcierto3(i) is not null then
                    consulta := consulta || ' or concierto.concert_id =' || arrayconcierto3(i);
            else
                exit;
            end if;
        end loop;
        consulta := consulta || ' order by concierto.concert_date';
        dbms_output.put_line(consulta);
        
        open lineup for consulta;
        Commit;
    end createtour;
    
    procedure createtourpais(pais in varchar2, bandas in array_number, fecha in date, fechainterna out date, arrayconcierto out array_number)
    is
        arrayvenues array_number;
        venues sys_refcursor;
        concertid number;
    begin
        arrayvenues := array_number();
        arrayconcierto := array_number();
        arrayconcierto.extend(100);
        fechainterna := fecha;
        getvenues(pais, venues);
        fetch venues
            bulk collect into arrayvenues;
        for i in arrayvenues.first .. arrayvenues.last
        loop
            createconcert(fechainterna, arrayvenues(i), concertid);
            arrayconcierto(i) := concertid;
            for k in bandas.first .. bandas.last
            loop
                insert into MUDB.CONCERTS_BANDS values (concertid, bandas(k), 10, k);
            end loop;
            fechainterna := fechainterna + 2;
        end loop;
        
    end createtourpais;
end paquete4;