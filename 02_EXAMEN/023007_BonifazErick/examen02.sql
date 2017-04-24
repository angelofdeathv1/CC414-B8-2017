1.
1-Registrar a un músico (Banjo, Accordion), asignarlo a la banda con el menor 
numero de integrantes;
*/
--=========================================================================
CREATE OR REPLACE PACKAGE PACKAGE_EX
    AS

CREATE OR REPLACE PROCEDURE EX2BON.agregar_morro(nombre IN VARCHAR2, 
nacimiento IN DATE, muerte IN DATE, origen IN NUMBER, residencia IN NUMBER, 
 RESPONSE OUT VARCHAR2)
IS 
    TMPVAR VARCHAR2 (100);
    id_banda NUMBER(20);
    id_musico NUMBER(20);
    
BEGIN
    TMPVAR := 'OK';
    id_musico := MUSICIANS_SEQ.NEXTVAL;
    id_bm := BANDS_MUSICIANS_SEQ.NEXTVAL;

    BEGIN
       MUDB.banda_menor(id_banda);
       DBMS_OUTPUT.PUT_LINE(id_banda);
    END;

    INSERT INTO MUDB.MUSICIANS MUS
    VALUES (id_musico, nombre, nacimiento, muerte, origen, 
    residencia); 
    
    INSERT INTO MUDB.BANDS_MUSICIANS BM 
    VALUES (id_bm, id_banda, id_musico);
    
END agregar_morro;

/*BEGIN
    MUDB.agregar_morro('Erick Bonifaz','30-DEC-1994', '' , 8, 13, VA);
    DBMS_OUTPUT.PUT_LINE(VA);
END;*/


--=========================================================================


CREATE OR REPLACE PROCEDURE EX2BON.banda_menor(id_banda OUT NUMBER) 

IS  
BEGIN   
SELECT BAND_ID INTO id_banda
    FROM 
    (
    SELECT BM.BAND_ID, COUNT(*) MEMBERS
        FROM MUDB.BANDS_MUSICIANS BM
            GROUP BY BM.BAND_ID HAVING COUNT(*) >= 1
            ORDER BY MEMBERS, BAND_ID ASC
    ) counts
    WHERE ROWNUM =1;
  
END banda_menor;
END PACKAGE_EX
   2.
2-Crear un concierto con bandas del género que más conciertos tenga registrados
 desde 1950;
Ordenar a las bandas de acuerdo a su promedio de público en sus conciertos
 (Asumiendo que todos son sold out).
Mostrar las bandas participantes y su orden.*/

--=====================  AGREGAR CONCIERTO  ===============================

CREATE OR REPLACE PROCEDURE EX2BON.nuevo_concierto(fecha IN DATE)
IS 
    --TMPVAR VARCHAR2 (100);
    TMPVAR VARCHAR2 (100) := CONCERTS_SEQ.NEXTVAL;
BEGIN
    TMPVAR := 'OK';
    INSERT INTO MUDB.CONCERTS CON 
    VALUES (TMPVAR,***IDBANDA***,fecha,6); 
END nuevo_concierto;
DECLARE 
    VA VARCHAR2 (100);
BEGIN
    MUDB.nuevo_concierto('02-FEB-2003');
    DBMS_OUTPUT.PUT_LINE(VA);
END;

  SELECT BM.BAND_ID, COUNT(*) MEMBERS 
        FROM MUDB.BANDS_MUSICIANS BM
            GROUP BY BM.BAND_ID HAVING COUNT(*) >= 1
            ORDER BY MEMBERS, BAND_ID ASC
            
--======================================================

CREATE OR REPLACE PROCEDURE EX2BON.buscar_genero_alto (id_genero OUT NUMBER)
IS 

BEGIN
-- BUSCAR CONCIERTOS >1950 *************************
SELECT CONCERT_DATE 
        FROM MUDB.CONCERTS CON
        WHERE EXTRACT (YEAR FROM CON.CONCERT_DATE) > 1995;
END buscar_genero_alto ;
--*************************************************


-- BUSCAR GENERO MAS ALTO *************************
CREATE OR REPLACE PROCEDURE EX2BON.buscar_genero_alto (id_genero OUT NUMBER)
IS 
id_genero NUMBER(20);
BEGIN
SELECT MUSIC_GENRE_ID INTO id_genero
    FROM 
    (
    SELECT BAN.MUSIC_GENRE_ID, COUNT(*) NUMERO_CONCIERTOS
        FROM MUDB.BANDS BAN
            GROUP BY BAN.MUSIC_GENRE_ID 
            ORDER BY NUMERO_CONCIERTOS DESC
    ) counts
    WHERE ROWNUM =1;
    
