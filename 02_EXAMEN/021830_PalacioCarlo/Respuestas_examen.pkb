/* Formatted on 21/04/2017 10:26:25 p.m. (QP5 v5.300) */
CREATE OR REPLACE PACKAGE BODY EXAMEN_02_CARLO.Respuestas_Examen2
AS
    PROCEDURE alta_musician (n_music       IN VARCHAR,
                             fecha_nac        DATE,
                             fecha_death      DATE,
                             orig_city     IN NUMBER,
                             resi_city        NUMBER)
    AS
    BEGIN
        INSERT INTO MUDB.musicians (MUSICIAN_ID,
                                               MUSICIAN_NAME,
                                               DATE_BIRTH,
                                               DATE_DIED,
                                               ORIGIN_CITY_ID,
                                               RESIDENCE_CITY_ID)
             VALUES (MUDB.MUSICIANS_SEQ.NEXTVAL,
                     n_music,
                     fecha_nac,
                     fecha_death,
                     orig_city,
                     resi_city);

        COMMIT;
    END alta_musician;

    PROCEDURE alta_musician_band (i_id_musician   IN     NUMBER,
                                  i_id_band       IN     NUMBER,
                                  o_mus_band         OUT NUMBER)
    AS
    BEGIN
        INSERT
          INTO MUDB.bands_musicians (band_musician_id,
                                                band_id,
                                                musician_id)
            VALUES (
                       MUDB.band_musician_seq.NEXTVAL,
                       i_id_band,
                       i_id_musician);

        --            sOrdno := kek.order1.CURRVAL;
        o_mus_band := MUDB.BAND_MUSICIAN_SEQ.CURRVAL;
        COMMIT;
    END alta_musician_band;

    PROCEDURE ALTA_MUSICIAN_INSTRUMENT (i_id_musician_band   IN NUMBER,
                                        i_id_instrument      IN NUMBER,
                                        i_id_genre           IN NUMBER)
    AS
    BEGIN
        INSERT
          INTO MUDB.BANDS_MUSICIANS_INSTRUMENTS (band_musician_id,
                                                            instrument_id,
                                                            music_genre_id)
        VALUES (i_id_musician_band, i_id_instrument, i_id_genre);

        COMMIT;
    END alta_musician_instrument;

    PROCEDURE RECENT_REDNECK (i_id_musician   IN     NUMBER,
                              nu_band            OUT SYS_REFCURSOR)
    IS
        curr_mus_band   NUMBER; -- es el current value de la secuencia 
        banda_inicial   NUMBER; -- banda a la que ingresara
        banjo           NUMBER; -- numero con el id del banjo
        accordion       NUMBER; -- numero con el id del acordeon
        country         NUMBER; -- numero con el id del genero country
    BEGIN
        SELECT band_id
          INTO banda_inicial
          FROM (  SELECT band_id, COUNT (band_musician_id)
                    FROM MUDB.bands_musicians bm
                GROUP BY band_id
                ORDER BY COUNT (band_musician_id) ASC)
         WHERE ROWNUM = 1;

        SELECT instrument_id
          INTO banjo
          FROM MUDB.instruments
         WHERE instrument_name = 'Banjo';

        SELECT instrument_id
          INTO accordion
          FROM MUDB.instruments
         WHERE instrument_name = 'Accordion';

        SELECT music_genre_id
          INTO country 
          FROM MUDB.music_genres
         WHERE genre_name = 'Country';

        EXAMEN_02_CARLO.respuestas_examen2.alta_musician_band (i_id_musician, -- dar de alta al musico en su nueva banda
                                                               banda_inicial,
                                                               curr_mus_band);

        INSERT
          INTO MUDB.BANDS_MUSICIANS_instruments (band_musician_id, -- dar de alta al musico con su banjo
                                                            instrument_id,
                                                            music_genre_id)
        VALUES (curr_mus_band, banjo, country);

        INSERT
          INTO MUDB.BANDS_MUSICIANS_instruments (band_musician_id, -- dar de alta al musico con su acordeon
                                                            instrument_id,
                                                            music_genre_id)
        VALUES (curr_mus_band, accordion, country);

        OPEN nu_band FOR --sys_refcursor de salida 
            SELECT musician_name, band_name, instrument_name
              FROM MUDB.bands_musicians  bm
                   INNER JOIN MUDB.musicians ms
                       ON ms.MUSICIAN_ID = bm.MUSICIAN_ID
                   INNER JOIN MUDB.bands bnds
                       ON bm.BAND_ID = bnds.BAND_ID
                   INNER JOIN MUDB.bands_musicians_instruments bmi
                       ON bmi.BAND_MUSICIAN_ID = bm.BAND_MUSICIAN_ID
                   INNER JOIN MUDB.INSTRUMENTS ins
                       ON ins.instrument_id = bmi.INSTRUMENT_ID
             WHERE bmi.band_musician_id = curr_mus_band;


        COMMIT;
    END recent_redneck;

    PROCEDURE alta_concert (i_con_venue   IN     NUMBER, --metodo para dar de alta el concierto
                            i_date        IN     DATE,
                            i_org         IN     NUMBER,
                            o_conc           OUT NUMBER)
    AS
    BEGIN
        INSERT INTO MUDB.concerts (concert_id,
                                              concert_venue_id,
                                              concert_date,
                                              concert_organizer_id)
             VALUES (MUDB.concerts_seq.NEXTVAL,
                     i_con_venue,
                     i_date,
                     i_org);

        o_conc := MUDB.concerts_seq.CURRVAL;
    END alta_concert;

    PROCEDURE alta_band_concert (i_conc    IN NUMBER, --dar de alta una banda del concierto
                                 i_band    IN NUMBER,
                                 i_num     IN NUMBER,
                                 i_order   IN NUMBER)
    AS
    BEGIN
        INSERT INTO MUDB.CONCERTS_BANDs (concert_id,
                                                    band_id,
                                                    played_songs,
                                                    band_order)
             VALUES (i_conc,
                     i_band,
                     i_num,
                     i_order);
    END alta_band_concert;

    PROCEDURE woodstock (i_con_venue IN NUMBER, respuesta OUT SYS_REFCURSOR) -- solucion al 3er procedimiento
    IS
        bandas_eternas   SYS_REFCURSOR; --las 5 bandas que mas han tocado desde 1950
        conc_num         NUMBER; -- numero del concierto para agregar a las bandas
        orden            NUMBER; --
        banda            NUMBER;
    BEGIN
        OPEN bandas_eternas FOR
            SELECT ROWNUM, a.*
              FROM (  SELECT band_id
                        FROM (SELECT conc.concert_id,
                                     bnd.band_id,
                                     concert_date,
                                     m_g.music_genre_id,
                                     capacity
                                FROM MUDB.concerts_bands conc_b
                                     INNER JOIN MUDB.concerts conc
                                         ON conc.CONCERT_ID = conc_b.CONCERT_ID
                                     INNER JOIN MUDB.bands bnd
                                         ON bnd.BAND_ID = conc_b.BAND_ID
                                     INNER JOIN
                                     MUDB.music_genres m_g
                                         ON m_g.MUSIC_GENRE_ID =
                                                bnd.MUSIC_GENRE_ID
                                     INNER JOIN
                                     MUDB.CONCERT_VENUES conc_v
                                         ON conc_v.CONCERT_VENUE_ID =
                                                conc.CONCERT_VENUE_ID
                               WHERE     EXTRACT (YEAR FROM concert_date) >
                                             1950
                                     AND m_g.music_genre_id = 2)
                    GROUP BY band_id
                    ORDER BY AVG (capacity) DESC) a;



        EXAMEN_02_CARLO.respuestas_examen2.alta_concert (90,
                                                         CURRENT_DATE,
                                                         9,
                                                         conc_num);

        LOOP
            FETCH bandas_eternas INTO orden, banda;

            EXIT WHEN bandas_eternas%NOTFOUND;
            EXAMEN_02_CARLO.respuestas_examen2.alta_band_concert (conc_num,
                                                                  banda,
                                                                  '20',
                                                                  orden);
        END LOOP;

        OPEN respuesta FOR
            SELECT band_name, played_songs, band_order
              FROM MUDB.concerts_bands  conc_b
                   INNER JOIN MUDB.bands ban
                       ON conc_b.BAND_ID = ban.BAND_ID
             WHERE concert_id = conc_num;

        COMMIT;
    END woodstock;

    PROCEDURE alta_banda (i_b_name    IN     VARCHAR,
                          i_m_genre   IN     NUMBER,
                          i_home      IN     NUMBER,
                          i_contact   IN     NUMBER,
                          curr_ban       OUT NUMBER)
    AS
    BEGIN
        INSERT INTO MUDB.BANDs (band_id,
                                           band_name,
                                           music_genre_id,
                                           band_home_id,
                                           band_creation_date,
                                           contact_musician_id)
             VALUES (MUDB.bands_seq.NEXTVAL,
                     i_b_name,
                     i_m_genre,
                     i_home,
                     CURRENT_DATE,
                     i_contact);

        curr_ban := MUDB.bands_seq.CURRVAL;
        COMMIT;
    END alta_banda;

    FUNCTION first_instrument (i_musician IN NUMBER)
        RETURN NUMBER
    IS
        f_inst   NUMBER;
    BEGIN
        SELECT MIN (ins.instrument_id)
          INTO f_inst
          FROM MUDB.instruments  ins
               INNER JOIN MUDB.bands_musicians_instruments bmi
                   ON ins.INSTRUMENT_ID = bmi.INSTRUMENT_ID
               INNER JOIN MUDB.bands_musicians bm
                   ON bm.BAND_MUSICIAN_ID = bmi.BAND_MUSICIAN_ID
         WHERE musician_id = i_musician;

        RETURN f_inst;
    END first_instrument;

    PROCEDURE super_band (b_name IN VARCHAR, respuesta OUT SYS_REFCURSOR)
    IS
        musics      SYS_REFCURSOR;
        member_m    NUMBER;
        curr_band   NUMBER;
        f_instru    NUMBER;
        ko          NUMBER;
    BEGIN
        OPEN musics FOR
            SELECT musician_id,
                   EXAMEN_02_CARLO.respuestas_examen2.FIRST_INSTRUMENT (
                       musician_id)
              FROM (  SELECT musician_id,
                             RANK () OVER (ORDER BY MUSICIAN_ID ASC) AS "Lugar"
                        FROM (SELECT mus.musician_id, band_ins.BAND_MUSICIAN_ID
                                FROM MUDB.BANDS_MUSICIANS band_m
                                     INNER JOIN
                                     MUDB.bands_musicians_instruments
                                     band_ins
                                         ON band_m.BAND_MUSICIAN_ID =
                                                band_ins.BAND_MUSICIAN_ID
                                     INNER JOIN MUDB.musicians mus
                                         ON mus.MUSICIAN_ID =
                                                band_m.MUSICIAN_ID
                               WHERE date_died IS NULL) -- sigue vivo
                    GROUP BY musician_id
                      HAVING COUNT (BAND_MUSICIAN_ID) > 1) --mulinstrumentalista
             WHERE "Lugar" < 7; --los 6 integrantes


        EXAMEN_02_CARLO.respuestas_examen2.alta_banda (b_name, -- dar de alta a la super banda
                                                       20,
                                                       4,
                                                       5,
                                                       curr_band);

        LOOP
            FETCH musics INTO member_m, f_instru;  -- registrar al musico en su banda con su instrumento en la nueva banda

            EXAMEN_02_CARLO.respuestas_examen2.alta_musician_band (member_m,
                                                                   curr_band,
                                                                   ko);
            EXAMEN_02_CARLO.respuestas_examen2.alta_musician_instrument (
                ko,
                f_instru,
                20);
            EXIT WHEN musics%NOTFOUND;
        END LOOP;

        OPEN respuesta FOR
            SELECT MUSICIAN_NAME, band_name, instrument_name
              FROM MUDB.MUSICIANS  mus
                   INNER JOIN MUDB.bands_musicians bm
                       ON mus.MUSICIAN_ID = bm.MUSICIAN_ID
                   INNER JOIN MUDB.bands ban
                       ON ban.BAND_ID = bm.BAND_ID
                   INNER JOIN MUDB.bands_musicians_instruments bmi
                       ON bmi.BAND_MUSICIAN_ID = bm.BAND_MUSICIAN_ID
                   INNER JOIN MUDB.instruments instru
                       ON instru.INSTRUMENT_ID = bmi.INSTRUMENT_ID
             WHERE ban.band_id = curr_band;
          commit;
    END super_band;

    PROCEDURE virtuoso (b_name IN VARCHAR, respuesta OUT SYS_REFCURSOR)
    IS
        conc_ger        SYS_REFCURSOR;
        conc_mex        SYS_REFCURSOR;
        conc_arg        SYS_REFCURSOR;
        los_virtuosos   SYS_REFCURSOR;

        chicanos        SYS_REFCURSOR;
        arena_rock      SYS_REFCURSOR;
        j_pop           SYS_REFCURSOR;
        un_virt         NUMBER;
        curr_concert    NUMBER;
        curr_ven        NUMBER;
        nu_band_id      NUMBER;
        hoy             DATE := CURRENT_DATE;
        tmp             NUMBER;
    BEGIN
        --    getting virtuoso artists
        OPEN los_virtuosos FOR
            SELECT musician_id
              FROM (  SELECT musician_id, COUNT (composition_id)
                        FROM MUDB.compositions_musicians
                    GROUP BY musician_id
                    ORDER BY COUNT (composition_id) DESC)
             WHERE ROWNUM <= 5;

        -- getting venues
        OPEN conc_ger FOR
            SELECT conc_v.concert_venue_id
              FROM MUDB.concert_venues  conc_v
                   INNER JOIN MUDB.cities cty
                       ON conc_v.CITY_ID = cty.CITY_ID
             WHERE conc_v.capacity > 180000 AND country_name = 'Germany';

        OPEN conc_mex FOR
            SELECT conc_v.concert_venue_id
              FROM MUDB.concert_venues  conc_v
                   INNER JOIN MUDB.cities cty
                       ON conc_v.CITY_ID = cty.CITY_ID
             WHERE conc_v.capacity > 180000 AND country_name = 'Mexico';

        OPEN conc_arg FOR
            SELECT conc_v.concert_venue_id
              FROM MUDB.concert_venues  conc_v
                   INNER JOIN MUDB.cities cty
                       ON conc_v.CITY_ID = cty.CITY_ID
             WHERE conc_v.capacity > 180000 AND country_name = 'Argentina';

        --             youngest bands of genres

        OPEN chicanos FOR
            SELECT band_id
              FROM (  SELECT ban.band_id, band_creation_date
                        FROM MUDB.bands ban
                             INNER JOIN MUDB.music_genres gnr
                                 ON ban.MUSIC_GENRE_ID = gnr.MUSIC_GENRE_ID
                       WHERE gnr.genre_name = 'Chicano'
                    ORDER BY band_creation_date ASC)
             WHERE ROWNUM = 1;

        OPEN arena_rock FOR
            SELECT band_id
              FROM (  SELECT ban.band_id, band_creation_date
                        FROM MUDB.bands ban
                             INNER JOIN MUDB.music_genres gnr
                                 ON ban.MUSIC_GENRE_ID = gnr.MUSIC_GENRE_ID
                       WHERE gnr.genre_name = 'Arena Rock'
                    ORDER BY band_creation_date ASC)
             WHERE ROWNUM = 1;

        OPEN j_pop FOR
            SELECT band_id
              FROM (  SELECT ban.band_id, band_creation_date
                        FROM MUDB.bands ban
                             INNER JOIN MUDB.music_genres gnr
                                 ON ban.MUSIC_GENRE_ID = gnr.MUSIC_GENRE_ID
                       WHERE gnr.genre_name = 'J-Pop'
                    ORDER BY band_creation_date ASC)
             WHERE ROWNUM = 1;

        --        CREATE BAND
        EXAMEN_02_CARLO.respuestas_examen2.alta_banda (b_name,
                                                       30,
                                                       14,
                                                       50,
                                                       nu_band_id);

        LOOP
            FETCH los_virtuosos INTO un_virt;

            EXIT WHEN los_virtuosos%NOTFOUND;
            EXAMEN_02_CARLO.respuestas_examen2.ALTA_MUSICIAN_BAND (
                un_virt,
                nu_band_id,
                tmp);
        END LOOP;

        LOOP
            FETCH conc_ger INTO curr_ven;

            EXIT WHEN conc_ger%NOTFOUND;
            EXAMEN_02_CARLO.respuestas_examen2.ALTA_CONCERT (curr_ven,
                                                             HOY,
                                                             1,
                                                             curr_concert);
            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
                curr_concert,
                nu_band_id,
                20,
                1);
