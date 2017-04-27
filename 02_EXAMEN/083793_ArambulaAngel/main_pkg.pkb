/* Formatted on 4/27/2017 1:59:51 PM (QP5 v5.300) */
CREATE OR REPLACE PACKAGE BODY examen02.main_pkg
AS
    /******************************************************************************
       NAME:       MAIN_PKG
       PURPOSE:

       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        4/20/2017      aarambula       1. Created this package.
    ******************************************************************************/
    /*1-Registrar a un músico ("Banjo", "Accordion"), asignarlo a la banda con el menor numero de integrantes;
       Mostrar al musico y su nueva banda.*/
    PROCEDURE test_01_banjo (out_cur_musicians OUT SYS_REFCURSOR)
    AS
        n_musician_id        INTEGER;
        n_band_id            INTEGER;
        n_instrument_a       INTEGER;
        n_instrument_b       INTEGER;
        n_band_musician_id   INTEGER;
        n_music_genre_id     INTEGER;
        n_response           INTEGER;
    BEGIN
        n_band_id := examen02.utils_pkg.get_lowest_members_band_id ();
        n_instrument_a := examen02.utils_pkg.get_instrument_id ('BANJO');
        n_instrument_b := examen02.utils_pkg.get_instrument_id ('ACCORDION');
        n_music_genre_id :=
            examen02.utils_pkg.get_music_genre_id ('Progressive Rock');
        examen02.catalog_management_pkg.insert_musician ('John Petrucci',
                                                         '12-JUL-1964',
                                                         NULL,
                                                         11,
                                                         32,
                                                         n_musician_id);

        examen02.catalog_management_pkg.insert_band_musician (
            n_band_id,
            n_musician_id,
            n_band_musician_id);

        examen02.catalog_management_pkg.insert_band_music_instrument (
            n_band_musician_id,
            n_instrument_a,
            n_music_genre_id,
            n_response);

        examen02.catalog_management_pkg.insert_band_music_instrument (
            n_band_musician_id,
            n_instrument_b,
            n_music_genre_id,
            n_response);

        examen02.utils_pkg.get_band_members_instruments (n_band_id,
                                                         out_cur_musicians);
    END test_01_banjo;

    /*2-Crear un concierto con bandas del género que más conciertos tenga registrados desde 1950;
        Ordenar a las bandas de acuerdo a su promedio de público en sus conciertos (Asumiendo que todos son sold out).
        Mostrar las bandas participantes y su orden.*/
    PROCEDURE test_02_bands_concert (out_cur_concert OUT SYS_REFCURSOR)
    IS
        n_concert_id         INTEGER;
        n_concert_venue_id   INTEGER;
        n_popular_genre_id   INTEGER;
        n_out_response       INTEGER;
        n_band_id            INTEGER;
        n_band_order         INTEGER;
        cur_bands            SYS_REFCURSOR;
    BEGIN
        n_concert_venue_id :=
            examen02.utils_pkg.get_concert_venue_id ('KE Financial');
        n_popular_genre_id :=
            examen02.utils_pkg.get_most_popular_genre_id ('01-JAN-1950');
        examen02.catalog_management_pkg.insert_concert (n_concert_venue_id,
                                                        SYSDATE,
                                                        12,
                                                        n_concert_id);
        examen02.utils_pkg.get_bands_by_genre_attendance (n_popular_genre_id,
                                                          cur_bands);

        LOOP
            FETCH cur_bands INTO n_band_id, n_band_order;

            EXIT WHEN cur_bands%NOTFOUND;
            examen02.catalog_management_pkg.insert_concert_band (
                n_concert_id,
                n_band_id,
                ROUND (DBMS_RANDOM.VALUE (0, 15)),
                n_band_order,
                n_out_response);
        END LOOP;

        examen02.utils_pkg.get_concert_bands (n_concert_id, out_cur_concert);
    END test_02_bands_concert;

    /*3-Crear una banda con musicos multi instrumentalistas (vivos)
        (6 integrantes - no repetidos,asignarle el instrumento que toco en su primera banda);
        Mostrar a los integrantes de la banda y los diferentes instrumentos que tocan.*/
    PROCEDURE test_03_bands_instrumentalists (out_cur_band OUT SYS_REFCURSOR)
    IS
        n_band_id            INTEGER;
        n_musician_id        INTEGER;
        n_instrument_id      INTEGER;
        n_music_genre_id     INTEGER := 12;
        n_band_musician_id   INTEGER;
        n_out_response       INTEGER;
        cur_musicians        SYS_REFCURSOR;
    BEGIN
        examen02.catalog_management_pkg.insert_band ('NEAL MORSE BAND',
                                                     n_music_genre_id,
                                                     1,
                                                     SYSDATE,
                                                     1500,
                                                     n_band_id);

        examen02.utils_pkg.get_multi_instrumentalists (6, cur_musicians);

        LOOP
            FETCH cur_musicians INTO n_musician_id, n_instrument_id;

            EXIT WHEN cur_musicians%NOTFOUND;
            examen02.catalog_management_pkg.insert_band_musician (
                n_band_id,
                n_musician_id,
                n_band_musician_id);

            examen02.catalog_management_pkg.insert_band_music_instrument (
                n_band_musician_id,
                n_instrument_id,
                n_music_genre_id,
                n_out_response);
        END LOOP;

        examen02.utils_pkg.get_band_members_instruments (n_band_id,
                                                         out_cur_band);
    END test_03_bands_instrumentalists;

    /*4-Crear una banda con los cinco compositores con mayor numero de composiciones registradas;
        organizar una gira de conciertos junto a la banda mas reciente de los generos: "Arena Rock", "Chicano" y "J-Pop";
        La gira debe ser por los paises: "Mexico", "Argentina" y "Germany" en venues que tengan una capacidad mayor a 180,000 espectadores.
        Cada fecha se separará por 1 dia, cuando se cambie de país la gira se reanuda hasta el siguiente domingo.
        Mostrar las fechas de la gira y sus venues con su ciudad y país.*/
    PROCEDURE test_04_world_tour (out_cur_bands OUT SYS_REFCURSOR)
    IS
        n_band_id            INTEGER;
        n_musician_id        INTEGER;
        n_concert_id         INTEGER;
        n_instrument_id      INTEGER;
        n_music_genre_id     INTEGER := 12;
        n_band_musician_id   INTEGER;
        n_out_response       INTEGER;
        n_concert_venue_id   INTEGER;
        n_city_id            INTEGER;
        n_band_order         INTEGER;
        n_venue_order        INTEGER;
        s_concert_ids        VARCHAR2 (200);
        d_concert_date       DATE := SYSDATE;
        cur_musicians        SYS_REFCURSOR;
        cur_bands            SYS_REFCURSOR;
        cur_venues           SYS_REFCURSOR;
    BEGIN
        examen02.catalog_management_pkg.insert_band ('Angra',
                                                     n_music_genre_id,
                                                     1,
                                                     SYSDATE,
                                                     1,
                                                     n_band_id);

        examen02.utils_pkg.get_top_composers (5, cur_musicians);

        LOOP
            FETCH cur_musicians INTO n_musician_id, n_instrument_id;

            EXIT WHEN cur_musicians%NOTFOUND;
            examen02.catalog_management_pkg.insert_band_musician (
                n_band_id,
                n_musician_id,
                n_band_musician_id);

            examen02.catalog_management_pkg.insert_band_music_instrument (
                n_band_musician_id,
                n_instrument_id,
                n_music_genre_id,
                n_out_response);
        END LOOP;

        examen02.utils_pkg.get_top_venues ('Mexico,Argentina,Germany',
                                           180000,
                                           cur_venues);

        LOOP
            FETCH cur_venues
                INTO n_concert_venue_id, n_city_id, n_venue_order;

            IF n_venue_order = 1 AND cur_venues%ROWCOUNT != 1
            THEN
                d_concert_date := NEXT_DAY (d_concert_date - 1, 'SUNDAY');
            END IF;

            EXIT WHEN cur_venues%NOTFOUND;
            examen02.catalog_management_pkg.insert_concert (
                n_concert_venue_id,
                d_concert_date,
                12,
                n_concert_id);

            s_concert_ids := s_concert_ids || n_concert_id || ',';
            examen02.utils_pkg.get_most_recent_bands (
                n_band_id,
                'Arena Rock,Chicano,J-Pop',
                cur_bands);

            n_band_order := 1;

            LOOP
                FETCH cur_bands INTO n_band_id, n_music_genre_id;

                EXIT WHEN cur_bands%NOTFOUND;
                examen02.catalog_management_pkg.insert_concert_band (
                    n_concert_id,
                    n_band_id,
                    ROUND (DBMS_RANDOM.VALUE (0, 15)),
                    n_band_order,
                    n_out_response);
                n_band_order := n_band_order + 1;
            END LOOP;

            d_concert_date := d_concert_date + 1;
        END LOOP;

        s_concert_ids := s_concert_ids || '0';
        examen02.utils_pkg.get_concert_bands (0,
                                              s_concert_ids,
                                              out_cur_bands);
    END test_04_world_tour;
END main_pkg;
/