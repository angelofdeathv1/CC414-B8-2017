# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models


class Bands(models.Model):
    band_id = models.FloatField(primary_key=True)
    band_name = models.CharField(max_length=100, blank=True, null=True)
    music_genre = models.ForeignKey('MusicGenres', models.DO_NOTHING, blank=True, null=True)
    band_home = models.ForeignKey('Cities', models.DO_NOTHING, blank=True, null=True)
    band_creation_date = models.DateField(blank=True, null=True)
    contact_musician = models.ForeignKey('Musicians', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'bands'


class BandsMusicians(models.Model):
    band_musician_id = models.FloatField(primary_key=True)
    band = models.ForeignKey(Bands, models.DO_NOTHING, blank=True, null=True)
    musician = models.ForeignKey('Musicians', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'bands_musicians'


class BandsMusiciansInstruments(models.Model):
    band_musician_id = models.FloatField()
    instrument = models.ForeignKey('Instruments', models.DO_NOTHING, primary_key=True)
    music_genre = models.ForeignKey('MusicGenres', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'bands_musicians_instruments'
        unique_together = (('instrument', 'band_musician_id'),)


class Cities(models.Model):
    city_id = models.FloatField(primary_key=True)
    city_name = models.CharField(max_length=100, blank=True, null=True)
    country_name = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'cities'


class Compositions(models.Model):
    composition_id = models.FloatField(primary_key=True)
    composition_title = models.CharField(max_length=100, blank=True, null=True)
    composition_date = models.DateField(blank=True, null=True)
    composed_city = models.ForeignKey(Cities, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'compositions'


class CompositionsMusicians(models.Model):
    composition = models.ForeignKey(Compositions, models.DO_NOTHING, blank=True, null=True)
    musician = models.ForeignKey('Musicians', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'compositions_musicians'


class ConcertVenues(models.Model):
    concert_venue_id = models.FloatField(primary_key=True)
    venue_name = models.CharField(max_length=100, blank=True, null=True)
    city = models.ForeignKey(Cities, models.DO_NOTHING, blank=True, null=True)
    opened_date = models.DateField(blank=True, null=True)
    capacity = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'concert_venues'


class Concerts(models.Model):
    concert_id = models.FloatField(primary_key=True)
    concert_venue = models.ForeignKey(ConcertVenues, models.DO_NOTHING, blank=True, null=True)
    concert_date = models.DateField(blank=True, null=True)
    concert_organizer = models.ForeignKey('Musicians', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'concerts'


class ConcertsBands(models.Model):
    concert = models.ForeignKey(Concerts, models.DO_NOTHING, primary_key=True)
    band = models.ForeignKey(Bands, models.DO_NOTHING)
    played_songs = models.FloatField(blank=True, null=True)
    band_order = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'concerts_bands'
        unique_together = (('concert', 'band'),)


class Instruments(models.Model):
    instrument_id = models.FloatField(primary_key=True)
    instrument_name = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'instruments'


class MusicGenres(models.Model):
    music_genre_id = models.FloatField(primary_key=True)
    genre_name = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'music_genres'


class Musicians(models.Model):
    musician_id = models.FloatField(primary_key=True)
    musician_name = models.CharField(max_length=100, blank=True, null=True)
    date_birth = models.DateField(blank=True, null=True)
    date_died = models.DateField(blank=True, null=True)
    origin_city = models.ForeignKey(Cities, models.DO_NOTHING, blank=True, null=True)
    residence_city = models.ForeignKey(Cities, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'musicians'
