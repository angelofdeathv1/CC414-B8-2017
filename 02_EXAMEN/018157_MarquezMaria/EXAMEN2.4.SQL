/*
4-Crear una banda con los cinco compositores con mayor numero de composiciones registradas; 
organizar una gira de conciertos junto a la banda mas reciente de los generos: "Arena Rock", "Chicano" y "J-Pop";
La gira debe ser por los paises: "Mexico", "Argentina" y "Germany" en venues que tengan una capacidad mayor a 180,000 espectadores.
Cada fecha se separará por 1 dia, cuando se cambie de país la gira se reanuda hasta el siguiente domingo.
Mostrar las fechas de la gira y sus venues con su ciudad y país.
*/

CREATE OR REPLACE PACKAGE EX2MAR.NUM4
AS
    PROCEDURE MAKE;
END NUM4;

CREATE OR REPLACE PACKAGE BODY EX2MAR.NUM4
AS
    PROCEDURE MAKE
    AS
    BEGIN
        NULL;
    END MAKE;
END NUM4;

INSERT INTO MUDB.CONCERTS (CONCERT_ID,
                               CONCERT_VENUE_ID,
                               CONCERT_DATE,
                               CONCERT_ORGANIZER_ID)
     VALUES (TEMPCID,
             80,
             SYSDATE,
             7);