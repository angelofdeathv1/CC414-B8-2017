CREATE OR REPLACE PACKAGE BODY JAVIER2.lastProblem_Pkg
IS
    TYPE number_array IS VARRAY (10000) OF NUMBER;

    TYPE string_array IS VARRAY (10000) OF VARCHAR2 (10000);

    PROCEDURE theGoodOne (salida OUT SYS_REFCURSOR)
    IS
        CURSOR miembros
        IS
            SELECT MUSICIAN_ID
              FROM (  SELECT CM.MUSICIAN_ID, COUNT (CM.MUSICIAN_ID) AS suma
                        FROM MUDB.COMPOSITIONS_MUSICIANS CM
                    GROUP BY CM.MUSICIAN_ID
                    ORDER BY suma DESC)
             WHERE ROWNUM <= 5;

        CURSOR bandas
        IS
            SELECT banditas.BAND_ID
              FROM (SELECT bandas.BAND_ID,
                           bandas.MUSIC_GENRE_ID,
                           bandas.BAND_CREATION_DATE,
                           ROW_NUMBER ()
                           OVER (PARTITION BY bandas.MUSIC_GENRE_ID
                                 ORDER BY bandas.BAND_CREATION_DATE DESC)
                               AS rc
                      FROM MUDB.BANDS  bandas
                           INNER JOIN MUDB.MUSIC_GENRES generos
                               ON bandas.MUSIC_GENRE_ID =
                                      generos.MUSIC_GENRE_ID
                     WHERE    generos.GENRE_NAME = 'Arena Rock'
                           OR generos.GENRE_NAME = 'Chicano'
                           OR generos.GENRE_NAME = 'J-Pop') banditas
             WHERE banditas.RC = 1;

        CURSOR venues_c
        IS
              SELECT venues.CONCERT_VENUE_ID,
                     ciudad.COUNTRY_NAME,
                     ciudad.CITY_NAME
                FROM MUDB.CONCERT_VENUES venues
                     INNER JOIN MUDB.CITIES ciudad
                         ON venues.CITY_ID = ciudad.CITY_ID
               WHERE     venues.CAPACITY > 180000
                     AND (   ciudad.COUNTRY_NAME = 'Mexico'
                          OR ciudad.COUNTRY_NAME = 'Argentina'
                          OR ciudad.COUNTRY_NAME = 'Germany')
            ORDER BY COUNTRY_NAME;

        arrayMiembros   number_array;
        arrayBandas     number_array;
        arrayVenues     number_array;
        arrayPais       string_array;
        arrayCiudad     string_array;
        currentBM       NUMBER;
        arrayConcert    number_array;
        banda           NUMBER;
        currentInstru   NUMBER;
        fecha           DATE;
        lastQuery       VARCHAR2 (10000);
    BEGIN
        arrayConcert := number_array ();

        OPEN miembros;

        FETCH miembros BULK COLLECT INTO arrayMiembros;

        CLOSE miembros;

        OPEN bandas;

        FETCH bandas BULK COLLECT INTO arrayBandas;

        CLOSE bandas;

        OPEN venues_c;

        FETCH venues_c BULK COLLECT INTO arrayVenues, arrayCiudad, arrayPais;

        CLOSE venues_c;

        banda := MUDB.BANDS_SEQ.NEXTVAL;
        arrayBandas.EXTEND ();
        arrayBandas (4) := banda;

        INSERT INTO MUDB.BANDS (BAND_ID,
                                   BAND_NAME,
                                   MUSIC_GENRE_ID,
                                   BAND_HOME_ID,
                                   BAND_CREATION_DATE,
                                   CONTACT_MUSICIAN_ID)
             VALUES (banda,
                     'Compositores Chidos',
                     1,
                     1,
                     TO_DATE ('1/1/2018', 'MM/DD/YYYY'),
                     arrayMiembros (1));

        FOR i IN arrayMiembros.FIRST .. arrayMiembros.LAST
        LOOP
            JAVIER2.MUSICIANPKG.createBandMusician (banda,
                                                    arrayMiembros (i),
                                                    currentBM);
            getInstrument (arrayMiembros (i), currentInstru);
            JAVIER2.MUSICIANPKG.createBMI (currentBM, currentInstru, 1);
        END LOOP;

        fecha := TO_DATE ('23/04/2017', 'DD/MM/YYYY');

        FOR i IN arrayVenues.FIRST .. arrayVenues.LAST
        LOOP
            IF i > 1
            THEN
                IF arrayVenues (i) - arrayVenues (i - 1) != 0
                THEN
                    dominguito (fecha, fecha);
                END IF;
            END IF;

            arrayConcert.EXTEND ();
            JAVIER2.MUSICIANPKG.createConcert (fecha,
                                               1,
                                               arrayVenues (i),
                                               arrayConcert (i));
            fecha := fecha + 2;
        END LOOP;

        FOR i IN arrayConcert.FIRST .. arrayConcert.LAST
        LOOP
            FOR k IN arrayBandas.FIRST .. arrayBandas.LAST
            LOOP
                INSERT INTO MUDB.CONCERTS_BANDS (CONCERT_ID,
                                                    BAND_ID,
                                                    PLAYED_SONGS,
                                                    BAND_ORDER)
                     VALUES (arrayConcert (i),
                             arrayBandas (k),
                             10,
                             k);
            END LOOP;
        END LOOP;


        FOR i IN arrayConcert.FIRST .. arrayConcert.LAST
        LOOP
            IF arrayConcert (i) IS NOT NULL
            THEN
                IF i = 1
                THEN
                    lastQuery :=
                           'SELECT conciertos.CONCERT_DATE, concertVen.VENUE_NAME, ciudad.CITY_NAME, ciudad.COUNTRY_NAME
  FROM MUDB.CONCERTS  conciertos
       INNER JOIN MUDB.CONCERT_VENUES concertVen
           ON conciertos.CONCERT_VENUE_ID = concertVen.CONCERT_VENUE_ID
       INNER JOIN MUDB.CITIES ciudad ON concertVen.CITY_ID = ciudad.CITY_ID WHERE conciertos.CONCERT_ID = '
                        || arrayConcert (i);
                ELSE
                    lastQuery :=
                           lastQuery
                        || ' OR conciertos.CONCERT_ID = '
                        || arrayConcert (i);
                END IF;
            END IF;
        END LOOP;

        OPEN salida FOR lastQuery;
    END theGoodOne;

    PROCEDURE dominguito (fecha DATE, domingo OUT DATE)
    IS
        newDate   DATE;
    BEGIN
        newDate := fecha + 2;

        SELECT TRUNC (newDate + 6, 'DAY') end_of_week INTO domingo FROM DUAL;
    END dominguito;

    PROCEDURE getInstrument (musico NUMBER, salida OUT NUMBER)
    AS
    BEGIN
        SELECT INSTRUMENT_ID
          INTO salida
          FROM MUDB.MUSICIANS  musicos
               INNER JOIN MUDB.BANDS_MUSICIANS BM
                   ON musicos.MUSICIAN_ID = BM.MUSICIAN_ID
               INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS BMI
                   ON BM.BAND_MUSICIAN_ID = BMI.BAND_MUSICIAN_ID
         WHERE musicos.MUSICIAN_ID = musico AND ROWNUM = 1;
    END getInstrument;
END lastProblem_Pkg;
/