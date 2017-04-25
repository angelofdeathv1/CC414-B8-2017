CREATE OR REPLACE PACKAGE EXAMEN02.CATALOG_MANAGEMENT_PKG
AS
    PROCEDURE INSERT_MUSICIAN (IN_MUSICIAN_NAME       IN     VARCHAR2,
                               IN_DATE_BIRTH          IN     DATE,
                               IN_DATE_DIED           IN     DATE,
                               IN_ORIGIN_CITY_ID      IN     INTEGER,
                               IN_RESIDENCE_CITY_ID   IN     INTEGER,
                               OUT_MUSICIAN_ID           OUT INTEGER);

    PROCEDURE INSERT_BAND (IN_BAND_NAME             IN     VARCHAR2,
                           IN_MUSIC_GENRE_ID        IN     INTEGER,
                           IN_BAND_HOME_ID          IN     INTEGER,
                           IN_BAND_CREATION_DATE    IN     DATE,
                           IN_CONTACT_MUSICIAN_ID   IN     INTEGER,
                           OUT_BAND_ID                 OUT INTEGER);

    PROCEDURE INSERT_BAND_MUSICIAN (IN_BAND_ID             IN     INTEGER,
                                    IN_MUSICIAN_ID         IN     INTEGER,
                                    OUT_BAND_MUSICIAN_ID      OUT INTEGER);

    PROCEDURE INSERT_BAND_MUSIC_INSTRUMENT (
        IN_BAND_MUSICIAN_ID   IN     INTEGER,
        IN_INSTRUMENT_ID      IN     INTEGER,
        IN_MUSIC_GENRE_ID     IN     INTEGER,
        OUT_RESPONSE             OUT INTEGER);
END CATALOG_MANAGEMENT_PKG;
/
