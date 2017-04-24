/* Formatted on 4/21/2017 7:20:35 PM (QP5 v5.300) */
/*
2-Crear un concierto con bandas del género que más conciertos tenga registrados desde 1950;
Ordenar a las bandas de acuerdo a su promedio de público en sus conciertos (Asumiendo que todos son sold out).
Mostrar las bandas participantes y su orden.
*/

CREATE OR REPLACE PACKAGE EX2MAR.NUM2
AS
    PROCEDURE BANDS (YE IN NUMBER, GEN IN NUMBER, LBANDS OUT SYS_REFCURSOR);

    PROCEDURE AVCON (LBANDS IN SYS_REFCURSOR, AVGBAND OUT SYS_REFCURSOR);

    PROCEDURE GENRE (YE IN NUMBER, GEN OUT NUMBER);

    PROCEDURE MAKE (RESULT OUT SYS_REFCURSOR);
END NUM2;

CREATE OR REPLACE PACKAGE BODY EX2MAR.NUM2
AS
    PROCEDURE GENRE (YE IN NUMBER, GEN OUT NUMBER)
    AS
    BEGIN
          SELECT B.MUSIC_GENRE_ID
            INTO GEN
            FROM MUDB.CONCERTS_BANDS CB
                 INNER JOIN MUDB.BANDS B ON CB.BAND_ID = B.BAND_ID
                 INNER JOIN MUDB.CONCERTS CON
                     ON CB.CONCERT_ID = CON.CONCERT_ID
           WHERE EXTRACT (YEAR FROM CON.CONCERT_DATE) >= 1950
          HAVING COUNT (B.MUSIC_GENRE_ID) =
                     (  SELECT MAX (COUNT (B.MUSIC_GENRE_ID))
                          FROM MUDB.CONCERTS_BANDS CB
                               INNER JOIN MUDB.BANDS B
                                   ON CB.BAND_ID = B.BAND_ID
                               INNER JOIN MUDB.CONCERTS CON
                                   ON CB.CONCERT_ID = CON.CONCERT_ID
                         WHERE EXTRACT (YEAR FROM CON.CONCERT_DATE) >= 1950
                      GROUP BY B.MUSIC_GENRE_ID)
        GROUP BY B.MUSIC_GENRE_ID
        ORDER BY COUNT (B.MUSIC_GENRE_ID) DESC;
    END GENRE;

    PROCEDURE BANDS (YE IN NUMBER, GEN IN NUMBER, LBANDS OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN LBANDS FOR
            SELECT B.BAND_ID
              FROM MUDB.CONCERTS_BANDS  CB
                   INNER JOIN MUDB.BANDS B ON CB.BAND_ID = B.BAND_ID
                   INNER JOIN MUDB.CONCERTS CON
                       ON CB.CONCERT_ID = CON.CONCERT_ID
             WHERE     EXTRACT (YEAR FROM CON.CONCERT_DATE) >= 1950
                   AND B.MUSIC_GENRE_ID = GEN;
    END BANDS;

    PROCEDURE AVCON (LBANDS IN SYS_REFCURSOR, AVGBAND OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN AVGBAND FOR
              SELECT AVG (V.CAPACITY), LBANDS.BAND_ID
                FROM LBANDS
                     INNER JOIN MUDB.CONCERTS CON
                         ON LBANDS.CONCERT_ID = CON.CONCERT_ID
                     INNER JOIN MUDB.CONCERT_VENUES V
                         ON CON.CONCERT_VENUE_ID = V.CONCERT_VENUE_ID
               WHERE B.BAND_ID = BAND
            ORDER BY AVG (V.CAPACITY) DESC;
    END AVCON;

    PROCEDURE MAKE (RESULT OUT SYS_REFCURSOR)
    IS
        TEMPCID     NUMBER;
        TEMPCOUNT   NUMBER;
        AVGBAND     SYS_REFCURSOR;
        L_BANDS     AVGBAND%ROWTYPE;
    BEGIN
        AVCON (AVGBAND);

        SELECT MUDB.CONCERTS_SEQ.NEXTVAL INTO TEMPCID FROM DUAL;

        TEMPCOUNT := 1;

        INSERT INTO MUDB.CONCERTS (CONCERT_ID,
                                       CONCERT_VENUE_ID,
                                       CONCERT_DATE,
                                       CONCERT_ORGANIZER_ID)
             VALUES (TEMPCID,
                     5,
                     SYSDATE,
                     8);

        OPEN AVGBAND;

        LOOP
            FETCH AVGBAND INTO L_BANDS;

            INSERT INTO MUDB.CONCERT_BANDS (CONCERT_ID,
                                                BAND_ID,
                                                PLAYED_SONGS,
                                                BAND_ORDER)
                 VALUES (TEMPCID,
                         L_BANDS.BAND_ID,
                         5,
                         TEMPCOUNT);

            TEMPCOUNT := TEMPCOUNT + 1;

            EXIT WHEN AVGBAND%NOTFOUND;
        END LOOP;

        OPEN RESULT FOR
              SELECT CON.CONCERT_DATE, VEN.VENUE_NAME, BAND.BAND_NAME
                FROM MUDB.CONCERTS CON
                     INNER JOIN MUDB.CONCERT_VENUES VEN
                         ON CON.CONCERT_VENUE_ID = VEN.CONCERT_VENUE_ID
                     INNER JOIN MUDB.CONCERTS_BANDS BAN
                         ON CON.CONCERT_ID = BAN.CONCERT_ID
                     INNER JOIN MUDB.BANDS BAND
                         ON BAN.BAND_ID = BAND.BAND_ID
               WHERE CON.CONCERT_ID = TEMPCID
            ORDER BY BAN.BAND_ORDER ASC;
    END MAKE;
END NUM2;