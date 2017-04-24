CREATE OR REPLACE PACKAGE BODY EX2GON.answers
AS
    /*
1-Registrar a un musico (Banjo, Accordion), asignarlo a la banda con el menor numero de integrantes;
*/
    PROCEDURE prob1 (out_band_info OUT SYS_REFCURSOR)
    IS
        id_mus        NUMBER;
        my_band_id    NUMBER;
        band_mus_id   NUMBER;
        accordion     NUMBER;
        banjo         NUMBER;
    BEGIN
        SELECT band_id
          INTO my_band_id
          FROM (  SELECT band_id, ROW_NUMBER () OVER (ORDER BY band_id) AS nrow
                    FROM MUDB.bands_musicians
                GROUP BY band_id
                  HAVING COUNT (musician_id) =
                             (SELECT MIN (num_musicians)
                                FROM (SELECT band_id,
                                             musician_id,
                                             COUNT (musician_id)
                                                 OVER (PARTITION BY band_id)
                                                 AS num_musicians
                                        FROM MUDB.bands_musicians)))
         WHERE nrow = 1;

        SELECT instrument_id
          INTO accordion
          FROM MUDB.INSTRUMENTS
         WHERE instrument_name = 'Accordion';

        SELECT instrument_id
          INTO banjo
          FROM MUDB.INSTRUMENTS
         WHERE instrument_name = 'Banjo';

        EX2GON.UTILS.insert_musician ('David Gonzalez',
                                      '08-JAN-1995',
                                      '08-JAN-2095',
                                      1,
                                      1,
                                      id_mus);

        EX2GON.UTILS.add_to_band (my_band_id, id_mus, band_mus_id);

        EX2GON.UTILS.add_instrument (band_mus_id, accordion, 1);

        EX2GON.UTILS.add_instrument (band_mus_id, banjo, 1);

        OPEN out_band_info FOR
              SELECT band_mus.band_id,
                     band.BAND_NAME,
                     band_mus.musician_id,
                     mus.musician_name,
                     instru.INSTRUMENT_NAME
                FROM MUDB.bands_musicians band_mus
                     INNER JOIN MUDB.musicians mus
                         ON band_mus.MUSICIAN_ID = mus.MUSICIAN_ID
                     INNER JOIN MUDB.bands band
                         ON band_mus.BAND_ID = band.BAND_ID
                     INNER JOIN
                     MUDB.bands_musicians_instruments musical_instru
                         ON band_mus.BAND_MUSICIAN_ID =
                                musical_instru.BAND_MUSICIAN_ID
                     INNER JOIN MUDB.instruments instru
                         ON instru.INSTRUMENT_ID = musical_instru.INSTRUMENT_ID
               WHERE band_mus.band_id = my_band_id
            ORDER BY mus.MUSICIAN_ID;

        COMMIT;
    END prob1;

    /*
2-Crear un concierto con bandas del g?nero que m?s conciertos tenga registrados desde 1950;
Ordenar a las bandas de acuerdo a su promedio de p?blico en sus conciertos (Asumiendo que todos son sold out).
Mostrar las bandas participantes y su orden.
*/
    PROCEDURE prob2 (out_concert OUT SYS_REFCURSOR)
    IS
        my_concert   NUMBER;
        best_bands   SYS_REFCURSOR;
        my_band      NUMBER;
        band_avg     NUMBER;
        band_order   NUMBER;
    BEGIN
        EX2GON.UTILS.insert_concert (1,
                                     '08-JAN-2018',
                                     10,
                                     my_concert);
        EX2GON.UTILS.best_bands_genre (best_bands);

        band_order := 1;

        LOOP
            FETCH best_bands INTO my_band, band_avg;

            EXIT WHEN best_bands%NOTFOUND;
            EX2GON.UTILS.insert_concert_band (my_concert,
                                              my_band,
                                              10 - (band_order - 1) * 2,
                                              band_order);
            band_order := band_order + 1;
        END LOOP;

        OPEN out_concert FOR
              SELECT concert_id,
                     band.band_id,
                     band.BAND_NAME,
                     concert_band.BAND_ORDER
                FROM MUDB.concerts_bands concert_band
                     INNER JOIN MUDB.bands band
                         ON concert_band.BAND_ID = band.BAND_ID
               WHERE concert_id = my_concert
            ORDER BY concert_band.band_order;

        COMMIT;
    END prob2;

    /*
3-Crear una banda con musicos multi instrumentalistas (vivos)
(6 integrantes - no repetidos,asignarle el instrumento que toco en su primera banda);
mostrar a los integrantes de la banda y los diferentes instrumentos que tocan.
*/
    PROCEDURE prob3 (out_band OUT SYS_REFCURSOR)
    IS
        b_id             NUMBER;
        band_mus_id      NUMBER;

        my_musicians     SYS_REFCURSOR;
        n_instrument     NUMBER;

        TYPE list_array IS VARRAY (6) OF NUMBER;

        list_musicians   list_array;
    BEGIN
        EX2GON.UTILS.multi_instru (my_musicians);

        FETCH my_musicians BULK COLLECT INTO list_musicians;

        EX2GON.UTILS.insert_band ('David & The Rockets',
                                  1,
                                  1,
                                  SYSDATE,
                                  list_musicians (1),
                                  b_id);

        FOR i IN list_musicians.FIRST .. list_musicians.LAST
        LOOP
            EX2GON.UTILS.first_instru (list_musicians (i), n_instrument);
            EX2GON.UTILS.add_to_band (b_id, list_musicians (i), band_mus_id);
            EX2GON.UTILS.add_instrument (band_mus_id, n_instrument, 1);
        END LOOP;

        OPEN out_band FOR
            SELECT band_id,
                   musi.musician_id,
                   musi.MUSICIAN_NAME,
                   instru.instrument_id,
                   instru.instrument_name,
                   musi.DATE_DIED
              FROM MUDB.bands_musicians  band_musician
                   INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS musi_instru
                       ON band_musician.BAND_MUSICIAN_ID =
                              musi_instru.BAND_MUSICIAN_ID
                   INNER JOIN MUDB.instruments instru
                       ON instru.INSTRUMENT_ID = musi_instru.INSTRUMENT_ID
                   INNER JOIN MUDB.musicians musi
                       ON musi.MUSICIAN_ID = band_musician.MUSICIAN_ID
             WHERE band_id = b_id;

        COMMIT;
    END prob3;

    /*
    4-Crear una banda con los cinco compositores con mayor numero de composiciones registradas;
    organizar una gira de conciertos junto a la banda mas reciente de los generos: "Arena Rock", "Chicano" y "J-Pop";
    La gira debe ser por los paises: "Mexico", "Argentina" y "Germany"
      en venues que tengan una capacidad mayor a 180,000 espectadores.
    Cada fecha se separar? por 1 dia, cuando se cambie de pa?s la gira se reanuda hasta el siguiente domingo.
    Mostrar las fechas de la gira y sus venues con su ciudad y pa?s.
    */
    PROCEDURE prob4 (out_venue OUT SYS_REFCURSOR)
    IS
        top_composers      SYS_REFCURSOR;
        b_id               NUMBER;
        n_composer         NUMBER;
        band_mus_id        NUMBER;
        instru_id          NUMBER;
        bands_cursor       SYS_REFCURSOR;
        temp_band          NUMBER;
        bands_array        EX2GON.UTILS.list_array;
        j                  NUMBER;

        mexico_venues      SYS_REFCURSOR;
        argentina_venues   SYS_REFCURSOR;
        germany_venues     SYS_REFCURSOR;

        curre_date         DATE;

        partial_concerts   EX2GON.UTILS.list_array;
        concerts_list      EX2GON.UTILS.list_array;
        kount              NUMBER;

        result             VARCHAR (1000);
    BEGIN
        bands_array := EX2GON.UTILS.list_array ();
        bands_array.EXTEND (4);
        EX2GON.UTILS.TOP_FIVE_COMPOSERS (top_composers);
        EX2GON.UTILS.INSERT_BAND ('David Makes me Cry',
                                  47,
                                  80,
                                  SYSDATE,
                                  90,
                                  b_id);

        LOOP
            FETCH top_composers INTO n_composer;

            EXIT WHEN top_composers%NOTFOUND;
            EX2GON.UTILS.ADD_TO_BAND (b_id, n_composer, band_mus_id);
            EX2GON.UTILS.FIRST_INSTRU (n_composer, instru_id);
            EX2GON.UTILS.ADD_INSTRUMENT (band_mus_id, instru_id, 33);
        END LOOP;

        bands_array (1) := b_id;
        EX2GON.UTILS.bands_for_concert (bands_cursor);
        j := 2;

        LOOP
            FETCH bands_cursor INTO temp_band;

            EXIT WHEN bands_cursor%NOTFOUND;
            bands_array (j) := temp_band;
            j := j + 1;
        END LOOP;

        EX2GON.UTILS.BIG_VENUES ('Mexico', mexico_venues);
        EX2GON.UTILS.BIG_VENUES ('Argentina', argentina_venues);
        EX2GON.UTILS.BIG_VENUES ('Germany', germany_venues);

        curre_date := '21-JAN-2025';
        concerts_list := EX2GON.UTILS.list_array ();
        kount := 1;

        EX2GON.UTILS.add_to_tour (mexico_venues,
                                  curre_date,
                                  bands_array,
                                  partial_concerts,
                                  curre_date);
        EX2GON.UTILS.NEXT_SUNDAY (curre_date, curre_date);

        FOR i IN partial_concerts.FIRST .. partial_concerts.LAST
        LOOP
            concerts_list.EXTEND ();
            concerts_list (kount) := partial_concerts (i);
            kount := kount + 1;
        END LOOP;

        EX2GON.UTILS.add_to_tour (argentina_venues,
                                  curre_date,
                                  bands_array,
                                  partial_concerts,
                                  curre_date);
        EX2GON.UTILS.NEXT_SUNDAY (curre_date, curre_date);

        FOR i IN partial_concerts.FIRST .. partial_concerts.LAST
        LOOP
            concerts_list.EXTEND ();
            concerts_list (kount) := partial_concerts (i);
            kount := kount + 1;
        END LOOP;

        EX2GON.UTILS.add_to_tour (germany_venues,
                                  curre_date,
                                  bands_array,
                                  partial_concerts,
                                  curre_date);

        FOR i IN partial_concerts.FIRST .. partial_concerts.LAST
        LOOP
            concerts_list.EXTEND ();
            concerts_list (kount) := partial_concerts (i);
            kount := kount + 1;
        END LOOP;

        result := '
    select concert_date, venue_name, city_name, country_name from
MUDB.concerts concert
inner join MUDB.concert_venues venue
on concert.CONCERT_VENUE_ID = venue.CONCERT_VENUE_ID
inner join MUDB.cities city
on city.CITY_ID = venue.CITY_ID
where concert_id = ';

        FOR i IN concerts_list.FIRST .. concerts_list.LAST
        LOOP
            IF concerts_list (i) IS NOT NULL
            THEN
                IF i = 1
                THEN
                    result := result || concerts_list (i);
                ELSE
                    result :=
                        result || ' or concert_id = ' || concerts_list (i);
                END IF;
            ELSE
                EXIT;
            END IF;
        END LOOP;

        result := result || ' order by concert_date';

        OPEN out_venue FOR result;

        COMMIT;
    END prob4;
END answers;
/