--            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
--                curr_concert,
--                chicanos,
--                20,
--                2);
--            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
--                curr_concert,
--                j_pop,
--                20,
--                3);
--            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
--                curr_concert,
--                arena_rock,
--                20,
--                4);
            HOY := HOY + 1;
        END LOOP;

        HOY := NEXT_DAY (hoy, 'Sunday');

        LOOP
            FETCH conc_mex INTO curr_ven;

            EXIT WHEN conc_mex%NOTFOUND;
            EXAMEN_02_CARLO.respuestas_examen2.ALTA_CONCERT (curr_ven,
                                                             HOY,
                                                             1,
                                                             curr_concert);
            HOY := HOY + 1;
--            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
--                curr_concert,
--                nu_band_id,
--                20,
--                1);
--            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
--                curr_concert,
--                chicanos,
--                20,
--                2);
--            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
--                curr_concert,
--                j_pop,
--                20,
--                3);
--            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
--                curr_concert,
--                arena_rock,
--                20,
--                4);
        END LOOP;

        HOY := NEXT_DAY (hoy, 'Sunday');

        LOOP
            FETCH conc_arg INTO curr_ven;

            EXIT WHEN conc_arg%NOTFOUND;
            EXAMEN_02_CARLO.respuestas_examen2.ALTA_CONCERT (curr_ven,
                                                             HOY,
                                                             1,
                                                             curr_concert);
            HOY := HOY + 1;
            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
                curr_concert,
                nu_band_id,
                20,
                1);
--            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
--                curr_concert,
--                chicanos,
--                20,
--                2);
--            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
--                curr_concert,
--                j_pop,
--                20,
--                3);
--            EXAMEN_02_CARLO.respuestas_examen2.ALTA_BAND_CONCERT (
--                curr_concert,
--                arena_rock,
--                20,
--                4);
        END LOOP;

        OPEN respuesta FOR
            SELECT Country_name,
                   city_name,
                   band_name,
                   concert_date
              FROM MUDB.concerts  conc
                   INNER JOIN MUDB.concert_venues conc_v
                       ON conc.CONCERT_VENUE_ID = conc_v.CONCERT_VENUE_ID
                   INNER JOIN MUDB.CITIES cty
                       ON conc_v.city_id = cty.city_id
                   INNER JOIN MUDB.CONCERTS_BANDS conc_b
                       ON conc_b.CONCERT_ID = conc.CONCERT_ID
                   INNER JOIN MUDB.BANDS ban
                       ON ban.BAND_ID = conc_b.BAND_ID
             WHERE ROWNUM < 40;
     commit;
    END virtuoso;
END Respuestas_Examen2;
/