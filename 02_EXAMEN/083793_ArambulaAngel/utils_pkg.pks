CREATE OR REPLACE PACKAGE EXAMEN02.UTILS_PKG
AS
    FUNCTION GET_LOWEST_MEMBERS_BAND_ID
        RETURN INTEGER;

    FUNCTION GET_INSTRUMENT_ID (IN_INSTRUMENT IN VARCHAR2)
        RETURN INTEGER;
END UTILS_PKG;
/