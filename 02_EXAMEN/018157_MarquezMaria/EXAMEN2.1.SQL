/* Formatted on 4/21/2017 5:24:58 PM (QP5 v5.300) */
/*
1-Registrar a un músico (Banjo, Accordion), asignarlo a la banda con el menor numero de integrantes;
*/

CREATE OR REPLACE PACKAGE EX2MAR.NUM1
AS
    PROCEDURE NEWMUSIC (NAM      IN     VARCHAR2,
                        DBIRTH   IN     DATE,
                        DDEAD    IN     DATE,
                        OCITY    IN     NUMBER,
                        RCITY    IN     NUMBER,
                        MUSCID      OUT NUMBER);

    PROCEDURE BAND (BANDID OUT NUMBER);

    PROCEDURE MAKE (RESULT OUT SYS_REFCURSOR);
END NUM1;

CREATE OR REPLACE PACKAGE BODY EX2MAR.NUM1
AS
    PROCEDURE NEWMUSIC (NAM      IN     VARCHAR2,
                        DBIRTH   IN     DATE,
                        DDEAD    IN     DATE,
                        OCITY    IN     NUMBER,
                        RCITY    IN     NUMBER,
                        MUSCID      OUT NUMBER)
    AS
    BEGIN
        SELECT MUDB.MUSICIANS_SEQ.NEXTVAL INTO MUSCID FROM DUAL;

        INSERT INTO MUDB.MUSICIANS (MUSICIAN_ID,
                                        MUSICIAN_NAME,
                                        DATE_BIRTH,
                                        DATE_DIED,
                                        ORIGIN_CITY_ID,
                                        RESIDENCE_CITY_ID)
             VALUES (MUSCID,
                     NAM,
                     DBIRTH,
                     DDEAD,
                     OCITY,
                     RCITY);
    END NEWMUSIC;


    PROCEDURE BAND (BANDID OUT NUMBER)
    AS
    BEGIN
        SELECT BM.BAND_ID
          INTO BANDID
          FROM MUDB.BANDS_MUSICIANS BM
         WHERE ROWNUM = 1
        HAVING COUNT (BM.BAND_ID) = 1;
    END BAND;

    PROCEDURE MAKE (RESULT OUT SYS_REFCURSOR)
    IS
        TEMPMUSIC   NUMBER;
        TEMPBAND    NUMBER;
        TEMPBMID    NUMBER;
    BEGIN
        NEWMUSIC ('Juanito',
                  '05-FEB-1987',
                  NULL,
                  2,
                  3,
                  TEMPMUSIC);
        BAND (TEMPBAND);

        SELECT MUDB.BAND_MUSICIAN_SEQ.NEXTVAL INTO TEMPBMID FROM DUAL;

        INSERT
          INTO MUDB.BANDS_MUSICIANS (BAND_MUSICIAN_ID,
                                         BAND_ID,
                                         MUSICIAN_ID)
        VALUES (TEMPBMID, TEMPBAND, TEMPMUSIC);

        INSERT
          INTO MUDB.BANDS_MUSICIANS_INSTRUMENTS (BAND_MUSICIAN_ID,
                                                     INSTRUMENT_ID,
                                                     MUSIC_GENRE_ID)
        VALUES (TEMPBMID,
                (SELECT INST.INSTRUMENT_NAME
                   FROM MUDB.INSTRUMENTS INST
                  WHERE INST.INSTRUMENT_NAME LIKE 'Banjo'),
                3);

        INSERT
          INTO MUDB.BANDS_MUSICIANS_INSTRUMENTS (BAND_MUSICIAN_ID,
                                                     INSTRUMENT_ID,
                                                     MUSIC_GENRE_ID)
        VALUES (TEMPBMID,
                (SELECT INST.INSTRUMENT_NAME
                   FROM MUDB.INSTRUMENTS INST
                  WHERE INST.INSTRUMENT_NAME LIKE 'Accordion'),
                3);

        OPEN RESULT FOR
            SELECT *
              FROM MUDB.BANDS_MUSICIANS  BM
                   INNER JOIN MUDB.BANDS B ON BM.BAND_ID = B.BAND_NAME
                   INNER JOIN MUDB.MUSICIANS MU
                       ON BM.MUSICIAN_ID = MU.MUSICIAN_ID
             WHERE BM.BAND_ID = TEMPBAND;
    END MAKE;
END NUM1;