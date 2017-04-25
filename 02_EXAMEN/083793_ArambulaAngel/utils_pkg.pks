/* Formatted on 4/25/2017 4:27:43 PM (QP5 v5.300) */
CREATE OR REPLACE PACKAGE examen02.utils_pkg
AS
    PROCEDURE get_band_members_instruments (
        in_band_id     IN     INTEGER,
        out_cur_band      OUT SYS_REFCURSOR);

    PROCEDURE get_bands_by_genre_attendance (
        in_music_genre_id   IN     INTEGER,
        out_cur_bands          OUT SYS_REFCURSOR);

    PROCEDURE get_concert_bands (in_concert_id   IN     INTEGER,
                                 out_cur_bands      OUT SYS_REFCURSOR);


    PROCEDURE get_most_recent_bands (in_band_genres   IN     VARCHAR2,
                                     out_cur_bands       OUT SYS_REFCURSOR);

    PROCEDURE get_multi_instrumentalists (
        in_number           IN     INTEGER,
        out_cur_musicians      OUT SYS_REFCURSOR);

    PROCEDURE get_top_composers (in_number           IN     INTEGER,
                                 out_cur_composers      OUT SYS_REFCURSOR);

    PROCEDURE get_top_venues (in_countries        IN     VARCHAR2,
                              in_venue_capacity   IN     INTEGER,
                              out_cur_venues         OUT SYS_REFCURSOR);

    FUNCTION get_band_attendance_avg (in_band_id IN INTEGER)
        RETURN INTEGER;

    FUNCTION get_concert_venue_id (in_concert_venue IN VARCHAR2)
        RETURN INTEGER;

    FUNCTION get_instrument_id (in_instrument IN VARCHAR2)
        RETURN INTEGER;

    FUNCTION get_lowest_members_band_id
        RETURN INTEGER;

    FUNCTION get_most_popular_genre_id (in_date_from IN DATE)
        RETURN INTEGER;

    FUNCTION get_music_genre_id (in_music_genre IN VARCHAR2)
        RETURN INTEGER;

    FUNCTION get_musician_first_instrument (in_musician_id IN INTEGER)
        RETURN INTEGER;
END utils_pkg;