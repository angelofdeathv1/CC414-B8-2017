/* Formatted on 4/21/2017 4:24:40 PM (QP5 v5.300) */
/*
1-Registrar a un musico (Banjo, Accordion), asignarlo a la banda con el menor numero de integrantes;
*/

  SELECT BM.BAND_ID, COUNT (*) MEMBERS
    FROM MUDB.BANDS_MUSICIANS BM
GROUP BY BM.BAND_ID
  HAVING COUNT (*) >= 1
ORDER BY MEMBERS ASC;

CREATE OR REPLACE PROCEDURE ISACE21380.N1 (M_NAME          IN     VARCHAR2,
                                           M_BIRTH         IN     DATE,
                                           M_DIED          IN     DATE,
                                           M_ORIGINID      IN     NUMBER,
                                           M_RESIDENCEID   IN     NUMBER,
                                           RESPONSE           OUT VARCHAR2)
IS
    TMPVAR   VARCHAR2 (100);
BEGIN
    TMPVAR := 'OK';

    INSERT INTO MUDB.MUSICIANS MUS
         VALUES (MUSICIANS_SEQ.NEXTVAL,
                 M_NAME,
                 M_BIRTH,
                 M_DIED,
                 M_ORIGINID,
                 M_RESIDENCEID);
END N1;

DECLARE
    TV   VARCHAR2 (100);
BEGIN
    ISACE21380.N1 ('Isac Ramirez',
                   '12-AUG-1995',
                   '',
                   8,
                   13,
                   TV);
    DBMS_OUTPUT.PUT_LINE (TV);
END;

CREATE OR REPLACE PROCEDURE ISACE21380.B1 (B_ID IN NUMBER, M_ID IN NUMBER)
IS
    TMVVAR   VARCHAR2 (100);
BEGIN
    TMVVAR := 'OK';

    INSERT INTO MUDB.BANDS_MUSICIANS BM
         VALUES (BAND_MUSICIAN_SEQ.NEXTVAL, B_ID, M_ID);
END B1;

DECLARE
    TV   VARCHAR2 (100);
BEGIN
    ISACE21380.B1 (73, 1502, TV);
    DBMS_OUTPUT.PUT_LINE (TV);
END;

CREATE OR REPLACE PROCEDURE ISACE21380.IM (BMID       IN     NUMBER,
                                           I_ID       IN     NUMBER,
                                           G_ID       IN     NUMBER,
                                           RESPONSE      OUT VARCHAR2)
IS
    TMVVAR   VARCHAR2 (100);
BEGIN
    TMVVAR := 'OK';

    INSERT INTO MUDB.BANDS_MUSICIANS_INSTRUMENTS BMI
         VALUES (BMID, I_ID, G_ID);
END IM;

DECLARE
    TV   VARCHAR2 (100);
BEGIN
    ISACE21380.IM (3001,
                   1,
                   3,
                   TV);
    DBMS_OUTPUT.PUT_LINE (TV);
END;

DECLARE
    TV   VARCHAR2 (100);
BEGIN
    ISACE21380.IM (3001,
                   35,
                   3,
                   TV);
    DBMS_OUTPUT.PUT_LINE (TV);
END;
/*WITH THE SAME BAND_ID*/

/*
2-Crear un concierto con bandas del genero que mas conciertos tenga registrados desde 1950;
Ordenar a las bandas de acuerdo a su promedio de publico en sus conciertos (Asumiendo que todos son sold out).
Mostrar las bandas participantes y su orden.
*/

CREATE OR REPLACE PACKAGE ISACE21380.PKT2
AS
    PROCEDURE EJER2 (RESULTADO OUT SYS_REFCURSOR);
    PROCEDURE EJER3 (RESULTADO OUT SYS_REFCURSOR);
END PKT2;

