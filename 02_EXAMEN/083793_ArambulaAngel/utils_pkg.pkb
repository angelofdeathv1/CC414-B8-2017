CREATE OR REPLACE PACKAGE BODY EXAMEN02.UTILS_PKG
AS
    FUNCTION GET_LOWEST_MEMBERS_BAND_ID
        RETURN INTEGER
    AS
        N_BAND_ID   INTEGER;
    BEGIN
        BEGIN
            SELECT BAND_ID
              INTO N_BAND_ID
              FROM (  SELECT BAND_ID,
                             COUNT (*),
                             ROW_NUMBER () OVER (ORDER BY COUNT (*) ASC)
                                 BAND_RANK
                        FROM EXAMEN02.BANDS_MUSICIANS
                    GROUP BY BAND_ID)
             WHERE BAND_RANK = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                N_BAND_ID := 0;
        END;

        RETURN N_BAND_ID;
    END GET_LOWEST_MEMBERS_BAND_ID;

    FUNCTION GET_INSTRUMENT_ID (IN_INSTRUMENT IN VARCHAR2)
        RETURN INTEGER
    AS
        N_INSTRUMENT_ID   INTEGER;
    BEGIN
        BEGIN
            SELECT INSTRUMENT_ID
              INTO N_INSTRUMENT_ID
              FROM EXAMEN02.INSTRUMENTS
             WHERE LOWER (INSTRUMENT_NAME) LIKE 'accordion' AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                N_INSTRUMENT_ID := 0;
        END;

        RETURN N_INSTRUMENT_ID;
    END;
END UTILS_PKG;
/
