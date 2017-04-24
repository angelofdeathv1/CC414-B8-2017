/* Formatted on 21/04/2017 09:30:07 p. m. (QP5 v5.300) */
CREATE OR REPLACE PACKAGE BODY EX2RGG.PROCEDURES_EXAMEN02
AS
    PROCEDURE BANDA_MIN (B_ID OUT INTEGER)
    AS
    BEGIN
        SELECT B_M.BAND_ID
          INTO B_ID
          FROM (SELECT BAND_MUSICIANS.BAND_ID,
                       MIN (BAND_MUSICIANS.NUM) OVER (),
                       ROWNUM
                  FROM ((  SELECT BAND_ID, COUNT (MUSICIAN_ID) NUM
                             FROM MUDB.BANDS_MUSICIANS
                            WHERE ROWNUM = 1
                         GROUP BY BAND_ID)) BAND_MUSICIANS) B_M;
    END BANDA_MIN;

    PROCEDURE NEW_INTEGRANT_BAND (B_ID IN INTEGER, MUSICOS OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN MUSICOS FOR
            SELECT MUSICO.MUSICIAN_NAME
              FROM MUDB.BANDS_MUSICIANS  BANDA_M
                   INNER JOIN MUDB.MUSICIANS MUSICO
                       ON MUSICO.MUSICIAN_ID = BANDA_M.MUSICIAN_ID
             WHERE BANDA_M.BAND_ID = B_ID;
    END;

    PROCEDURE POPULAR1950 (G_ID OUT INTEGER)
    AS
    BEGIN
        SELECT TABLACHIDA.GENERO
          INTO G_ID
          FROM (  SELECT GNC.GENERO,
                         MAX (GNC.NUM_CON)                            NUMCON,
                         ROW_NUMBER () OVER (ORDER BY GNC.NUM_CON DESC) COLUMNA
                    FROM (SELECT BAND.MUSIC_GENRE_ID GENERO,
                                 COUNT (CONCIERTOS.CONCERT_ID)
                                     OVER (PARTITION BY BAND.MUSIC_GENRE_ID)
                                     NUM_CON
                            FROM MUDB.CONCERTS_BANDS CB
                                 INNER JOIN MUDB.BANDS BAND
                                     ON BAND.BAND_ID = CB.BAND_ID
                                 INNER JOIN MUDB.CONCERTS CONCIERTOS
                                     ON CONCIERTOS.CONCERT_ID = CB.CONCERT_ID
                           WHERE CONCIERTOS.CONCERT_DATE >= '1/1/1950') GNC
                GROUP BY GNC.GENERO, GNC.NUM_CON) TABLACHIDA
         WHERE COLUMNA = 1;
    END POPULAR1950;

    PROCEDURE BANDASPOPU_PUBLICO (G_ID                IN     INTEGER,
                                  BANDASPOPUPUBLICO      OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN BANDASPOPUPUBLICO FOR
              SELECT BANDASXGENERO.BAND_ID, AVG (VENUES.CAPACITY) PUBLICO
                FROM (SELECT *
                        FROM MUDB.MUSIC_GENRES GENERO
                             INNER JOIN MUDB.BANDS BANDAS
                                 ON BANDAS.MUSIC_GENRE_ID =
                                        GENERO.MUSIC_GENRE_ID
                       WHERE BANDAS.MUSIC_GENRE_ID = G_ID) BANDASXGENERO
                     INNER JOIN MUDB.CONCERTS_BANDS C_B
                         ON C_B.BAND_ID = BANDASXGENERO.BAND_ID
                     INNER JOIN MUDB.CONCERTS CONCIERTO
                         ON C_B.CONCERT_ID = CONCIERTO.CONCERT_ID
                     INNER JOIN MUDB.CONCERT_VENUES VENUES
                         ON CONCIERTO.CONCERT_VENUE_ID =
                                VENUES.CONCERT_VENUE_ID
            GROUP BY BANDASXGENERO.BAND_ID
            ORDER BY PUBLICO DESC;
    END;

    PROCEDURE MULTINSTRUMENTISTAS (MULTINSTRU OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN MULTINSTRU FOR
            SELECT tabla.musician_id
              FROM (SELECT MULTINSTRUMENTISTAS.MUSICIAN_ID,
                           MULTINSTRUMENTISTAS.NUM_INSTRUMENTOS,
                           ROW_NUMBER ()
                           OVER (
                               ORDER BY
                                   MULTINSTRUMENTISTAS.NUM_INSTRUMENTOS DESC)
                               NUM
                      FROM (  SELECT MUSICOS.MUSICIAN_ID,
                                     COUNT (BMI.INSTRUMENT_ID) NUM_INSTRUMENTOS
                                FROM MUDB.MUSICIANS MUSICOS
                                     INNER JOIN MUDB.BANDS_MUSICIANS BM
                                         ON BM.MUSICIAN_ID =
                                                MUSICOS.MUSICIAN_ID
                                     INNER JOIN
                                     MUDB.BANDS_MUSICIANS_INSTRUMENTS BMI
                                         ON BMI.BAND_MUSICIAN_ID =
                                                BM.BAND_MUSICIAN_ID
                               WHERE MUSICOS.DATE_DIED IS NULL
                            GROUP BY MUSICOS.MUSICIAN_ID) MULTINSTRUMENTISTAS
                     WHERE MULTINSTRUMENTISTAS.NUM_INSTRUMENTOS > 1) TABLA
             WHERE TABLA.NUM < 7;
    END;

    PROCEDURE ADDBAND (B_NAME      IN     VARCHAR2,
                       GENRE       IN     NUMBER,
                       B_HOME      IN     NUMBER,
                       B_DATE      IN     DATE,
                       B_CONTACT   IN     NUMBER,
                       SEQ_BANDA      OUT NUMBER)
    AS
    BEGIN
        SEQ_BANDA := MUDB.BANDS_SEQ.NEXTVAL;

        INSERT INTO MUDB.BANDS
             VALUES (SEQ_BANDA,
                     B_NAME,
                     GENRE,
                     B_HOME,
                     B_DATE,
                     B_CONTACT);
    END;

    PROCEDURE FIRST_INSTRUMENT (M_ID IN NUMBER, I_ID OUT NUMBER)
    AS
    BEGIN
        SELECT BMI_TABLA.FIRSTINSTRUMENT
          INTO I_ID
          FROM (SELECT BANDILLAS.BAND_ID,
                       BM1.MUSICIAN_ID,
                       MI.INSTRUMENT_ID FIRSTINSTRUMENT,
                       ROW_NUMBER ()
                           OVER (ORDER BY BANDILLAS.BAND_CREATION_DATE)
                           NUM1
                  FROM (SELECT BAND.BAND_ID,
                               BM.MUSICIAN_ID,
                               ROW_NUMBER ()
                                   OVER (ORDER BY BAND.BAND_CREATION_DATE)
                                   NUM,
                               BAND.BAND_CREATION_DATE
                          FROM MUDB.BANDS  BAND
                               INNER JOIN MUDB.BANDS_MUSICIANS BM
                                   ON BAND.BAND_ID = BM.BAND_ID
                         WHERE BM.MUSICIAN_ID = M_ID) BANDILLAS
                       INNER JOIN MUDB.BANDS_MUSICIANS BM1
                           ON BANDILLAS.BAND_ID = BM1.BAND_ID
                       INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS MI
                           ON BM1.BAND_MUSICIAN_ID = MI.BAND_MUSICIAN_ID
                 WHERE BANDILLAS.NUM = 1) BMI_TABLA
         WHERE BMI_TABLA.NUM1 = 1;
    END;

    PROCEDURE ADDTOBAND (B_ID IN NUMBER, M_ID IN NUMBER, BM_SEQ OUT NUMBER)
    AS
    BEGIN
        BM_SEQ := MUDB.BAND_MUSICIAN_SEQ.NEXTVAL;

        INSERT INTO MUDB.BANDS_MUSICIANS
             VALUES (BM_SEQ, B_ID, M_ID);
    END;

    PROCEDURE ADDINSTRUTOBAND (I_ID IN NUMBER, BM_SEQ IN NUMBER)
    AS
    BEGIN
        INSERT INTO MUDB.BANDS_MUSICIANS_INSTRUMENTS
             VALUES (BM_SEQ, I_ID, 1);
    END;

    PROCEDURE COMPOSITORESCHIDOS (COMPOSITORES OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN COMPOSITORES FOR
            SELECT tabla.musician_id
              FROM (SELECT COMPOSITORES.MUSICIAN_ID,
                           COMPOSITORES.NUM_COMPOSICIONES,
                           ROW_NUMBER ()
                           OVER (
                               ORDER BY COMPOSITORES.NUM_COMPOSICIONES DESC)
                               NUM
                      FROM (  SELECT MUSICOS.MUSICIAN_ID,
                                     COUNT (COMPOSITION_ID) NUM_COMPOSICIONES
                                FROM MUDB.MUSICIANS MUSICOS
                                     INNER JOIN
                                     MUDB.COMPOSITIONS_MUSICIANS CM
                                         ON CM.MUSICIAN_ID =
                                                MUSICOS.MUSICIAN_ID
                               WHERE MUSICOS.DATE_DIED IS NULL
                            GROUP BY MUSICOS.MUSICIAN_ID) COMPOSITORES) TABLA
             WHERE TABLA.NUM < 6;
    END;

    PROCEDURE BANDA_JOVEN (G_ID IN NUMBER, B_ID OUT NUMBER)
    AS
    BEGIN
        SELECT TABLA.BAND_ID
          INTO B_ID
          FROM (SELECT BAND_ID,
                       BAND_CREATION_DATE,
                       ROW_NUMBER () OVER (ORDER BY BAND_CREATION_DATE) NUM
                  FROM MUDB.BANDS
                 WHERE MUSIC_GENRE_ID = G_ID) TABLA
         WHERE TABLA.NUM = 1;
    END;

    PROCEDURE DESTINOS_GIRA (DESTINOS OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN DESTINOS FOR
              SELECT TABLA_VENUES.*, COUNTRY_NAME
                FROM (SELECT CONCERT_VENUE_ID, CITY_ID
                        FROM MUDB.CONCERT_VENUES VENUES
                       WHERE VENUES.CAPACITY > 180000) TABLA_VENUES
                     INNER JOIN MUDB.CITIES CIU
                         ON CIU.CITY_ID = TABLA_VENUES.CITY_ID
               WHERE    CIU.COUNTRY_NAME = 'Mexico'
                     OR CIU.COUNTRY_NAME = 'Argentina'
                     OR CIU.COUNTRY_NAME = 'Germany'
            ORDER BY CIU.COUNTRY_NAME;
    END;

    PROCEDURE CREATECONCERT (V_ID          IN     NUMBER,
                             C_DATE        IN     DATE,
                             C_ORGANIZER   IN     NUMBER,
                             C_ID             OUT NUMBER)
    AS
    BEGIN
        C_ID := MUDB.CONCERTS_SEQ.NEXTVAL;

        INSERT INTO MUDB.CONCERTS
             VALUES (C_ID,
                     V_ID,
                     C_DATE,
                     C_ORGANIZER);
    END;

    PROCEDURE CREATECONCERT_BANDS (C_ID      IN NUMBER,
                                   B_ID      IN NUMBER,
                                   SONGS     IN NUMBER,
                                   B_ORDER   IN NUMBER)
    AS
    BEGIN
        INSERT INTO MUDB.CONCERTS_BANDS
             VALUES (C_ID,
                     B_ID,
                     SONGS,
                     B_ORDER);
    END;
END PROCEDURES_EXAMEN02;