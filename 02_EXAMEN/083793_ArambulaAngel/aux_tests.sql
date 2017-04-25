SELECT b.band_name, m.musician_name, i.instrument_name
  FROM examen02.bands_musicians  b_m
       LEFT OUTER JOIN examen02.bands_musicians_instruments b_m_i
           ON b_m.band_musician_id = b_m_i.band_musician_id
       LEFT OUTER JOIN examen02.bands b ON b_m.band_id = b.band_id
       LEFT OUTER JOIN examen02.musicians m
           ON b_m.musician_id = m.musician_id
       LEFT OUTER JOIN examen02.instruments i
           ON b_m_i.instrument_id = i.instrument_id
 WHERE b_m.band_id = 1001;

SELECT *
  FROM examen02.bands_musicians
 WHERE band_id = 51;

SELECT *
  FROM examen02.bands_musicians
 WHERE band_musician_id = 1437;

SELECT examen02.utils_pkg.get_lowest_members_band_id (),
       examen02.utils_pkg.get_instrument_id ('BANJO'),
       examen02.utils_pkg.get_instrument_id ('ACCORDION'),
       examen02.utils_pkg.get_most_popular_genre_id (SYSDATE)
  FROM DUAL;

SELECT * FROM examen02.music_genres;

SELECT * FROM examen02.musicians;

  SELECT b_m.band_id,
         COUNT (*),
         ROW_NUMBER () OVER (ORDER BY COUNT (*) ASC) band_rank
    FROM examen02.bands_musicians b_m
         INNER JOIN examen02.bands_musicians_instruments b_m_i
             ON b_m.band_musician_id = b_m_i.band_musician_id
GROUP BY b_m.band_id;

  SELECT music_genre_id,
         COUNT (*),
         ROW_NUMBER () OVER (ORDER BY COUNT (*) DESC) genre_rank
    FROM examen02.concerts c
         INNER JOIN examen02.concerts_bands c_b
             ON c.concert_id = c_b.concert_id
         INNER JOIN examen02.bands b ON c_b.band_id = b.band_id
   WHERE c.concert_date >= '01-JAN-1950'
GROUP BY music_genre_id;

  SELECT c_b.concert_id,
         ci.country_name,
         ci.city_name,
         CV.venue_name,
         co.concert_date,
         b.band_name,
         c_b.band_order,
         c_b.played_songs
    FROM examen02.concerts_bands c_b
         INNER JOIN examen02.bands b ON c_b.band_id = b.band_id
         INNER JOIN examen02.concerts co ON c_b.concert_id = co.concert_id
         INNER JOIN examen02.concert_venues CV
             ON co.concert_venue_id = CV.concert_venue_id
         INNER JOIN examen02.cities ci ON CV.city_id = ci.city_id
--WHERE c_b.concert_id = 887
ORDER BY concert_id, band_order;

SELECT examen02.utils_pkg.get_band_attendance_avg (696) FROM DUAL;

SELECT ROUND (DBMS_RANDOM.VALUE (0, 15)) FROM DUAL;

SELECT b.band_id,
       b.band_name,
       b.music_genre_id,
       ROW_NUMBER ()
       OVER (
           ORDER BY
               NVL (examen02.utils_pkg.get_band_attendance_avg (b.band_id),
                    0) DESC)
           band_rank
  FROM examen02.bands b
 WHERE b.music_genre_id = :in_music_genre_id;

SELECT * FROM examen02.concert_venues;

SELECT b.band_id,
       b.band_name,
       b.music_genre_id,
       attendance.att_avg
  FROM examen02.bands  b
       INNER JOIN
       (  SELECT band_id, ROUND (AVG (capacity)) att_avg
            FROM examen02.concerts_bands c_b
                 INNER JOIN examen02.concerts c
                     ON c_b.concert_id = c.concert_id
                 INNER JOIN examen02.concert_venues CV
                     ON c.concert_venue_id = CV.concert_venue_id
        GROUP BY band_id) attendance
           ON b.band_id = attendance.band_id
 WHERE b.music_genre_id = :in_music_genre_id;



VARIABLE rc REFCURSOR;
EXEC examen02.utils_pkg.get_multi_instrumentalists (6,:rc)
                                 PRINT rc;


SELECT i.instrument_id,
       ROW_NUMBER () OVER (ORDER BY b.band_creation_date) band_rank
  FROM examen02.bands_musicians  b_m
       INNER JOIN examen02.bands_musicians_instruments b_m_i
           ON b_m.band_musician_id = b_m_i.band_musician_id
       INNER JOIN examen02.bands b ON b_m.band_id = b.band_id
       INNER JOIN examen02.instruments i
           ON b_m_i.instrument_id = i.instrument_id
 WHERE b_m.musician_id = 733;

SELECT examen02.utils_pkg.get_musician_first_instrument (733) FROM DUAL;

SELECT musician_id
  FROM (  SELECT musician_id,
                 COUNT (*),
                 ROW_NUMBER () OVER (ORDER BY COUNT (*) DESC)
                     instrumentalist_rank
            FROM (  SELECT b_m.musician_id, b_m_i.instrument_id
                      FROM examen02.bands_musicians b_m
                           INNER JOIN examen02.bands_musicians_instruments b_m_i
                               ON b_m.band_musician_id = b_m_i.band_musician_id
                           INNER JOIN examen02.musicians m
                               ON b_m.musician_id = m.musician_id
                     WHERE m.date_died IS NULL
                  GROUP BY b_m.musician_id, b_m_i.instrument_id) m_i
        GROUP BY musician_id
          HAVING COUNT (*) > 1)
 WHERE instrumentalist_rank <= 6;

SELECT * FROM examen02.bands;