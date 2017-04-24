/* Formatted on 21/04/2017 11:19:03 p. m. (QP5 v5.300) */
/*1. Registrar a un musico ("Banjo, "Accordion"), asignarlo a la banda con el menor numero de integrantes;
mostrar musico y su nueva banda.
1.1 OBTENER BANDA CON MENOS INTEGRANTES
1.2 PROCEDURE PARA REGISTAR UN MUSICO
1.3 REGISTRAR UN MUSICO

2. Crear un concierto con bandas del genero que mas conciertos tenga registrados desde 1950; 
ordenar a las bandas de acuerdo a su promedio de publico en sus Conciertos (Asumiendo que todos son sold out);
mostrar las bandas participantes y su orden.

3. Crear una banda con musicos multi instrumentalistas (vivos)
(6 integrantes no repetidos, asignarle el instrumento que toco en su primera banda);
Mostrar a los integrantes de la banda y los diferentes instrumentos que tocan.

4. Crear una banda con lo cinco compositores con mayor numero de composiciones registradas;
organizar una gira de conciertos junto a la banda mas reciente de los generos: "Arena Rock", "Chicano" y "J-Pop";
la gira debe ser por los paises : "Mexico", "Argentina", "Germany" en venues que tengan una capacidad mayor a 180,000 espectadores.
Cada fecha se separara por 1 dia, cuando se cambie de pais la gira se reanuda hsta el siguiente domingo.
Mostrar las fehcas de la gira y sus venues con su ciudad y pais*/

--PROBLEMA 1: OBTENER BANDAS CON MENOS INTEGRANTES

/*  SELECT BANMUS.BAND_ID, COUNT (*) MEMBERS
    FROM MUDB.BANDS_MUSICIANS BANMUS
GROUP BY BANMUS.BAND_ID
  HAVING COUNT (*) < 3
ORDER BY MEMBERS ASC
*/
--PROBLEMA 1: PROCEDURE PARA REGISTRAR UN MUSICO

CREATE OR REPLACE PROCEDURE MICHEL02.REGMUS (
    MUS_NAME           IN     VARCHAR2,
    MUS_BIRTH          IN     DATE,
    MUS_DIED           IN     DATE,
    MUS_ORIGIN_ID      IN     NUMBER,
    MUS_RESIDENCE_ID   IN     NUMBER,
    RESPONSE              OUT VARCHAR2)
IS
    TMPVAR   VARCHAR2 (100);
BEGIN
    TMPVAR := 'DONE';

    INSERT INTO MUDB.MUSICIANS MUS
         VALUES (MUSICIANS_SEQ.NEXTVAL,
                 MUS_NAME,
                 MUS_BIRTH,
                 MUS_DIED,
                 MUS_ORIGIN_ID,
                 MUS_RESIDENCE_ID);
END REGMUS;

--DECLARAR EL NUEVO MUSICO

DECLARE
    RES   VARCHAR2 (100);
BEGIN
    MICHEL02.REGMUS ('MICHEL',
                     '18-AUG-1995',
                     '',
                     1,
                     1,
                     RES);
    DBANMUSS_OUTPUT.PUT_LINE (RES);
END;

--Problema 1: Meter a la banda el nuevo musico

CREATE OR REPLACE PROCEDURE MICHEL02.BAND (BAND_ID       IN NUMBER,
                                           MUSICIAN_ID   IN NUMBER,
                                           RESPONSE         VARCHAR2)
IS
    TMPVAR   VARCHAR2 (100);
BEGIN
    TMPVAR := 'DONE';

    INSERT INTO MUDB.BANDS_MUSICIANS BANMUS
         VALUES (BAND_MUSICIAN_SEQ.NEXTVAL, BAND_ID, MUSICIAN_ID);
END BAND;

DECLARE
    RES   VARCHAR2 (100);
BEGIN
    MICHEL02.BAND (75, 1500, RES);
    DBANMUSS_OUTPUT.PUT_LINE (RES);
END;

CREATE OR REPLACE PROCEDURE MICHEL02.ADD_INSTRUMENT (
    MUS_ID     IN     NUMBER,
    INS_ID     IN     NUMBER,
    GENRE_ID   IN     NUMBER,
    RESPONSE      OUT VARCHAR2)
IS
    TMPVAR   VARCHAR2 (100);
BEGIN
    TMPVAR := 'OK';

    INSERT INTO MUDB.BANDS_MUSICIANS_INSTRUMENTS BANDMUSINS
         VALUES (MUS_ID, INS_ID, GENRE_ID);
END ADD_INSTRUMENT;

DECLARE
    RES   VARCHAR2 (100);
BEGIN
    MICHEL02.ADD_INSTRUMENT (3001,
                             1,
                             3,
                             RES);
    DBANMUSS_OUTPUT.PUT_LINE (RES);
