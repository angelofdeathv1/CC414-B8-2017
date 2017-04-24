/* Formatted on 21/04/2017 09:44:45 p. m. (QP5 v5.300) */
CREATE OR REPLACE PACKAGE BODY EX2RGG.RESPUESTAS_EXAMEN02
AS
    PROCEDURE RESPUESTA_01 (MUSICO_BANDA OUT SYS_REFCURSOR)
    IS
        SEQ    INTEGER;
        B_ID   INTEGER;
    BEGIN
        SEQ := MUDB.MUSICIANS_SEQ.NEXTVAL;

        EX2RGG.PROCEDURES_EXAMEN02.BANDA_MIN (B_ID);

        INSERT INTO MUDB.MUSICIANS
             VALUES (SEQ,
                     'Raquel Garza',
                     '23/08/1991',
                     '',
                     50,
                     85);

        INSERT INTO MUDB.BANDS_MUSICIANS
             VALUES (MUDB.BAND_MUSICIAN_SEQ.NEXTVAL, B_ID, SEQ);

        EX2RGG.PROCEDURES_EXAMEN02.NEW_INTEGRANT_BAND (B_ID, MUSICO_BANDA);
    END RESPUESTA_01;

    PROCEDURE RESPUESTA_02 (NEW_CONCERT OUT SYS_REFCURSOR)
    IS
        SEQ_CONCERT   INTEGER;
        GEN_CONCERT   INTEGER;
        C_ID    NUMBER;
    BEGIN
        SEQ_CONCERT := MUDB.CONCERTS_SEQ.NEXTVAL;

        EX2RGG.PROCEDURES_EXAMEN02.POPULAR1950 (GEN_CONCERT);
        DBMS_OUTPUT.PUT_LINE(GEN_CONCERT);

        EX2RGG.PROCEDURES_EXAMEN02.CREATECONCERT(1,'20/08/2017',1, C_ID);

        EX2RGG.PROCEDURES_EXAMEN02.BANDASPOPU_PUBLICO (GEN_CONCERT,
                                                       NEW_CONCERT);
    END RESPUESTA_02;

    PROCEDURE RESPUESTA_03 (MI OUT SYS_REFCURSOR)
    IS
        INST_ID         NUMBER;
        BM_ID           NUMBER;
        SEQ_BANDA       NUMBER;
        MUSICOS         SYS_REFCURSOR;

        TYPE NUMBER_ARRAY IS VARRAY (6) OF NUMBER;

        LISTA_MUSICOS   NUMBER_ARRAY;
    BEGIN
        EX2RGG.PROCEDURES_EXAMEN02.MULTINSTRUMENTISTAS (MUSICOS);

        FETCH MUSICOS BULK COLLECT INTO LISTA_MUSICOS;

        EX2RGG.PROCEDURES_EXAMEN02.ADDBAND ('The idontknows',
                                            10,
                                            10,
                                            SYSDATE,
                                            LISTA_MUSICOS (1),
                                            SEQ_BANDA);

        FOR INDX IN LISTA_MUSICOS.FIRST .. LISTA_MUSICOS.LAST
        LOOP
            EX2RGG.PROCEDURES_EXAMEN02.FIRST_INSTRUMENT (
                LISTA_MUSICOS (INDX),
                INST_ID);
            EX2RGG.PROCEDURES_EXAMEN02.ADDTOBAND (SEQ_BANDA,
                                                  LISTA_MUSICOS (INDX),
                                                  BM_ID); --B_ID IN NUMBER, M_ID IN NUMBER, BM_SEQ OUT NUMBER
            EX2RGG.PROCEDURES_EXAMEN02.ADDINSTRUTOBAND (INST_ID, BM_ID);
        END LOOP;

        OPEN MI FOR
            SELECT bm.band_id,
                   musico.musician_id,
                   musico.musician_name,
                   instru.instrument_id,
                   INSTRU.INSTRUMENT_NAME
              FROM MUDB.BANDS_MUSICIANS  BM
                   INNER JOIN MUDB.BANDS_MUSICIANS_INSTRUMENTS BMI
                       ON BM.BAND_MUSICIAN_ID = BMI.BAND_MUSICIAN_ID
                   INNER JOIN MUDB.MUSICIANS MUSICO
                       ON MUSICO.MUSICIAN_ID = BM.MUSICIAN_ID
                   INNER JOIN MUDB.INSTRUMENTS INSTRU
                       ON INSTRU.INSTRUMENT_ID = BMI.INSTRUMENT_ID
             WHERE BM.BAND_ID = SEQ_BANDA;
    END RESPUESTA_03;

    PROCEDURE RESPUESTA_04 (GIRA OUT SYS_REFCURSOR)
    IS
        COMPOSITORES         SYS_REFCURSOR;

        TYPE COMPOSITORES_ARRAY IS VARRAY (6) OF NUMBER;

        LISTA_COMPOSITORES   COMPOSITORES_ARRAY;
        SEQ_BANDA            NUMBER;

        TYPE BANDAS_ARRAY IS VARRAY (4) OF NUMBER;

        BP                   BANDAS_ARRAY;              --BANDAS PARTICIPANTES
        C_ID                 NUMBER;

        TYPE NUMBER_ARRAY IS VARRAY (50) OF NUMBER;

        VENUES_DESTINOS      NUMBER_ARRAY;
        CITIES_DESTINOS      NUMBER_ARRAY;

        TYPE VARCHAR_ARRAY IS VARRAY (50) OF VARCHAR2 (200);

        PAISES_DESTINOS      VARCHAR_ARRAY;

        TYPE DATES_ARRAY IS VARRAY (50) OF DATE;

        C_DATE               DATES_ARRAY;
        TMP_DATE             DATE;
        TMP                  VARCHAR2 (200);
        DESTINOS             SYS_REFCURSOR;
    BEGIN
        BP := BANDAS_ARRAY ();
        BP.EXTEND (4);
        EX2RGG.PROCEDURES_EXAMEN02.COMPOSITORESCHIDOS (COMPOSITORES);

        FETCH COMPOSITORES BULK COLLECT INTO LISTA_COMPOSITORES;

        EX2RGG.PROCEDURES_EXAMEN02.ADDBAND ('The Composers',
                                            10,
                                            10,
                                            SYSDATE,
                                            LISTA_COMPOSITORES (1),
                                            SEQ_BANDA);
        BP (1) := SEQ_BANDA;
        --DBMS_OUTPUT.PUT_LINE ('YO ESTOY DECLARADA: ' || BP (1));
        EX2RGG.PROCEDURES_EXAMEN02.BANDA_JOVEN (229, BP (2));     --ARENA ROCK
        --DBMS_OUTPUT.PUT_LINE ('YO ESTOY DECLARADA: ' || BP (2));
        EX2RGG.PROCEDURES_EXAMEN02.BANDA_JOVEN (274, BP (3));        --CHICANO
        --DBMS_OUTPUT.PUT_LINE ('YO ESTOY DECLARADA: ' || BP (3));
        EX2RGG.PROCEDURES_EXAMEN02.BANDA_JOVEN (162, BP (4));           --JPOP
        --DBMS_OUTPUT.PUT_LINE ('YO ESTOY DECLARADA: ' || BP (4));

        EX2RGG.PROCEDURES_EXAMEN02.DESTINOS_GIRA (DESTINOS);

        FETCH DESTINOS
            BULK COLLECT INTO VENUES_DESTINOS,
                 CITIES_DESTINOS,
                 PAISES_DESTINOS;

        C_DATE := DATES_ARRAY ();
        C_DATE.EXTEND (VENUES_DESTINOS.COUNT);

        --define dates here
        FOR INDX IN PAISES_DESTINOS.FIRST .. PAISES_DESTINOS.LAST
        LOOP
            IF INDX = 1
            THEN
                C_DATE (INDX) := ADD_MONTHS (SYSDATE, 2); --PRIMER CONCIERTO EN DOS MESES
                TMP_DATE := C_DATE (INDX);                    --ANTERIOR FECHA
                TMP := PAISES_DESTINOS (INDX);              --ANTERIOR DESTINO
            ELSE
                IF PAISES_DESTINOS (INDX) = TMP
                THEN
                    C_DATE (INDX) := (TMP_DATE + 2);
                    TMP_DATE := C_DATE (INDX);
                    TMP := PAISES_DESTINOS (INDX);
                ELSIF PAISES_DESTINOS (INDX) != TMP
                THEN
                    EXECUTE IMMEDIATE
                        'ALTER SESSION SET NLS_DATE_LANGUAGE = "AMERICAN"';

                    C_DATE (INDX) := NEXT_DAY (TMP_DATE, 'SUNDAY');
                    TMP_DATE := C_DATE (INDX);
                    TMP := PAISES_DESTINOS (INDX);
                END IF;
            END IF;
        END LOOP;

        --AQUI YA TENEMOS UN ARREGLO DE FECHAS, UN ARREGLO DE DESTINOS DE MISMA LONGITUD

        FOR INDX1 IN VENUES_DESTINOS.FIRST .. VENUES_DESTINOS.LAST
        LOOP
            EX2RGG.PROCEDURES_EXAMEN02.CREATECONCERT (
                VENUES_DESTINOS (INDX1),
                C_DATE (INDX1),
                10,
                C_ID);
            --DBMS_OUTPUT.PUT_LINE (C_ID);

            FOR INDX2 IN BP.FIRST .. BP.LAST
            LOOP
                --DBMS_OUTPUT.PUT_LINE (C_ID || ', ' || BP (INDX2));
                EX2RGG.PROCEDURES_EXAMEN02.CREATECONCERT_BANDS (C_ID,
                                                                BP (INDX2),
                                                                10,
                                                                10);
            END LOOP;
        END LOOP;

        --AQUI YA CREAMOS UN CONCIERTO POR VENUE Y RELACIONAMOS A CADA BANDA A ESE CONCIERTO

        OPEN GIRA FOR
            SELECT CONCIER.CONCERT_DATE,
                   VNS.VENUE_NAME,
                   CIUDA.CITY_NAME,
                   CIUDA.COUNTRY_NAME
              FROM MUDB.CONCERT_VENUES  VNS
                   INNER JOIN MUDB.CONCERTS CONCIER
                       ON CONCIER.CONCERT_VENUE_ID = VNS.CONCERT_VENUE_ID
                   INNER JOIN MUDB.CITIES CIUDA
                       ON CIUDA.CITY_ID = VNS.CITY_ID
                   INNER JOIN MUDB.CONCERTS_BANDS CB
                       ON CB.CONCERT_ID = CONCIER.CONCERT_ID
                   INNER JOIN MUDB.BANDS BAN ON BAN.BAND_ID = CB.BAND_ID
             WHERE CB.BAND_ID = SEQ_BANDA;
    END;
END RESPUESTAS_EXAMEN02;