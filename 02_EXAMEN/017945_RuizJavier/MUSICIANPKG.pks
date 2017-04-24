CREATE OR REPLACE PACKAGE JAVIER2.musicianPkg
AS
    PROCEDURE createMusician (MUSICIAN_NAME VARCHAR2, DATE_BIRTH DATE, DATE_DIED DATE DEFAULT NULL, ORIGIN_CITY_ID NUMBER, RESIDENCE_CITY_ID NUMBER,salida OUT NUMBER);
    PROCEDURE createMusician2(salida OUT SYS_REFCURSOR);
    PROCEDURE createBandMusician(BANDID NUMBER, MUSICIANID NUMBER,salida OUT NUMBER);
    PROCEDURE createBMI(BANDMUSICIANID NUMBER, INSTRUMENTID NUMBER, MUSICGENREID NUMBER);
    PROCEDURE secondOne(salida OUT SYS_REFCURSOR);
    PROCEDURE createConcert(CONCERTDATE DATE, CONCERTORGANIZERID NUMBER,CONCERTVENUEID NUMBER,salida out NUMBER);
    PROCEDURE createMultiBand(salida OUT SYS_REFCURSOR);
END musicianPkg;
/