END buscar_genero_alto;

SELECT * 
    FROM MUDB.MUSIC_GENRES
    WHERE MUSIC_GENRE_ID = 271


CREATE OR REPLACE PROCEDURE EX2BON.tabla_bandas (tabla_b OUT NUMBER)
AS
    cursor_b SYS_REFCURSOR;

BEGIN

    CURSOR CUR_VAR IS (SELECT BAND_ID
    FROM MUDB.BANDS
    WHERE MUSIC_GENRE_ID = (SELECT MUSIC_GENRE_ID 
    FROM 
    (
    SELECT BAN.MUSIC_GENRE_ID, COUNT(*) NUMERO_CONCIERTOS
        FROM MUDB.BANDS BAN
            GROUP BY BAN.MUSIC_GENRE_ID 
            ORDER BY NUMERO_CONCIERTOS DESC
    ) counts
    WHERE ROWNUM =1))
    CUR_VARs employee%ROWTYPE;
    
    LOOP
    dbms_output.put_line(CUR_VAR);
    END LOOP;
   
END tabla_bandas;


--*************************************************
3. 
SELECT MUS.MUSICIAN_NAME, INS.INSTRUMENT_NAME, BAND_NAME 
    FROM MUDB.INSTRUMENTS INS 
    INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS BMI 
    ON BMI.INSTRUMENT_ID = INS.INSTRUMENT_ID 
    INNER JOIN MUDB.BANDS_MUSICIANS BM 
    ON BM.BAND_MUSICIAN_ID = BMI.BAND_MUSICIAN_ID 
    INNER JOIN MUDB.MUSICIANS MUS 
    ON MUS.MUSICIAN_ID = BM.BAND_MUSICIAN_ID 
    INNER JOIN MUDB.BANDS BAN 
    ON BAN.BAND_ID = BM.BAND_ID 
    WHERE MUS.MUSICIAN_ID = 1457; 
SELECT * FROM (SELECT MUS.MUSICIAN_ID, MAX (COUNTER) 
    FROM ( SELECT MUS.MUSICIAN_ID, COUNT (MUS.MUSICIAN_ID) 
    AS COUNTER FROM MUDB.INSTRUMENTS INS 
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
4. 
/*
4-Crear una banda con los cinco compositores con mayor numero de composiciones
 registradas; 
organizar una gira de conciertos junto a la banda mas reciente de los generos: 
"Arena Rock", "Chicano" y "J-Pop";
La gira debe ser por los paises: "Mexico", "Argentina" y "Germany" en venues
que tengan una capacidad mayor a 180,000 espectadores.
Cada fecha se separará por 1 dia, cuando se cambie de país la gira se reanuda 
hasta el siguiente domingo.
Mostrar las fechas de la gira y sus venues con su ciudad y país.
*/

--1. Buscador y filtrador de 5 mayores compositores
DECLARE

    CURSOR c_musicos IS
        SELECT * FROM MUDB.COMPOSITIONS_MUSICIANS CM
        c_musico MUDB.COMPOSITIONS_MUSICIANS.MUSICIAN_ID%ROWTYPE;
BEGIN
    FOR c_musicos IN c_musicos LOOP
    
    END LOOP;
END;   
    SELECT MUSICIAN_ID, counts.COMPOSICIONES
    FROM(
    SELECT CM.MUSICIAN_ID, COUNT(*) COMPOSICIONES
        FROM MUDB.COMPOSITIONS_MUSICIANS CM
            GROUP BY CM.MUSICIAN_ID
            ORDER BY COMPOSICIONES DESC
        )counts
        WHERE ROWNUM <= 5
        
DECLARE
     CURSOR v_employeeRecords IS
          SELECT * FROM Employee WHERE Salary > 10;
     v_employeeRecord  employee%ROWTYPE;
BEGIN
     FOR v_employeeRecord IN v_employeeRecords LOOP
          /* Do something with v_employeeRecord */
     END LOOP;
END;

--==================================================
SELECT *   
    FROM MUDB.BANDS BA
        INNER JOIN MUDB.MUSIC_GENRES MG
        ON BA.MUSIC_GENRE_ID = MG.MUSIC_GENRE_ID
    WHERE GENRE_NAME = 'Arena Rock' OR 'Chicano' OR 'J-Pop'
