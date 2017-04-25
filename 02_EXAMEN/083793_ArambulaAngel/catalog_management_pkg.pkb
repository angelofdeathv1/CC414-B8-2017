CREATE OR REPLACE PACKAGE BODY EXAMEN02.CATALOG_MANAGEMENT_PKG
AS
    PROCEDURE INSERT_MUSICIAN (IN_MUSICIAN_NAME       IN     VARCHAR2,
                               IN_DATE_BIRTH          IN     DATE,
                               IN_DATE_DIED           IN     DATE,
                               IN_ORIGIN_CITY_ID      IN     INTEGER,
                               IN_RESIDENCE_CITY_ID   IN     INTEGER,
                               OUT_MUSICIAN_ID           OUT INTEGER)
    AS
        N_MUSICIAN_ID   NUMBER;
    BEGIN
        SELECT EXAMEN02.MUSICIANS_SEQ.NEXTVAL INTO N_MUSICIAN_ID FROM DUAL;

        BEGIN
            INSERT INTO EXAMEN02.MUSICIANS (MUSICIAN_ID,
                                            MUSICIAN_NAME,
                                            DATE_BIRTH,
                                            DATE_DIED,
                                            ORIGIN_CITY_ID,
                                            RESIDENCE_CITY_ID)
                 VALUES (N_MUSICIAN_ID,
                         IN_MUSICIAN_NAME,
                         IN_DATE_BIRTH,
                         IN_DATE_DIED,
                         IN_ORIGIN_CITY_ID,
                         IN_RESIDENCE_CITY_ID);
        EXCEPTION
            WHEN OTHERS
            THEN
                OUT_MUSICIAN_ID := -1;
        END;

        OUT_MUSICIAN_ID := N_MUSICIAN_ID;
    END INSERT_MUSICIAN;

    PROCEDURE INSERT_BAND (IN_BAND_NAME             IN     VARCHAR2,
                           IN_MUSIC_GENRE_ID        IN     INTEGER,
                           IN_BAND_HOME_ID          IN     INTEGER,
                           IN_BAND_CREATION_DATE    IN     DATE,
                           IN_CONTACT_MUSICIAN_ID   IN     INTEGER,
                           OUT_BAND_ID                 OUT INTEGER)
    AS
        N_BAND_ID   NUMBER;
    BEGIN
        SELECT EXAMEN02.BANDS_SEQ.NEXTVAL INTO N_BAND_ID FROM DUAL;

        BEGIN
            INSERT INTO EXAMEN02.BANDS (BAND_ID,
                                        BAND_NAME,
                                        MUSIC_GENRE_ID,
                                        BAND_HOME_ID,
                                        BAND_CREATION_DATE,
                                        CONTACT_MUSICIAN_ID)
                 VALUES (N_BAND_ID,
                         IN_BAND_NAME,
                         IN_MUSIC_GENRE_ID,
                         IN_BAND_HOME_ID,
                         IN_BAND_CREATION_DATE,
                         IN_CONTACT_MUSICIAN_ID);
        EXCEPTION
            WHEN OTHERS
            THEN
                N_BAND_ID := -1;
        END;

        OUT_BAND_ID := N_BAND_ID;
    END INSERT_BAND;

    PROCEDURE INSERT_BAND_MUSICIAN (IN_BAND_ID             IN     INTEGER,
                                    IN_MUSICIAN_ID         IN     INTEGER,
                                    OUT_BAND_MUSICIAN_ID      OUT INTEGER)
    AS
        N_BAND_MUSICIAN_ID   INTEGER;
    BEGIN
        BEGIN
            SELECT BAND_MUSICIAN_ID
              INTO N_BAND_MUSICIAN_ID
              FROM EXAMEN02.BANDS_MUSICIANS
             WHERE BAND_ID = IN_BAND_ID AND IN_MUSICIAN_ID = IN_MUSICIAN_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                SELECT EXAMEN02.BAND_MUSICIAN_SEQ.NEXTVAL
                  INTO N_BAND_MUSICIAN_ID
                  FROM DUAL;

                INSERT
                  INTO EXAMEN02.BANDS_MUSICIANS (BAND_MUSICIAN_ID,
                                                 BAND_ID,
                                                 MUSICIAN_ID)
                VALUES (N_BAND_MUSICIAN_ID, IN_BAND_ID, IN_MUSICIAN_ID);
        END;

        OUT_BAND_MUSICIAN_ID := N_BAND_MUSICIAN_ID;
    END INSERT_BAND_MUSICIAN;

    PROCEDURE INSERT_BAND_MUSIC_INSTRUMENT (
        IN_BAND_MUSICIAN_ID   IN     INTEGER,
        IN_INSTRUMENT_ID      IN     INTEGER,
        IN_MUSIC_GENRE_ID     IN     INTEGER,
        OUT_RESPONSE             OUT INTEGER)
    AS
        N_BAND_MUSICIAN_ID   INTEGER;
    BEGIN
        BEGIN
            SELECT BAND_MUSICIAN_ID
              INTO N_BAND_MUSICIAN_ID
              FROM EXAMEN02.BANDS_MUSICIANS_INSTRUMENTS
             WHERE     BAND_MUSICIAN_ID = IN_BAND_MUSICIAN_ID
                   AND INSTRUMENT_ID = IN_INSTRUMENT_ID;

            OUT_RESPONSE := 0;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                INSERT
                  INTO EXAMEN02.BANDS_MUSICIANS_INSTRUMENTS (
                           BAND_MUSICIAN_ID,
                           INSTRUMENT_ID,
                           MUSIC_GENRE_ID)
                    VALUES (
                               IN_BAND_MUSICIAN_ID,
                               IN_INSTRUMENT_ID,
                               IN_MUSIC_GENRE_ID);

                OUT_RESPONSE := 1;
        END;
    END INSERT_BAND_MUSIC_INSTRUMENT;
END CATALOG_MANAGEMENT_PKG;
/
