/* Formatted on 4/21/2017 9:38:58 PM (QP5 v5.300) */
CREATE OR REPLACE PACKAGE BODY EX2GON.utils
AS
    PROCEDURE insert_musician (mname         IN     VARCHAR2,
                               birth         IN     DATE,
                               death         IN     DATE,
                               origin_city   IN     NUMBER,
                               residence     IN     NUMBER,
                               id_musician      OUT NUMBER)
    IS
        my_seq   NUMBER;
    BEGIN
        SELECT MUDB.musicians_seq.NEXTVAL INTO my_seq FROM DUAL;

        INSERT INTO MUDB.musicians
             VALUES (my_seq,
                     mname,
                     birth,
                     death,
                     origin_city,
                     residence);

        id_musician := my_seq;
    END insert_musician;

    PROCEDURE add_to_band (band_id            IN     NUMBER,
                           musician_id        IN     NUMBER,
                           band_musician_id      OUT NUMBER)
    IS
        my_seq   NUMBER;
    BEGIN
        SELECT MUDB.band_musician_seq.NEXTVAL INTO my_seq FROM DUAL;

        INSERT INTO MUDB.BANDS_MUSICIANS
             VALUES (my_seq, band_id, musician_id);

        band_musician_id := my_seq;
    END add_to_band;

    PROCEDURE add_instrument (band_musician_id   IN NUMBER,
                              instrument_id      IN NUMBER,
                              MUSIC_GENRE_ID     IN NUMBER)
    AS
    BEGIN
        INSERT INTO MUDB.BANDS_MUSICIANS_INSTRUMENTS
             VALUES (band_musician_id, instrument_id, music_genre_id);
    END add_instrument;

    PROCEDURE insert_concert (venue_id       IN     NUMBER,
                              conc_date      IN     DATE,
                              organizer_id   IN     NUMBER,
                              conc_id           OUT NUMBER)
    IS
        my_seq   NUMBER;
    BEGIN
        SELECT MUDB.CONCERTS_SEQ.NEXTVAL INTO my_seq FROM DUAL;

        INSERT INTO MUDB.CONCERTS
             VALUES (my_seq,
                     venue_id,
                     conc_date,
                     conc_id);

        conc_id := my_seq;
    END insert_concert;

    PROCEDURE insert_concert_band (concert      IN NUMBER,
                                   band         IN NUMBER,
                                   songs        IN NUMBER,
                                   band_order   IN NUMBER)
    AS
    BEGIN
        INSERT INTO MUDB.concerts_bands
             VALUES (concert,
                     band,
                     songs,
                     band_order);
    END insert_concert_band;

    PROCEDURE best_bands_genre (out_bands OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN out_bands FOR
              SELECT DISTINCT band_id, avg_assistance
                FROM (SELECT AVG (venue.capacity)
                                 OVER (PARTITION BY band.band_id)
                                 AS avg_assistance,
                             band.band_id,
                             concert.concert_id,
                             venue.capacity
                        FROM MUDB.bands band
                             INNER JOIN MUDB.concerts_bands concert_band
                                 ON band.BAND_ID = concert_band.BAND_ID
                             INNER JOIN MUDB.concerts concert
                                 ON concert.CONCERT_ID =
                                        concert_band.CONCERT_ID
                             INNER JOIN MUDB.concert_venues venue
                                 ON venue.CONCERT_VENUE_ID =
                                        concert.CONCERT_VENUE_ID
                       WHERE music_genre_id =
                                 (SELECT music_genre_id
                                    FROM (  SELECT music_genre_id,
                                                   ROW_NUMBER ()
                                                   OVER (
                                                       ORDER BY
                                                           music_genre_id DESC)
                                                       AS row_num
                                              FROM MUDB.concerts_bands
                                                   concert_band
                                                   INNER JOIN MUDB.bands band
                                                       ON concert_band.BAND_ID =
                                                              band.BAND_ID
                                                   INNER JOIN
                                                   MUDB.concerts concert
                                                       ON concert_band.CONCERT_ID =
                                                              concert.CONCERT_ID
                                             WHERE EXTRACT (
                                                       YEAR FROM concert.CONCERT_DATE) >=
                                                       1950
                                          GROUP BY music_genre_id
                                            HAVING COUNT (
                                                       concert_band.concert_id) =
                                                       (SELECT MAX (
                                                                   num_concerts)
                                                          FROM (SELECT COUNT (
                                                                           concert_band.concert_id)
                                                                       OVER (
                                                                           PARTITION BY music_genre_id)
                                                                           AS num_concerts,
                                                                       music_genre_id
                                                                  FROM MUDB.concerts_bands
                                                                       concert_band
                                                                       INNER JOIN
                                                                       MUDB.bands
                                                                       band
                                                                           ON concert_band.BAND_ID =
                                                                                  band.BAND_ID
                                                                       INNER JOIN
                                                                       MUDB.concerts
                                                                       concert
                                                                           ON concert_band.CONCERT_ID =
                                                                                  concert.CONCERT_ID
                                                                 WHERE EXTRACT (
                                                                           YEAR FROM concert.CONCERT_DATE) >=
                                                                           1950)))
                                   WHERE row_num = 1))
            ORDER BY avg_assistance DESC;
    END best_bands_genre;

    PROCEDURE multi_instru (out_musician OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN out_musician FOR
            SELECT musician_id
              FROM (SELECT multis.*,
                           ROW_NUMBER () OVER (ORDER BY num_instru DESC)
                               AS rnum
                      FROM (SELECT DISTINCT musician_id, num_instru
                              FROM (SELECT COUNT (
                                               instrument_id)
                                           OVER (
                                               PARTITION BY musician.musician_id)
                                               AS num_instru,
                                           musician.musician_id,
                                           band_musician.band_musician_id,
                                           instrument_id
                                      FROM MUDB.musicians  musician
                                           INNER JOIN
                                           MUDB.bands_musicians
                                           band_musician
                                               ON musician.MUSICIAN_ID =
                                                      band_musician.MUSICIAN_ID
                                           INNER JOIN
                                           MUDB.bands_musicians_instruments
                                           instru
                                               ON band_musician.BAND_MUSICIAN_ID =
                                                      instru.BAND_MUSICIAN_ID
                                     WHERE musician.DATE_DIED IS NULL))
                           multis)
             WHERE rnum < 7;
    END multi_instru;

    PROCEDURE first_instru (mus_id IN NUMBER, out_instru OUT NUMBER)
    AS
    BEGIN
        SELECT instrument_id
          INTO out_instru
          FROM (SELECT instrument_id
                  FROM (SELECT old_band.*,
                               instrument_id,
                               ROW_NUMBER () OVER (ORDER BY instrument_id)
                                   AS the_instru
                          FROM (SELECT band.band_id,
                                       musician_id,
                                       ROW_NUMBER ()
                                           OVER (ORDER BY band_creation_date)
                                           AS rnum
                                  FROM MUDB.bands  band
                                       INNER JOIN
                                       MUDB.bands_musicians band_musician
                                           ON band.BAND_ID =
                                                  band_musician.BAND_ID
                                 WHERE band_musician.MUSICIAN_ID = mus_id)
                               old_band
                               INNER JOIN
                               MUDB.bands_musicians band_musician
                                   ON old_band.BAND_ID =
                                          band_musician.BAND_ID
                               INNER JOIN
                               MUDB.bands_musicians_instruments mus_instru
                                   ON band_musician.BAND_MUSICIAN_ID =
                                          mus_instru.BAND_MUSICIAN_ID
                         WHERE rnum = 1)
                 WHERE the_instru = 1);
    END first_instru;

    PROCEDURE insert_band (b_name        IN     VARCHAR2,
                           genre         IN     NUMBER,
                           home          IN     NUMBER,
                           create_date   IN     DATE,
                           contact_id    IN     NUMBER,
                           out_band         OUT NUMBER)
    IS
        my_seq   NUMBER;
    BEGIN
        SELECT MUDB.bands_seq.NEXTVAL INTO my_seq FROM DUAL;

        INSERT INTO MUDB.bands
             VALUES (my_seq,
                     b_name,
                     genre,
                     home,
                     create_date,
                     contact_id);

        out_band := my_seq;
    END insert_band;

    PROCEDURE top_five_composers (out_composers OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN out_composers FOR
            SELECT DISTINCT musician_id
              FROM (  SELECT COUNT (composition_id),
                             musician_id,
                             ROW_NUMBER ()
                                 OVER (ORDER BY COUNT (composition_id) DESC)
                                 AS nrow
                        FROM MUDB.compositions_musicians
                    GROUP BY musician_id)
             WHERE nrow < 6;
    END top_five_composers;

    PROCEDURE big_venues (country IN VARCHAR2, out_venues OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN out_venues FOR
            SELECT venue.concert_venue_id
              FROM MUDB.concert_venues  venue
                   INNER JOIN MUDB.cities city
                       ON venue.CITY_ID = city.CITY_ID
             WHERE city.country_name = country AND venue.capacity > 180000;
    END big_venues;

    PROCEDURE bands_for_concert (out_bands OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN out_bands FOR
            SELECT band_id
              FROM (SELECT band_id,
                           genre.music_genre_id,
                           genre_name,
                           band_creation_date,
                           ROW_NUMBER ()
                           OVER (PARTITION BY genre.genre_name
                                 ORDER BY band_creation_date DESC)
                               AS nrow
                      FROM MUDB.bands  band
                           INNER JOIN MUDB.music_genres genre
                               ON band.MUSIC_GENRE_ID = genre.MUSIC_GENRE_ID
                     WHERE    genre.GENRE_NAME = 'Arena Rock'
                           OR genre.genre_name = 'Chicano'
                           OR genre.genre_name = 'J-Pop')
             WHERE nrow = 1;
    END bands_for_concert;

    PROCEDURE next_sunday (in_date IN DATE, out_date OUT DATE)
    AS
    BEGIN
        SELECT TRUNC (in_date + 6, 'DAY') end_of_week INTO out_date FROM DUAL;
    END next_sunday;

    PROCEDURE add_to_tour (country_venues   IN     SYS_REFCURSOR,
                           in_date          IN     DATE,
                           bands_array      IN     EX2GON.UTILS.list_array,
                           concerts_list       OUT EX2GON.UTILS.list_array,
                           out_date            OUT DATE)
    IS
        kount              NUMBER;
        n_venue            NUMBER;
        curre_date         DATE;
        curre_concert_id   NUMBER;
    BEGIN
        concerts_list := EX2GON.UTILS.list_array ();
        kount := 1;
        curre_date := in_date;

        LOOP
            FETCH country_venues INTO n_venue;

            EXIT WHEN country_venues%NOTFOUND;
            EX2GON.UTILS.INSERT_CONCERT (n_venue,
                                         curre_date,
                                         10,
                                         curre_concert_id);

            concerts_list.EXTEND ();
            concerts_list (kount) := curre_concert_id;
            kount := kount + 1;

            FOR i IN bands_array.FIRST .. bands_array.LAST
            LOOP
                EX2GON.UTILS.INSERT_CONCERT_BAND (curre_concert_id,
                                                  bands_array (i),
                                                  10 - i,
                                                  i);
            END LOOP;

            curre_date := curre_date + 2;
        END LOOP;

        out_date := curre_date;
    END add_to_tour;
END utils;
/