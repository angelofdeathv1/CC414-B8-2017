CREATE OR REPLACE PACKAGE EXAMEN02.MAIN_PKG
AS
    /******************************************************************************
       NAME:       MAIN_PKG
       PURPOSE:

       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        4/20/2017      aarambula       1. Created this package.
    ******************************************************************************/
    /*1-Registrar a un músico ("Banjo", "Accordion"), asignarlo a la banda con el menor numero de integrantes;
    Mostrar al musico y su nueva banda.*/
    PROCEDURE TEST_01_BANJO (out_cur_musicians OUT SYS_REFCURSOR);

    /*2-Crear un concierto con bandas del género que más conciertos tenga registrados desde 1950;
    Ordenar a las bandas de acuerdo a su promedio de público en sus conciertos (Asumiendo que todos son sold out).
    Mostrar las bandas participantes y su orden.*/
    PROCEDURE TEST_02_BANDS_CONCERT (out_cur_concert OUT SYS_REFCURSOR);

    /*3-Crear una banda con musicos multi instrumentalistas (vivos)
    (6 integrantes - no repetidos,asignarle el instrumento que toco en su primera banda);
    Mostrar a los integrantes de la banda y los diferentes instrumentos que tocan.*/
    PROCEDURE TEST_03_BANDS_INSTRUMENTALISTS (out_cur_band OUT SYS_REFCURSOR);

    /*4-Crear una banda con los cinco compositores con mayor numero de composiciones registradas;
    organizar una gira de conciertos junto a la banda mas reciente de los generos: "Arena Rock", "Chicano" y "J-Pop";
    La gira debe ser por los paises: "Mexico", "Argentina" y "Germany" en venues que tengan una capacidad mayor a 180,000 espectadores.
    Cada fecha se separará por 1 dia, cuando se cambie de país la gira se reanuda hasta el siguiente domingo.
    Mostrar las fechas de la gira y sus venues con su ciudad y país.*/
    PROCEDURE TEST_04_WORLD_TOUR (out_cur_bands OUT SYS_REFCURSOR);
END MAIN_PKG;
/
