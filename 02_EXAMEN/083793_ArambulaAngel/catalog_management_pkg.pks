CREATE OR REPLACE PACKAGE examen02.catalog_management_pkg
AS
    PROCEDURE insert_musician (in_musician_name       IN     VARCHAR2,
                               in_date_birth          IN     DATE,
                               in_date_died           IN     DATE,
                               in_origin_city_id      IN     INTEGER,
                               in_residence_city_id   IN     INTEGER,
                               out_musician_id           OUT INTEGER);

    PROCEDURE insert_band (in_band_name             IN     VARCHAR2,
                           in_music_genre_id        IN     INTEGER,
                           in_band_home_id          IN     INTEGER,
                           in_band_creation_date    IN     DATE,
                           in_contact_musician_id   IN     INTEGER,
                           out_band_id                 OUT INTEGER);

    PROCEDURE insert_band_musician (in_band_id             IN     INTEGER,
                                    in_musician_id         IN     INTEGER,
                                    out_band_musician_id      OUT INTEGER);

    PROCEDURE insert_band_music_instrument (
        in_band_musician_id   IN     INTEGER,
        in_instrument_id      IN     INTEGER,
        in_music_genre_id     IN     INTEGER,
        out_response             OUT INTEGER);

    PROCEDURE insert_concert (in_concert_venue_id       IN     INTEGER,
                              in_concert_date           IN     DATE,
                              in_concert_organizer_id   IN     INTEGER,
                              out_concert_id               OUT INTEGER);

    PROCEDURE insert_concert_band (in_concert_id     IN     INTEGER,
                                   in_band_id        IN     INTEGER,
                                   in_played_songs   IN     INTEGER,
                                   in_band_order     IN     INTEGER,
                                   out_response         OUT INTEGER);
END catalog_management_pkg;
/