END;
--PROBLEMA 2: SELECT PARA OBTENER EL ID DE LAS BANDAS Y DEL GENERO PARA SABER LOS CONCIERTOS
/*  SELECT CONBAN.BAND_ID, COUNT (*) CONCIERTOS
    FROM MUDB.CONCERTS_BANDS CONBAN
         INNER JOIN MUDB.BANDS BAN ON BAN.BAND_ID = CONBAN.BAND_ID
         INNER JOIN MUDB.MUSIC_GENRES GEN
             ON GEN.MUSIC_GENRE_ID = BAN.MUSIC_GENRE_ID
GROUP BY CONBAN.BAND_ID
ORDER BY CONCIERTOS DESC;
*/
--SELECT PARA ORDENAR LAS BANDAS DE CIERTO GENERO QUE HAN TENIDO MAS CONCIERTOS
/*
  SELECT GEN.MUSIC_GENRE_ID AS GENRE_ID,
         COUNT (GEN.MUSIC_GENRE_ID) AS GENRE_CONCERTS_NUMBER FROM MUDB.CONCERTS CON
         INNER JOIN MUDB.CONCERTS_BANDS CONBAN
             ON CONBAN.CONCERT_ID = CON.CONCERT_ID
         INNER JOIN MUDB.BANDS BAN ON BAN.BAND_ID = CONBAN.BAND_ID
         INNER JOIN MUDB.MUSIC_GENRES GEN
             ON GEN.MUSIC_GENRE_ID = BAN.MUSIC_GENRE_ID
--WHERE EXTRACT (YEAR FROM CON.CONCERT_DATE) >= 1950
--ORDER BY CONCERT_DATE ASC;
GROUP BY GEN.MUSIC_GENRE_ID
ORDER BY COUNT(GEN.MUSIC_GENRE_ID) DESC;
*/
--PROBLEMA 2:

CREATE OR REPLACE PACKAGE MICHEL02.PAQUETE2
AS
    PROCEDURE PROCEDIMIENTO2 (RES OUT SYS_REFCURSOR);
END PAQUETE2;

