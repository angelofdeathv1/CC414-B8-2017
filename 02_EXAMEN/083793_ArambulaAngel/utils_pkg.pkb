/* Formatted on 4/25/2017 4:27:47 PM (QP5 v5.300) */
CREATE OR REPLACE PACKAGE BODY examen02.utils_pkg
AS
    PROCEDURE get_band_members_instruments (
        in_band_id     IN     INTEGER,
        out_cur_band      OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN out_cur_band FOR
            SELECT b.band_name, m.musician_name, i.instrument_name
              FROM examen02.bands_musicians  b_m
                   INNER JOIN examen02.bands_musicians_instruments b_m_i
                       ON b_m.band_musician_id = b_m_i.band_musician_id
                   INNER JOIN examen02.bands b ON b_m.band_id = b.band_id
                   INNER JOIN examen02.musicians m
                       ON b_m.musician_id = m.musician_id
                   INNER JOIN examen02.instruments i
                       ON b_m_i.instrument_id = i.instrument_id
             WHERE b_m.band_id = in_band_id;
    END get_band_members_instruments;

    PROCEDURE get_bands_by_genre_attendance (
        in_music_genre_id   IN     INTEGER,
        out_cur_bands          OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN out_cur_bands FOR
            SELECT b.band_id,
                   ROW_NUMBER ()
                   OVER (
                       ORDER BY
                           NVL (
                               examen02.utils_pkg.get_band_attendance_avg (
                                   b.band_id),
                               0) ASC)
                       band_rank
              FROM examen02.bands b
             WHERE b.music_genre_id = in_music_genre_id;
    END get_bands_by_genre_attendance;

    PROCEDURE get_concert_bands (in_concert_id   IN     INTEGER,
                                 out_cur_bands      OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN out_cur_bands FOR
              SELECT c_b.concert_id,
                     ci.country_name,
                     ci.city_name,
                     CV.venue_name,
                     co.concert_date,
                     b.band_name,
                     c_b.band_order,
                     c_b.played_songs,
                     b.music_genre_id
                FROM examen02.concerts_bands c_b
                     INNER JOIN examen02.bands b ON c_b.band_id = b.band_id
                     INNER JOIN examen02.concerts co
                         ON c_b.concert_id = co.concert_id
                     INNER JOIN examen02.concert_venues CV
                         ON co.concert_venue_id = CV.concert_venue_id
                     INNER JOIN examen02.cities ci ON CV.city_id = ci.city_id
               WHERE c_b.concert_id = in_concert_id
            ORDER BY concert_id, band_order;
    END get_concert_bands;

    PROCEDURE get_most_recent_bands (in_band_genres   IN     VARCHAR2,
                                     out_cur_bands       OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN out_cur_bands FOR
            SELECT band_id, music_genre_id
              FROM (SELECT b.band_id,
                           b.music_genre_id,
                           ROW_NUMBER ()
                           OVER (PARTITION BY b.music_genre_id
                                 ORDER BY band_creation_date DESC)
                               band_rank
                      FROM examen02.bands  b
                           INNER JOIN examen02.music_genres m_g
                               ON b.music_genre_id = m_g.music_genre_id
                     WHERE m_g.genre_name IN
                               (    SELECT REGEXP_SUBSTR (in_band_genres,
                                                          '[^,]+',
                                                          1,
                                                          LEVEL)
                                      FROM DUAL
                                CONNECT BY REGEXP_SUBSTR (in_band_genres,
                                                          '[^,]+',
                                                          1,
                                                          LEVEL)
                                               IS NOT NULL))
             WHERE band_rank = 1;
    END;

    PROCEDURE get_multi_instrumentalists (
        in_number           IN     INTEGER,
        out_cur_musicians      OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN out_cur_musicians FOR
            SELECT musician_id,
                   examen02.utils_pkg.get_musician_first_instrument (
                       musician_id)
                       instrument_id
              FROM (  SELECT musician_id,
                             ROW_NUMBER () OVER (ORDER BY COUNT (*) DESC)
                                 instrumentalist_rank
                        FROM (  SELECT b_m.musician_id, b_m_i.instrument_id
                                  FROM examen02.bands_musicians b_m
                                       INNER JOIN
                                       examen02.bands_musicians_instruments b_m_i
                                           ON b_m.band_musician_id =
                                                  b_m_i.band_musician_id
                                       INNER JOIN examen02.musicians m
                                           ON b_m.musician_id = m.musician_id
                                 WHERE m.date_died IS NULL
                              GROUP BY b_m.musician_id, b_m_i.instrument_id)
                             m_i
                    GROUP BY musician_id
                      HAVING COUNT (*) > 1)
             WHERE instrumentalist_rank <= in_number;
    END get_multi_instrumentalists;

    PROCEDURE get_top_composers (in_number           IN     INTEGER,
                                 out_cur_composers      OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN out_cur_composers FOR
            SELECT musician_id,
                   examen02.utils_pkg.get_musician_first_instrument (
                       musician_id)
                       instrument_id
              FROM (  SELECT c_m.musician_id,
                             ROW_NUMBER () OVER (ORDER BY COUNT (*) DESC)
                                 composer_rank
                        FROM examen02.compositions_musicians c_m
                    GROUP BY c_m.musician_id)
             WHERE composer_rank <= in_number;
    END get_top_composers;

    PROCEDURE get_top_venues (in_countries        IN     VARCHAR2,
                              in_venue_capacity   IN     INTEGER,
                              out_cur_venues         OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN out_cur_venues FOR
            SELECT CV.concert_venue_id, CV.city_id, c.country_name
              FROM examen02.concert_venues  CV
                   INNER JOIN examen02.cities c ON CV.city_id = c.city_id
             WHERE     capacity >= in_venue_capacity
                   AND c.country_name IN
                           (    SELECT REGEXP_SUBSTR (in_countries,
                                                      '[^,]+',
                                                      1,
                                                      LEVEL)
                                  FROM DUAL
                            CONNECT BY REGEXP_SUBSTR (in_countries,
                                                      '[^,]+',
                                                      1,
                                                      LEVEL)
                                           IS NOT NULL);
    END get_top_venues;

    FUNCTION get_band_attendance_avg (in_band_id IN INTEGER)
        RETURN INTEGER
    AS
        n_attendance_avg   INTEGER;
    BEGIN
          SELECT ROUND (AVG (capacity))
            INTO n_attendance_avg
            FROM examen02.concerts_bands c_b
                 INNER JOIN examen02.concerts c
                     ON c_b.concert_id = c.concert_id
                 INNER JOIN examen02.concert_venues CV
                     ON c.concert_venue_id = CV.concert_venue_id
           WHERE band_id = in_band_id
        GROUP BY band_id;

        RETURN n_attendance_avg;
    END get_band_attendance_avg;

    FUNCTION get_concert_venue_id (in_concert_venue IN VARCHAR2)
        RETURN INTEGER
    AS
        n_concert_venue_id   INTEGER;
    BEGIN
        BEGIN
            SELECT concert_venue_id
              INTO n_concert_venue_id
              FROM examen02.concert_venues
             WHERE     LOWER (venue_name) LIKE LOWER (in_concert_venue)
                   AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                n_concert_venue_id := 1;
        END;

        RETURN n_concert_venue_id;
    END get_concert_venue_id;

    FUNCTION get_instrument_id (in_instrument IN VARCHAR2)
        RETURN INTEGER
    AS
        n_instrument_id   INTEGER;
    BEGIN
        BEGIN
            SELECT instrument_id
              INTO n_instrument_id
              FROM examen02.instruments
             WHERE     LOWER (instrument_name) LIKE LOWER (in_instrument)
                   AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                n_instrument_id := 1;
        END;

        RETURN n_instrument_id;
    END get_instrument_id;

    FUNCTION get_lowest_members_band_id
        RETURN INTEGER
    AS
        n_band_id   INTEGER;
    BEGIN
        BEGIN
            SELECT band_id
              INTO n_band_id
              FROM (  SELECT b_m.band_id,
                             ROW_NUMBER () OVER (ORDER BY COUNT (*) ASC)
                                 band_rank
                        FROM examen02.bands_musicians b_m
                             INNER JOIN
                             examen02.bands_musicians_instruments b_m_i
                                 ON b_m.band_musician_id =
                                        b_m_i.band_musician_id
                    GROUP BY b_m.band_id)
             WHERE band_rank = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                n_band_id := 0;
        END;

        RETURN n_band_id;
    END get_lowest_members_band_id;

    FUNCTION get_most_popular_genre_id (in_date_from IN DATE)
        RETURN INTEGER
    AS
        n_music_genre_id   INTEGER;
    BEGIN
        BEGIN
            SELECT music_genre_id
              INTO n_music_genre_id
              FROM (  SELECT b.music_genre_id,
                             ROW_NUMBER () OVER (ORDER BY COUNT (*) DESC)
                                 genre_rank
                        FROM examen02.concerts c
                             INNER JOIN examen02.concerts_bands c_b
                                 ON c.concert_id = c_b.concert_id
                             INNER JOIN examen02.bands b
                                 ON c_b.band_id = b.band_id
                       WHERE c.concert_date >= in_date_from
                    GROUP BY b.music_genre_id)
             WHERE genre_rank = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                n_music_genre_id := 1;
        END;

        RETURN n_music_genre_id;
    END get_most_popular_genre_id;

    FUNCTION get_music_genre_id (in_music_genre IN VARCHAR2)
        RETURN INTEGER
    AS
        n_music_genre_id   INTEGER;
    BEGIN
        BEGIN
            SELECT music_genre_id
              INTO n_music_genre_id
              FROM examen02.music_genres
             WHERE     LOWER (genre_name) LIKE LOWER (in_music_genre)
                   AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                n_music_genre_id := 1;
        END;

        RETURN n_music_genre_id;
    END get_music_genre_id;

    FUNCTION get_musician_first_instrument (in_musician_id IN INTEGER)
        RETURN INTEGER
    AS
        n_instrument_id   INTEGER;
    BEGIN
        BEGIN
            SELECT instrument_id
              INTO n_instrument_id
              FROM (SELECT i.instrument_id,
                           ROW_NUMBER () OVER (ORDER BY b.band_creation_date)
                               band_rank
                      FROM examen02.bands_musicians  b_m
                           INNER JOIN
                           examen02.bands_musicians_instruments b_m_i
                               ON b_m.band_musician_id =
                                      b_m_i.band_musician_id
                           INNER JOIN examen02.bands b
                               ON b_m.band_id = b.band_id
                           INNER JOIN examen02.instruments i
                               ON b_m_i.instrument_id = i.instrument_id
                     WHERE b_m.musician_id = in_musician_id)
             WHERE band_rank = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                n_instrument_id := 1;
        END;

        RETURN n_instrument_id;
    END get_musician_first_instrument;
END utils_pkg;
/