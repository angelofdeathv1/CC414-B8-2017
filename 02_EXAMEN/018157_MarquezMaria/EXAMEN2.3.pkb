/* Formatted on 4/21/2017 10:38:09 PM (QP5 v5.300) */
/*
3-Crear una banda con musicos multi instrumentalistas (vivos)
(6 integrantes - no repetidos,asignarle el instrumento que toco en su primera banda); 
mostrar a los integrantes de la banda y los diferentes instrumentos que tocan.
*/

CREATE OR REPLACE PACKAGE EX2MAR.NUM3
AS
    PROCEDURE MUSICOS (LMUSIC OUT SYS_REFCURSOR);

    PROCEDURE INST (MID IN NUMBER, INST OUT NUMBER);

    PROCEDURE MAKE (RESULT OUT SYS_REFCURSOR);
END NUM3;

CREATE OR REPLACE PACKAGE BODY EX2MAR.NUM3
AS
    PROCEDURE MUSICOS (LMUSIC OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN LMUSIC FOR
            SELECT ROWNUM, tabla.MUSICIAN_ID
              FROM (  SELECT COUNT (MU.MUSICIAN_ID), MU.MUSICIAN_ID
                        FROM MUDB.BANDS_MUSICIANS BM
                             INNER JOIN MUDB.MUSICIANS MU
                                 ON BM.MUSICIAN_ID = MU.MUSICIAN_ID
                             INNER JOIN
                             MUDB.BANDS_MUSICIANS_INSTRUMENTS BMI
                                 ON BM.BAND_MUSICIAN_ID = BMI.BAND_MUSICIAN_ID
                    GROUP BY MU.MUSICIAN_ID
                      HAVING COUNT (MU.MUSICIAN_ID) > 1
                    ORDER BY COUNT (MU.MUSICIAN_ID) DESC) tabla
             WHERE ROWNUM <= 6;
    END MUSICOS;

    PROCEDURE INST (MID IN NUMBER, INST OUT NUMBER)
    AS
    BEGIN
        SELECT *
          INTO INST
          FROM (  SELECT BMI.INSTRUMENT_ID
                    FROM MUDB.BANDS_MUSICIANS_INSTRUMENTS BMI
                         INNER JOIN MUDB.BANDS_MUSICIANS BM
                             ON BMI.BAND_MUSICIAN_ID = BM.BAND_MUSICIAN_ID
                         INNER JOIN MUDB.BANDS B ON BM.BAND_ID = BM.BAND_ID
                   WHERE BM.MUSICIAN_ID = MID
                ORDER BY B.BAND_CREATION_DATE DESC)
         WHERE ROWNUM = 1;
    END INST;

    PROCEDURE MAKE (RESULT OUT SYS_REFCURSOR)
    IS
        TYPE LLMUSIC IS TABLE OF DUAL%ROWTYPE;

        TEMPBID    NUMBER;
        TEMPBMID   NUMBER;
        LMUSIC     SYS_REFCURSOR;
        L_MUSIC    LLMUSIC;
    BEGIN
        MUSICOS (LMUSIC);

        SELECT MUDB.BANDS_SEQ.NEXTVAL INTO TEMPBID FROM DUAL;

        INSERT INTO MUDB.BANDS (BAND_ID,
                                    BAND_NAME,
                                    MUSIC_GENRE_ID,
                                    BAND_HOME_ID,
                                    BAND_CREATION_DATE,
                                    CONTACT_MUSICIAN_ID)
             VALUES (TEMPBID,
                     'Los Juanitos',
                     8,
                     9,
                     SYSDATE,
                     9);

        FETCH LMUSIC BULK COLLECT INTO L_MUSIC;

        FOR INDX IN 1 .. L_MUSIC.COUNT
        LOOP
            SELECT MUDB.BAND_MUSICIAN_SEQ.NEXTVAL INTO TEMPBMID FROM DUAL;

            INSERT
              INTO MUDB.BANDS_MUSICIANS (BAND_MUSICIAN_ID,
                                             BAND_ID,
                                             MUSICIAN_ID)
            VALUES (TEMPBM, TEMPBID, L_MUSIC (INDX));

            MUDB.NUM3.INST (L_MUSIC (INDX), TEMPINST);

            INSERT
              INTO MUDB.BANDS_MUSICIANS_INSTRUMENTS (BAND_MUSICIAN_ID,
                                                         INSTRUMENT_ID,
                                                         MUSIC_GENRE_ID)
            VALUES (TEMPBMID, TEMPINST, 6);
        END LOOP;

        OPEN RESULT FOR
            SELECT BAN.BAND_NAME, MU.MUSICIAN_NAME, INST.INSTRUMENT_NAME
              FROM MUDB.BANDS  BAN
                   INNER JOIN MUDB.BANDS_MUSICIANS BM
                       ON BAN.BAND_ID = BM.BAND_ID
                   INNER JOIN MUDB.MUSICIANS MU
                       ON BM.MUSICIAN_ID = MU.MUSICIAN_ID
                   INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS BMI
                       ON BM.BAND_MUSICIAN_ID = BMI.BAND_MUSICIAN_ID
                   INNER JOIN MUDB.INSTRUMENTS INST
                       ON BMI.INSTRUMENT_ID = INST.INSTRUMENT_ID
             WHERE BAN.BAND_ID = TEMPBID;
    END MAKE;
END NUM3;