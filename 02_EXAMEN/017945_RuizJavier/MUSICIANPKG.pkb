CREATE OR REPLACE PACKAGE BODY JAVIER2.musicianPkg
AS
    PROCEDURE createMusician (MUSICIAN_NAME           VARCHAR2,
                              DATE_BIRTH              DATE,
                              DATE_DIED               DATE DEFAULT NULL,
                              ORIGIN_CITY_ID          NUMBER,
                              RESIDENCE_CITY_ID       NUMBER,
                              salida              OUT NUMBER)
    IS
        musicianID   NUMBER;
    BEGIN
        SELECT MUDB.MUSICIANS_SEQ.NEXTVAL INTO musicianID FROM DUAL;

        INSERT INTO MUDB.MUSICIANS (MUSICIAN_ID,
                                       MUSICIAN_NAME,
                                       DATE_BIRTH,
                                       DATE_DIED,
                                       ORIGIN_CITY_ID,
                                       RESIDENCE_CITY_ID)
             VALUES (musicianID,
                     MUSICIAN_NAME,
                     DATE_BIRTH,
                     DATE_DIED,
                     ORIGIN_CITY_ID,
                     RESIDENCE_CITY_ID);

        SELECT musicianID INTO salida FROM DUAL;
    END createMusician;

    PROCEDURE createMusician2 (salida OUT SYS_REFCURSOR)
    IS
        bandID       NUMBER;
        musicianID   NUMBER;
        bandMusID    NUMBER;
    BEGIN
        SELECT BAND_ID
          INTO bandID
          FROM (  SELECT BAND_ID, COUNT (*) AS cuenta
                    FROM MUDB.BANDS_MUSICIANS bandMusic
                GROUP BY bandMusic.BAND_ID
                ORDER BY cuenta ASC)
         WHERE ROWNUM = 1;

        createMusician ('Javier Kiet',
                        TO_DATE ('11/10/1978', 'MM/DD/YYYY'),
                        NULL,
                        77,
                        1,
                        musicianID);
        createBandMusician (bandID, musicianID, bandMusID);
        createBMI (bandMusID, 1, 1);
        createBMI (bandMusID, 35, 1);

        OPEN salida FOR
            SELECT bandas.BAND_NAME, musicos.MUSICIAN_NAME
              FROM MUDB.BANDS_MUSICIANS  bandMusicians
                   INNER JOIN MUDB.MUSICIANS musicos
                       ON bandMusicians.MUSICIAN_ID = musicos.MUSICIAN_ID
                   INNER JOIN MUDB.BANDS bandas
                       ON bandMusicians.BAND_ID = bandas.BAND_ID
             WHERE bandMusicians.BAND_ID = bandID;
    END createMusician2;

    PROCEDURE createBandMusician (BANDID           NUMBER,
                                  MUSICIANID       NUMBER,
                                  salida       OUT NUMBER)
    IS
        bandMusID   NUMBER;
    BEGIN
        SELECT MUDB.BAND_MUSICIAN_SEQ.NEXTVAL INTO bandMusID FROM DUAL;

        INSERT
          INTO MUDB.BANDS_MUSICIANS (BAND_MUSICIAN_ID, BAND_ID, MUSICIAN_ID)
        VALUES (bandMusID, BANDID, MUSICIANID);

        SELECT bandMusID INTO salida FROM DUAL;
    END createBandMusician;

    PROCEDURE createBMI (BANDMUSICIANID    NUMBER,
                         INSTRUMENTID      NUMBER,
                         MUSICGENREID      NUMBER)
    AS
    BEGIN
        INSERT
          INTO MUDB.BANDS_MUSICIANS_INSTRUMENTS (BAND_MUSICIAN_ID,
                                                    INSTRUMENT_ID,
                                                    MUSIC_GENRE_ID)
        VALUES (BANDMUSICIANID, INSTRUMENTID, MUSICGENREID);
    END createBMI;

    PROCEDURE secondOne (salida OUT SYS_REFCURSOR)
    IS
        TYPE number_array IS VARRAY (10000) OF NUMBER;

        TYPE string_array IS VARRAY (10000) OF VARCHAR2 (1000);

        TYPE integer_array IS VARRAY (10000) OF INTEGER;

        concertID   NUMBER;
        nombres     string_array;
        prome       integer_array;
        bandasIDS   number_array;

        CURSOR C1
        IS
              SELECT banditas.BAND_NAME,
                     AVG (concerV.CAPACITY) AS promedio,
                     banditas.BAND_ID
                FROM (SELECT *
                        FROM (  SELECT *
                                  FROM (  SELECT MUSIC_GENRE_ID,
                                                 SUM (cuentaBanda.cuenta) AS suma
                                            FROM (  SELECT BAND_ID,
                                                           COUNT (*) AS cuenta
                                                      FROM MUDB.CONCERTS_BANDS
                                                           concertBand
                                                           INNER JOIN
                                                           MUDB.CONCERTS
                                                           conciertos
                                                               ON concertBand.CONCERT_ID =
                                                                      conciertos.CONCERT_ID
                                                     WHERE conciertos.CONCERT_DATE >=
                                                               TO_DATE ('1/1/1950',
                                                                        'MM/DD/YYYY')
                                                  GROUP BY BAND_ID) cuentaBanda
                                                 INNER JOIN MUDB.BANDS bandas
                                                     ON bandas.BAND_ID =
                                                            cuentaBanda.BAND_ID
                                        GROUP BY MUSIC_GENRE_ID) ultima
                              ORDER BY ultima.suma DESC)
                       WHERE ROWNUM = 1) goodOne
                     INNER JOIN MUDB.BANDS banditas
                         ON goodOne.MUSIC_GENRE_ID = banditas.MUSIC_GENRE_ID
                     INNER JOIN MUDB.CONCERTS_BANDS concertBand
                         ON banditas.BAND_ID = concertBand.BAND_ID
                     INNER JOIN MUDB.CONCERTS conciertos
                         ON concertBand.CONCERT_ID = conciertos.CONCERT_ID
                     INNER JOIN MUDB.CONCERT_VENUES concerV
                         ON conciertos.CONCERT_VENUE_ID =
                                concerV.CONCERT_VENUE_ID
            GROUP BY banditas.BAND_NAME, banditas.BAND_ID
            ORDER BY promedio DESC;
    BEGIN
        OPEN salida FOR
              SELECT banditas.BAND_NAME,
                     AVG (concerV.CAPACITY) AS promedio,
                     banditas.BAND_ID
                FROM (SELECT *
                        FROM (  SELECT *
                                  FROM (  SELECT MUSIC_GENRE_ID,
                                                 SUM (cuentaBanda.cuenta) AS suma
                                            FROM (  SELECT BAND_ID,
                                                           COUNT (*) AS cuenta
                                                      FROM MUDB.CONCERTS_BANDS
                                                           concertBand
                                                           INNER JOIN
                                                           MUDB.CONCERTS
                                                           conciertos
                                                               ON concertBand.CONCERT_ID =
                                                                      conciertos.CONCERT_ID
                                                     WHERE conciertos.CONCERT_DATE >=
                                                               TO_DATE ('1/1/1950',
                                                                        'MM/DD/YYYY')
                                                  GROUP BY BAND_ID) cuentaBanda
                                                 INNER JOIN MUDB.BANDS bandas
                                                     ON bandas.BAND_ID =
                                                            cuentaBanda.BAND_ID
                                        GROUP BY MUSIC_GENRE_ID) ultima
                              ORDER BY ultima.suma DESC)
                       WHERE ROWNUM = 1) goodOne
                     INNER JOIN MUDB.BANDS banditas
                         ON goodOne.MUSIC_GENRE_ID = banditas.MUSIC_GENRE_ID
                     INNER JOIN MUDB.CONCERTS_BANDS concertBand
                         ON banditas.BAND_ID = concertBand.BAND_ID
                     INNER JOIN MUDB.CONCERTS conciertos
                         ON concertBand.CONCERT_ID = conciertos.CONCERT_ID
                     INNER JOIN MUDB.CONCERT_VENUES concerV
                         ON conciertos.CONCERT_VENUE_ID =
                                concerV.CONCERT_VENUE_ID
            GROUP BY banditas.BAND_NAME, banditas.BAND_ID
            ORDER BY promedio DESC;

        createConcert (TO_DATE ('12/12/2018', 'MM/DD/YYYY'),
                       1,
                       1,
                       concertID);

        OPEN c1;

        FETCH c1 BULK COLLECT INTO nombres, prome, bandasIDS;

        CLOSE c1;

        FOR i IN bandasIDS.FIRST .. bandasIDS.LAST
        LOOP
            INSERT INTO MUDB.CONCERTS_BANDS (CONCERT_ID,
                                                BAND_ID,
                                                PLAYED_SONGS,
                                                BAND_ORDER)
                 VALUES (concertID,
                         bandasIDS (i),
                         10,
                         i);
        END LOOP;
    END secondOne;

    PROCEDURE createConcert (CONCERTDATE              DATE,
                             CONCERTORGANIZERID       NUMBER,
                             CONCERTVENUEID           NUMBER,
                             salida               OUT NUMBER)
    IS
        concertID   NUMBER;
    BEGIN
        SELECT MUDB.CONCERTS_SEQ.NEXTVAL INTO concertID FROM DUAL;

        INSERT INTO MUDB.CONCERTS (CONCERT_ID,
                                      CONCERT_VENUE_ID,
                                      CONCERT_DATE,
                                      CONCERT_ORGANIZER_ID)
             VALUES (concertID,
                     CONCERTVENUEID,
                     CONCERTDATE,
                     CONCERTORGANIZERID);

        SELECT concertID INTO salida FROM DUAL;
    END createConcert;

    PROCEDURE createMultiBand (salida OUT SYS_REFCURSOR)
    IS
        TYPE number_array IS VARRAY (10000) OF NUMBER;

        musicos        number_array;
        musicosNR      number_array;
        instrumentos   number_array;

        banda          NUMBER;
        bandMusician   NUMBER;
        cuentita       NUMBER;

        CURSOR c1
        IS
            SELECT *
              FROM (SELECT tabla.MUSICIAN_ID, tabla.INSTRUMENT_ID
                      FROM (SELECT MIN (banditas.BAND_CREATION_DATE)
                                   OVER (PARTITION BY musiquitos.MUSICIAN_ID)
                                       AS minimo,
                                   musiquitos.MUSICIAN_ID,
                                   banditas.BAND_NAME,
                                   banditas.BAND_CREATION_DATE,
                                   banditas.BAND_ID,
                                   bMI2.INSTRUMENT_ID
                              FROM (  SELECT instru.MUSICIAN_ID
                                        FROM (SELECT *
                                                FROM (  SELECT musicos.MUSICIAN_ID,
                                                               COUNT (
                                                                   musicos.MUSICIAN_ID)
                                                                   cuenta
                                                          FROM MUDB.MUSICIANS
                                                               musicos
                                                               INNER JOIN
                                                               MUDB.BANDS_MUSICIANS
                                                               bM
                                                                   ON musicos.MUSICIAN_ID =
                                                                          bM.MUSICIAN_ID
                                                               INNER JOIN
                                                               MUDB.BANDS_MUSICIANS_INSTRUMENTS
                                                               bMI
                                                                   ON bM.BAND_MUSICIAN_ID =
                                                                          bMI.BAND_MUSICIAN_ID
                                                      GROUP BY musicos.MUSICIAN_ID)
                                               WHERE cuenta > 1) instru
                                       WHERE ROWNUM <= 6
                                    ORDER BY cuenta DESC) musiquitos
                                   INNER JOIN MUDB.BANDS_MUSICIANS bM2
                                       ON musiquitos.MUSICIAN_ID =
                                              bM2.MUSICIAN_ID
                                   INNER JOIN MUDB.BANDS banditas
                                       ON bM2.BAND_ID = banditas.BAND_ID
                                   INNER JOIN
                                   MUDB.BANDS_MUSICIANS_INSTRUMENTS bMI2
                                       ON bM2.BAND_MUSICIAN_ID =
                                              bMI2.BAND_MUSICIAN_ID) tabla
                           INNER JOIN MUDB.MUSICIANS deadmusic
                               ON tabla.MUSICIAN_ID = deadmusic.MUSICIAN_ID
                     WHERE     tabla.BAND_CREATION_DATE = minimo
                           AND deadmusic.DATE_DIED IS NULL) megaTabla;
    BEGIN
        OPEN salida FOR
            SELECT megaTabla.MUSICIAN_ID,
                   megaTabla.INSTRUMENT_ID,
                   musiquillos.MUSICIAN_NAME,
                   instrumentillos.INSTRUMENT_NAME
              FROM (SELECT tabla.MUSICIAN_ID, tabla.INSTRUMENT_ID
                      FROM (SELECT MIN (banditas.BAND_CREATION_DATE)
                                   OVER (PARTITION BY musiquitos.MUSICIAN_ID)
                                       AS minimo,
                                   musiquitos.MUSICIAN_ID,
                                   banditas.BAND_NAME,
                                   banditas.BAND_CREATION_DATE,
                                   banditas.BAND_ID,
                                   bMI2.INSTRUMENT_ID
                              FROM (  SELECT instru.MUSICIAN_ID
                                        FROM (SELECT *
                                                FROM (  SELECT musicos.MUSICIAN_ID,
                                                               COUNT (
                                                                   musicos.MUSICIAN_ID)
                                                                   cuenta
                                                          FROM MUDB.MUSICIANS
                                                               musicos
                                                               INNER JOIN
                                                               MUDB.BANDS_MUSICIANS
                                                               bM
                                                                   ON musicos.MUSICIAN_ID =
                                                                          bM.MUSICIAN_ID
                                                               INNER JOIN
                                                               MUDB.BANDS_MUSICIANS_INSTRUMENTS
                                                               bMI
                                                                   ON bM.BAND_MUSICIAN_ID =
                                                                          bMI.BAND_MUSICIAN_ID
                                                      GROUP BY musicos.MUSICIAN_ID)
                                               WHERE cuenta > 1) instru
                                       WHERE ROWNUM <= 6
                                    ORDER BY cuenta DESC) musiquitos
                                   INNER JOIN MUDB.BANDS_MUSICIANS bM2
                                       ON musiquitos.MUSICIAN_ID =
                                              bM2.MUSICIAN_ID
                                   INNER JOIN MUDB.BANDS banditas
                                       ON bM2.BAND_ID = banditas.BAND_ID
                                   INNER JOIN
                                   MUDB.BANDS_MUSICIANS_INSTRUMENTS bMI2
                                       ON bM2.BAND_MUSICIAN_ID =
                                              bMI2.BAND_MUSICIAN_ID) tabla
                     WHERE tabla.BAND_CREATION_DATE = minimo) megaTabla
                   INNER JOIN MUDB.MUSICIANS musiquillos
                       ON megaTabla.MUSICIAN_ID = musiquillos.MUSICIAN_ID
                   INNER JOIN MUDB.INSTRUMENTS instrumentillos
                       ON megaTabla.INSTRUMENT_ID =
                              instrumentillos.INSTRUMENT_ID WHERE musiquillos.DATE_DIED IS NULL;



        SELECT MUDB.BANDS_SEQ.NEXTVAL INTO banda FROM DUAL;

        OPEN c1;

        FETCH c1 BULK COLLECT INTO musicos, instrumentos;

        CLOSE c1;

        INSERT INTO MUDB.BANDS (BAND_ID,
                                   BAND_NAME,
                                   MUSIC_GENRE_ID,
                                   BAND_HOME_ID,
                                   BAND_CREATION_DATE,
                                   CONTACT_MUSICIAN_ID)
             VALUES (banda,
                     'Chidos',
                     1,
                     1,
                     TO_DATE ('1/1/2018', 'MM/DD/YYYY'),
                     musicos (1));

        musicosNR := number_array ();
        cuentita := 1;

        FOR l IN musicos.FIRST .. musicos.LAST
        LOOP
            IF l > 1
            THEN
                IF musicos (l) - musicos (l - 1) != 0
                THEN
                    musicosNR.EXTEND ();
                    musicosNR (cuentita) := musicos (l);
                    cuentita := cuentita + 1;
                END IF;
            END IF;
        END LOOP;

        FOR i IN musicosNR.FIRST .. musicosNR.LAST
        LOOP
            createBandMusician (banda, musicosNR (i), bandMusician);

            FOR k IN musicos.FIRST .. musicos.LAST
            LOOP
                IF musicos (k) = musicosNR (i)
                THEN
                    createBMI (bandMusician, instrumentos (k), 1);
                END IF;
            END LOOP;
        END LOOP;
    END createMultiBand;
END musicianPkg;
/