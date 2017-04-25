CREATE OR REPLACE PACKAGE BODY EXAMEN02.MAIN_PKG
AS
    /******************************************************************************
       NAME:       MAIN_PKG
       PURPOSE:

       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        4/20/2017      aarambula       1. Created this package.
    ******************************************************************************/

    PROCEDURE TEST_01_BANJO (out_cur_musicians OUT SYS_REFCURSOR)
    AS
        N_MUSICIAN_ID        INTEGER;
        N_BAND_ID            INTEGER;
        N_INSTRUMENT_A       INTEGER;
        N_INSTRUMENT_B       INTEGER;
        N_BAND_MUSICIAN_ID   INTEGER;
    BEGIN
        N_BAND_ID := EXAMEN02.UTILS_PKG.GET_LOWEST_MEMBERS_BAND_ID ();
        N_INSTRUMENT_A := EXAMEN02.UTILS_PKG.GET_INSTRUMENT_ID ('BANJO');
        N_INSTRUMENT_B := EXAMEN02.UTILS_PKG.GET_INSTRUMENT_ID ('ACCORDION');

        EXAMEN02.CATALOG_MANAGEMENT_PKG.INSERT_MUSICIAN ('John Petrucci',
                                                         '12-JUL-1964',
                                                         NULL,
                                                         11,
                                                         32,
                                                         N_MUSICIAN_ID);

        EXAMEN02.CATALOG_MANAGEMENT_PKG.INSERT_BAND_MUSICIAN (
            N_BAND_ID,
            N_MUSICIAN_ID,
            N_BAND_MUSICIAN_ID);
    END TEST_01_BANJO;

    PROCEDURE TEST_02_BANDS_CONCERT (out_cur_concert OUT SYS_REFCURSOR)
    IS
    BEGIN
        NULL;
    END TEST_02_BANDS_CONCERT;

    PROCEDURE TEST_03_BANDS_INSTRUMENTALISTS (out_cur_band OUT SYS_REFCURSOR)
    IS
    BEGIN
        NULL;
    END TEST_03_BANDS_INSTRUMENTALISTS;

    PROCEDURE TEST_04_WORLD_TOUR (out_cur_bands OUT SYS_REFCURSOR)
    IS
    BEGIN
        NULL;
    END TEST_04_WORLD_TOUR;
END MAIN_PKG;
/