CREATE OR REPLACE PACKAGE BODY ISACE21380.PKT2
AS
    PROCEDURE EJER2 (RESULTADO OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN RESULTADO FOR
            SELECT DISTINCT BAN.BAND_ID,
                                      BAN.BAND_NAME,
                                      MG.GENRE_NAME,
                                      AVG (CONV.CAPACITY) AS CAPACITY_AVG
                        FROM MUDB.BANDS BAN
                             INNER JOIN MUDB.MUSIC_GENRES MG
                                 ON BAN.MUSIC_GENRE_ID = MG.MUSIC_GENRE_ID
                             INNER JOIN MUDB.CONCERTS_BANDS CB
                                 ON BAN.BAND_ID = CB.BAND_ID
                             INNER JOIN MUDB.CONCERTS CON
                                 ON CB.CONCERT_ID = CON.CONCERT_ID
                             INNER JOIN MUDB.CONCERT_VENUES CONV
                                 ON CON.CONCERT_VENUE_ID =
                                        CONV.CONCERT_VENUE_ID
                       WHERE     EXTRACT (YEAR FROM CON.CONCERT_DATE) >= 1950
                             AND MG.MUSIC_GENRE_ID =
                                     (SELECT MUSIC_GENRE_ID
                                        FROM (  SELECT MG.MUSIC_GENRE_ID,
                                                       MAX (MUSIC_GENRE_ID_COUNT)
                                                  FROM (  SELECT MG.MUSIC_GENRE_ID,
                                                                 COUNT (
                                                                     MG.MUSIC_GENRE_ID)
                                                                     AS MUSIC_GENRE_ID_COUNT
                                                            FROM MUDB.CONCERTS
                                                                 CON
                                                                 INNER JOIN
                                                                 MUDB.CONCERTS_BANDS
                                                                 CB
                                                                     ON CB.CONCERT_ID =
                                                                            CON.CONCERT_ID
                                                                 INNER JOIN
                                                                 MUDB.BANDS
                                                                 BAN
                                                                     ON BAN.BAND_ID =
                                                                            CB.BAND_ID
                                                                 INNER JOIN
                                                                 MUDB.MUSIC_GENRES
                                                                 MG
                                                                     ON MG.MUSIC_GENRE_ID =
                                                                            BAN.MUSIC_GENRE_ID
                                                           WHERE EXTRACT (
                                                                     YEAR FROM CON.CONCERT_DATE) >=
                                                                     1950
                                                        GROUP BY MG.MUSIC_GENRE_ID)
                                                       MG
                                              GROUP BY MG.MUSIC_GENRE_ID
                                              ORDER BY MAX (
                                                           MG.MUSIC_GENRE_ID_COUNT) DESC)
                                       WHERE ROWNUM = 1)
                    GROUP BY BAN.BAND_ID, BAN.BAND_NAME, MG.GENRE_NAME
                    ORDER BY CAPACITY_AVG DESC;
    END EJER2;
END PKT2;
--INSERT INTO MUDB.CONCERTS CON

CREATE OR REPLACE FUNCTION ISACE21380.REFC
RETURN SYS_REFCURSOR 
AS 
    CUR SYS_REFCURSOR;
    BEGIN
    OPEN CUR FOR ISACE21380.PKT2.EJER2;
    RETURN CUR;
END;
/*
3-Crear una banda con musicos multi instrumentalistas (vivos)
(6 integrantes - no repetidos,asignarle el instrumento que toco en su primera banda); 
mostrar a los integrantes de la banda y los diferentes instrumentos que tocan.
*/
SELECT * FROM (SELECT MUS.MUSICIAN_ID, MUS.MUSICIAN_NAME, COUNT(MUS.MUSICIAN_ID) AS INSQUA FROM (SELECT MUS.MUSICIAN_ID, MUS.MUSICIAN_NAME, INS.INSTRUMENT_NAME, BAND_NAME FROM MUDB.INSTRUMENTS INS
                   INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS BMI
                       ON BMI.INSTRUMENT_ID = INS.INSTRUMENT_ID
                   INNER JOIN MUDB.BANDS_MUSICIANS BM
                       ON BM.BAND_MUSICIAN_ID = BMI.BAND_MUSICIAN_ID
                   INNER JOIN MUDB.MUSICIANS MUS
                       ON MUS.MUSICIAN_ID = BM.BAND_MUSICIAN_ID
                   INNER JOIN MUDB.BANDS BAN
                        ON BAN.BAND_ID = BM.BAND_ID)MUS
                GROUP BY MUS.MUSICIAN_ID, MUS.MUSICIAN_NAME
                ORDER BY INSQUA DESC)
                WHERE ROWNUM <= 6;

SELECT * FROM (SELECT MUS.MUSICIAN_ID, MAX (COUNTER)
    FROM (SELECT MUS.MUSICIAN_ID, COUNT (MUS.MUSICIAN_ID) AS COUNTER
              FROM MUDB.INSTRUMENTS INS
                   INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS BMI
                       ON BMI.INSTRUMENT_ID = INS.INSTRUMENT_ID
                   INNER JOIN MUDB.BANDS_MUSICIANS BM
                       ON BM.BAND_MUSICIAN_ID = BMI.BAND_MUSICIAN_ID
                   INNER JOIN MUDB.MUSICIANS MUS
                       ON MUS.MUSICIAN_ID = BM.BAND_MUSICIAN_ID
          GROUP BY MUS.MUSICIAN_ID) MUS
GROUP BY MUS.MUSICIAN_ID
ORDER BY MAX (COUNTER) DESC)
WHERE ROWNUM <= 6;