CREATE OR REPLACE PACKAGE BODY MICHEL02.PAQUETE2
AS
    PROCEDURE PROCEDIMIENTO2 (RES OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN RES FOR
              SELECT BAN.BAND_ID,
                     BAN.BAND_NAME,
                     GEN.MUSIC_GENRE_ID,
                     GEN.GENRE_NAME,
                     AVG (CONVEN.CAPACITY) AS PROM_CAP
                FROM MUDB.BANDS BAN
                     INNER JOIN MUDB.MUSIC_GENRES GEN
                         ON BAN.MUSIC_GENRE_ID = GEN.MUSIC_GENRE_ID
                     INNER JOIN MUDB.CONCERTS_BANDS CONBAN
                         ON BAN.BAND_ID = CONBAN.BAND_ID
                     INNER JOIN MUDB.CONCERTS CON
                         ON CONBAN.CONCERT_ID = CON.CONCERT_ID
                     INNER JOIN MUDB.CONCERT_VENUES CONVEN
                         ON CON.CONCERT_VENUE_ID = CONVEN.CONCERT_VENUE_ID
               WHERE     EXTRACT (YEAR FROM CON.CONCERT_DATE) >= 1950
                     AND GEN.MUSIC_GENRE_ID =
                             (SELECT MUSIC_GENRE_ID --GENERO QUE TENGA MAS CONCIERTOS
                                FROM (  SELECT GEN.MUSIC_GENRE_ID,
                                               MAX (CANTIDAD_DE_CONCIERTOS)
                                          FROM (  SELECT GEN.MUSIC_GENRE_ID,
                                                         COUNT (GEN.MUSIC_GENRE_ID)
                                                             AS CANTIDAD_DE_CONCIERTOS
                                                    FROM MUDB.CONCERTS CON
                                                         INNER JOIN
                                                         MUDB.CONCERTS_BANDS
                                                         CONBAN
                                                             ON CONBAN.CONCERT_ID =
                                                                    CON.CONCERT_ID --RELACIONAR ID DE CONCIERTO DE LA TABLA CONCIERTOS CON LA TABLA CONCIERTOS BANDA
                                                         INNER JOIN
                                                         MUDB.BANDS BAN
                                                             ON BAN.BAND_ID =
                                                                    CONBAN.BAND_ID --RELACIONAR ID DE LAS BANDAS DE LA TABLA BANDAS Y CONCIERTOS BANDAS
                                                         INNER JOIN
                                                         MUDB.MUSIC_GENRES GEN
                                                             ON GEN.MUSIC_GENRE_ID =
                                                                    BAN.MUSIC_GENRE_ID --RELACIONAR EL ID DEL GENERO DE LA TABLA DE GENEROS CON LA DE BANDAS
                                                   WHERE EXTRACT (
                                                             YEAR FROM CON.CONCERT_DATE) >=
                                                             1950 --MOSTRAR SOLO LOS CONCIERTOS CON FECHA DESPUES DE 1950
                                                GROUP BY GEN.MUSIC_GENRE_ID) GEN
                                      GROUP BY GEN.MUSIC_GENRE_ID
                                      ORDER BY MAX (CANTIDAD_DE_CONCIERTOS) DESC)
                               WHERE ROWNUM = 1)
            GROUP BY BAN.BAND_ID,
                     BAN.BAND_NAME,
                     GEN.MUSIC_GENRE_ID,
                     GEN.GENRE_NAME
            ORDER BY PROM_CAP DESC;
    END PROCEDIMIENTO2;
END PAQUETE2;

CREATE OR REPLACE FUNCTION MICHEL02.FUNCION_CURSOR
    RETURN SYS_REFCURSOR
AS
    CUR   SYS_REFCURSOR;
BEGIN
    OPEN CUR FOR MICHEL02.PAQUETE2.PROCEDIMIENTO2;

    RETURN CUR;
END;

--PROBLEMA 3:

  SELECT MUS.MUSICIAN_ID, MAX (CANTIDAD_INSTRUMENTOS)
    FROM (  SELECT MUS.MUSICIAN_ID,
                   COUNT (MUS.MUSICIAN_ID) AS CANTIDAD_INSTRUMENTOS
              FROM MUDB.INSTRUMENTS INSTRUMENTOS
                   INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS BANMUSINS
                       ON INSTRUMENTOS.INSTRUMENT_ID = BANMUSINS.INSTRUMENT_ID
                   INNER JOIN MUDB.BANDS_MUSICIANS BANMUS
                       ON BANMUSINS.BAND_MUSICIAN_ID = BANMUS.BAND_MUSICIAN_ID
                   INNER JOIN MUDB.MUSICIANS MUS
                       ON BANMUS.BAND_MUSICIAN_ID = MUS.MUSICIAN_ID
          GROUP BY MUS.MUSICIAN_ID) MUS
GROUP BY MUS.MUSICIAN_ID
ORDER BY MAX (CANTIDAD_INSTRUMENTOS) DESC;

/*SELECT MUS.MUSICIAN_NAME, INS.INSTRUMENT_NAME, BAND_NAME
  FROM MUDB.INSTRUMENTS INS
       INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS BANMUSINS
           ON INS.INSTRUMENT_ID = BANMUSINS.INSTRUMENT_ID
       INNER JOIN MUDB.BANDS_MUSICIANS BANMUS
           ON BANMUSINS.BAND_MUSICIAN_ID = BANMUS.BAND_MUSICIAN_ID
       INNER JOIN MUDB.MUSICIANS MUS
           ON BANMUS.BAND_MUSICIAN_ID = MUS.MUSICIAN_ID
       INNER JOIN MUDB.BANDS BAN 
       ON BANMUS.BAND_ID = BAN.BAND_ID
 WHERE MUS.MUSICIAN_ID = 17;*/
 ------

 /*
 SELECT * FROM (SELECT MUS.MUSICIAN_ID, MUS.MUSICIAN_NAME, COUNT(MUS.MUSICIAN_ID) AS NO_INSTRUMENTOS FROM (SELECT MUS.MUSICIAN_NAME, INS.INSTRUMENT_NAME
  FROM MUDB.INSTRUMENTS INS
       INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS BANMUSINS
           ON INS.INSTRUMENT_ID = BANMUSINS.INSTRUMENT_ID
       INNER JOIN MUDB.BANDS_MUSICIANS BANMUS
           ON BANMUSINS.BAND_MUSICIAN_ID = BANMUS.BAND_MUSICIAN_ID
       INNER JOIN MUDB.MUSICIANS MUS
           ON BANMUS.BAND_MUSICIAN_ID = MUS.MUSICIAN_ID) MUS
       INNER JOIN MUDB.BANDS BAN 
       ON BANMUS.BAND_ID = BAN.BAND_ID
       GROUP BY MUS.MUSICIAN_ID
       ORDER BY MAX (NO_INSTRUMENTOS) DESC)
       WHERE ROWNUM <=6;
*/
-------

SELECT *
  FROM (  SELECT MUS.MUSICIAN_ID,
                 MUS.MUSICIAN_NAME,
                 --INS.INSTRUMENT_NAME
                 COUNT (MUS.MUSICIAN_ID) AS NO_INSTRUMENTOS
            FROM (SELECT MUS.MUSICIAN_ID,
                         MUS.MUSICIAN_NAME,
                         INS.INSTRUMENT_NAME,
                         BAND_NAME
                    FROM MUDB.INSTRUMENTS INS
                         INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS BANMUSINS
                             ON INS.INSTRUMENT_ID = BANMUSINS.INSTRUMENT_ID
                         INNER JOIN MUDB.BANDS_MUSICIANS BANMUS
                             ON BANMUSINS.BAND_MUSICIAN_ID = BANMUS.BAND_MUSICIAN_ID
                         INNER JOIN MUDB.MUSICIANS MUS
                             ON BANMUS.BAND_MUSICIAN_ID = MUS.MUSICIAN_ID
                         INNER JOIN MUDB.BANDS BAN
                             ON BANMUS.BAND_ID = BAN.BAND_ID) MUS
        GROUP BY MUS.MUSICIAN_ID, MUS.MUSICIAN_NAME
        ORDER BY NO_INSTRUMENTOS DESC)
 WHERE ROWNUM <= 6;