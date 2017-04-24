CREATE OR REPLACE PACKAGE PACKAGE_EX
    AS
        PROCEDURE RESPONSE_01(MNAME   IN MUSICIANS.MUSICIAN_NAME%TYPE,
        MDATE   IN MUSICIANS.DATE_BIRTH%TYPE,
        MDIED   IN MUSICIANS.DATE_DIED%TYPE,
        MORIG   IN MUSICIANS.ORIGIN_CITY_ID%TYPE,
        MRESI   IN MUSICIANS.RESIDENCE_CITY_ID%TYPE,
        IDINST  IN INTEGER    );
        PROCEDURE RESPONSE_02( VENUE   IN  CONCERTS.CONCERT_VENUE_ID%TYPE,
        DATEE   IN  CONCERTS.CONCERT_DATE%TYPE,
        ORGAN   IN  CONCERTS.CONCERT_ORGANIZER_ID%TYPE,
        SONGS   IN  INTEGER);
        PROCEDURE RESPONSE_03;
    END PACKAGE_EX;

CREATE OR REPLACE PACKAGE BODY PACKAGE_EX
    AS
        PROCEDURE RESPONSE_01 (
        MNAME   IN MUSICIANS.MUSICIAN_NAME%TYPE,
        MDATE   IN MUSICIANS.DATE_BIRTH%TYPE,
        MDIED   IN MUSICIANS.DATE_DIED%TYPE,
        MORIG   IN MUSICIANS.ORIGIN_CITY_ID%TYPE,
        MRESI   IN MUSICIANS.RESIDENCE_CITY_ID%TYPE,
        IDINST  IN INTEGER    
        )
        IS
        IDMUSI INTEGER;
        IDBAND INTEGER;
        IDGENR INTEGER;
        IDBAMU INTEGER;
        TEMP2 VARCHAR(100);
        BEGIN  
        MUSICIANS_PRO_ADD(MNAME, MDATE, MDIED, MORIG, MRESI, IDMUSI);
        BANDS_PRO_MIN(IDBAND);
        BANDS_MUSICIANS_PRO_ADD(IDBAND, IDMUSI, IDBAMU);
        BANDS_PRO_GNR(IDBAND,IDGENR);
        BANDS_MUSICIANS_INS_PRO_ADD(IDBAMU, IDINST, IDGENR);        
        RESPONSE_01_CUR(IDBAND);
        SELECT BAND_NAME INTO TEMP2
            FROM BANDS
            WHERE IDBAND = BAND_ID;    
        DBMS_OUTPUT.PUT_LINE(TEMP2);
           
        END RESPONSE_01;
        
        PROCEDURE RESPONSE_02(
        VENUE   IN  CONCERTS.CONCERT_VENUE_ID%TYPE,
        DATEE   IN  CONCERTS.CONCERT_DATE%TYPE,
        ORGAN   IN  CONCERTS.CONCERT_ORGANIZER_ID%TYPE,
        SONGS   IN  INTEGER
        )
        IS
        IDGENR INTEGER;
        IDCONC INTEGER;
        BEGIN
        MUSIC_GENRE_PRO_MOST(IDGENR);
        CONCERTS_PRO_ADD(VENUE, DATEE, ORGAN, IDCONC);
        RESPONSE_02_CUR(IDGENR, IDCONC, SONGS);
        END RESPONSE_02;
        
        PROCEDURE IBARRA2.RESPONSE_03
        IS
        TEMP INTEGER;
        BEGIN
            BANDS_PRO_ADD('Nuevos Rebeldes',10,10,10,TEMP);
            RESPONSE_03_CUR(TEMP);
        END RESPONSE_03;

        
    END PACKAGE_EX;