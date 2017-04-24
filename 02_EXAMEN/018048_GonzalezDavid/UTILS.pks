/* Formatted on 4/21/2017 9:18:41 PM (QP5 v5.300) */
CREATE OR REPLACE PACKAGE EX2GON.utils
AS
    TYPE list_array IS VARRAY (100) OF NUMBER;

    PROCEDURE insert_musician (mname         IN     VARCHAR2,
                               birth         IN     DATE,
                               death         IN     DATE,
                               origin_city   IN     NUMBER,
                               residence     IN     NUMBER,
                               id_musician      OUT NUMBER);


    PROCEDURE insert_band (b_name        IN     VARCHAR2,
                           genre         IN     NUMBER,
                           home          IN     NUMBER,
                           create_date   IN     DATE,
                           contact_id    IN     NUMBER,
                           out_band         OUT NUMBER);

    PROCEDURE add_to_band (band_id            IN     NUMBER,
                           musician_id        IN     NUMBER,
                           band_musician_id      OUT NUMBER);

    PROCEDURE add_instrument (band_musician_id   IN NUMBER,
                              instrument_id      IN NUMBER,
                              MUSIC_GENRE_ID     IN NUMBER);

    PROCEDURE insert_concert (venue_id       IN     NUMBER,
                              conc_date      IN     DATE,
                              organizer_id   IN     NUMBER,
                              conc_id           OUT NUMBER);

    PROCEDURE insert_concert_band (concert      IN NUMBER,
                                   band         IN NUMBER,
                                   songs        IN NUMBER,
                                   band_order   IN NUMBER);

    PROCEDURE best_bands_genre (out_bands OUT SYS_REFCURSOR);

    PROCEDURE multi_instru (out_musician OUT SYS_REFCURSOR);

    PROCEDURE first_instru (mus_id IN NUMBER, out_instru OUT NUMBER);

    PROCEDURE top_five_composers (out_composers OUT SYS_REFCURSOR);

    PROCEDURE big_venues (country IN VARCHAR2, out_venues OUT SYS_REFCURSOR);

    PROCEDURE bands_for_concert (out_bands OUT SYS_REFCURSOR);

    PROCEDURE next_sunday (in_date IN DATE, out_date OUT DATE);

    PROCEDURE add_to_tour (country_venues   IN     SYS_REFCURSOR,
                           in_date          IN     DATE,
                           bands_array      IN     EX2GON.UTILS.list_array,
                           concerts_list       OUT ex2gon.utils.list_array,
                           out_date            OUT DATE);
END utils;
/