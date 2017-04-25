CREATE OR REPLACE PACKAGE BODY examen02.catalog_management_pkg
AS
    PROCEDURE insert_musician (in_musician_name       IN     VARCHAR2,
                               in_date_birth          IN     DATE,
                               in_date_died           IN     DATE,
                               in_origin_city_id      IN     INTEGER,
                               in_residence_city_id   IN     INTEGER,
                               out_musician_id           OUT INTEGER)
    AS
        n_musician_id   NUMBER;
    BEGIN
        SELECT examen02.musicians_seq.NEXTVAL INTO n_musician_id FROM DUAL;

        BEGIN
            INSERT INTO examen02.musicians (musician_id,
                                            musician_name,
                                            date_birth,
                                            date_died,
                                            origin_city_id,
                                            residence_city_id)
                 VALUES (n_musician_id,
                         in_musician_name,
                         in_date_birth,
                         in_date_died,
                         in_origin_city_id,
                         in_residence_city_id);
        EXCEPTION
            WHEN OTHERS
            THEN
                out_musician_id := -1;
        END;

        out_musician_id := n_musician_id;
    END insert_musician;

    PROCEDURE insert_band (in_band_name             IN     VARCHAR2,
                           in_music_genre_id        IN     INTEGER,
                           in_band_home_id          IN     INTEGER,
                           in_band_creation_date    IN     DATE,
                           in_contact_musician_id   IN     INTEGER,
                           out_band_id                 OUT INTEGER)
    AS
        n_band_id   NUMBER;
    BEGIN
        SELECT examen02.bands_seq.NEXTVAL INTO n_band_id FROM DUAL;

        BEGIN
            INSERT INTO examen02.bands (band_id,
                                        band_name,
                                        music_genre_id,
                                        band_home_id,
                                        band_creation_date,
                                        contact_musician_id)
                 VALUES (n_band_id,
                         in_band_name,
                         in_music_genre_id,
                         in_band_home_id,
                         in_band_creation_date,
                         in_contact_musician_id);
        EXCEPTION
            WHEN OTHERS
            THEN
                n_band_id := -1;
        END;

        out_band_id := n_band_id;
    END insert_band;

    PROCEDURE insert_band_musician (in_band_id             IN     INTEGER,
                                    in_musician_id         IN     INTEGER,
                                    out_band_musician_id      OUT INTEGER)
    AS
        n_band_musician_id   INTEGER;
    BEGIN
        BEGIN
            SELECT band_musician_id
              INTO n_band_musician_id
              FROM examen02.bands_musicians
             WHERE band_id = in_band_id AND musician_id = in_musician_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                SELECT examen02.band_musician_seq.NEXTVAL
                  INTO n_band_musician_id
                  FROM DUAL;

                INSERT
                  INTO examen02.bands_musicians (band_musician_id,
                                                 band_id,
                                                 musician_id)
                VALUES (n_band_musician_id, in_band_id, in_musician_id);
        END;

        out_band_musician_id := n_band_musician_id;
    END insert_band_musician;

    PROCEDURE insert_band_music_instrument (
        in_band_musician_id   IN     INTEGER,
        in_instrument_id      IN     INTEGER,
        in_music_genre_id     IN     INTEGER,
        out_response             OUT INTEGER)
    AS
        n_band_musician_id   INTEGER;
    BEGIN
        BEGIN
            SELECT band_musician_id
              INTO n_band_musician_id
              FROM examen02.bands_musicians_instruments
             WHERE     band_musician_id = in_band_musician_id
                   AND instrument_id = in_instrument_id;

            out_response := 0;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                INSERT
                  INTO examen02.bands_musicians_instruments (
                           band_musician_id,
                           instrument_id,
                           music_genre_id)
                    VALUES (
                               in_band_musician_id,
                               in_instrument_id,
                               in_music_genre_id);

                out_response := 1;
        END;
    END insert_band_music_instrument;

    PROCEDURE insert_concert (in_concert_venue_id       IN     INTEGER,
                              in_concert_date           IN     DATE,
                              in_concert_organizer_id   IN     INTEGER,
                              out_concert_id               OUT INTEGER)
    AS
        n_concert_id   INTEGER;
    BEGIN
        SELECT examen02.concerts_seq.NEXTVAL INTO n_concert_id FROM DUAL;

        BEGIN
            INSERT INTO examen02.concerts (concert_id,
                                           concert_venue_id,
                                           concert_date,
                                           concert_organizer_id)
                 VALUES (n_concert_id,
                         in_concert_venue_id,
                         in_concert_date,
                         in_concert_organizer_id);
        EXCEPTION
            WHEN OTHERS
            THEN
                n_concert_id := -1;
        END;

        out_concert_id := n_concert_id;
    END insert_concert;

    PROCEDURE insert_concert_band (in_concert_id     IN     INTEGER,
                                   in_band_id        IN     INTEGER,
                                   in_played_songs   IN     INTEGER,
                                   in_band_order     IN     INTEGER,
                                   out_response         OUT INTEGER)
    AS
        n_concert_band_id   INTEGER;
    BEGIN
        BEGIN
            SELECT concert_id
              INTO n_concert_band_id
              FROM examen02.concerts_bands
             WHERE concert_id = in_concert_id AND band_id = in_band_id;

            out_response := 0;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                INSERT INTO examen02.concerts_bands (concert_id,
                                                     band_id,
                                                     played_songs,
                                                     band_order)
                     VALUES (in_concert_id,
                             in_band_id,
                             in_played_songs,
                             in_band_order);

                out_response := 1;
        END;
    END insert_concert_band;
END catalog_management_pkg;
/