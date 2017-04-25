VARIABLE rc REFCURSOR;
EXEC examen02.main_pkg.test_01_banjo(:rc)
PRINT rc;

VARIABLE rc REFCURSOR;
EXEC examen02.main_pkg.test_02_bands_concert(:rc)
PRINT rc;

VARIABLE rc REFCURSOR;
EXEC examen02.main_pkg.test_03_bands_instrumentalists(:rc)
PRINT rc;

VARIABLE rc REFCURSOR;
EXEC examen02.main_pkg.test_04_world_tour(:rc)
PRINT rc;