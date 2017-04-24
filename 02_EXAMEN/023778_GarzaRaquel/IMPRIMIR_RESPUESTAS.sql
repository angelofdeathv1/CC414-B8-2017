/*
1-Registrar a un músico (Banjo, Accordion), asignarlo a la banda con el menor numero de integrantes;
*/

VARIABLE RC REFCURSOR;
EXEC EX2RGG.RESPUESTAS_EXAMEN02.RESPUESTA_01(:RC)
PRINT RC;

/*
2-Crear un concierto con bandas del género que más conciertos tenga registrados desde 1950;
Ordenar a las bandas de acuerdo a su promedio de público en sus conciertos (Asumiendo que todos son sold out).
Mostrar las bandas participantes y su orden.
*/

VARIABLE RC REFCURSOR;
EXEC EX2RGG.RESPUESTAS_EXAMEN02.RESPUESTA_02(:RC)
PRINT RC;

/*
3-Crear una banda con musicos multi instrumentalistas (vivos)
(6 integrantes - no repetidos,asignarle el instrumento que toco en su primera banda); 
mostrar a los integrantes de la banda y los diferentes instrumentos que tocan.
*/

VARIABLE RC REFCURSOR;
EXEC EX2RGG.RESPUESTAS_EXAMEN02.RESPUESTA_03(:RC)
PRINT RC;

/*
4-Crear una banda con los cinco compositores con mayor numero de composiciones registradas; 
organizar una gira de conciertos junto a la banda mas reciente de los generos: "Arena Rock", "Chicano" y "J-Pop";
La gira debe ser por los paises: "Mexico", "Argentina" y "Germany" en venues que tengan una capacidad mayor a 180,000 espectadores.
Cada fecha se separará por 1 dia, cuando se cambie de país la gira se reanuda hasta el siguiente domingo.
Mostrar las fechas de la gira y sus venues con su ciudad y país.
*/

VARIABLE RC REFCURSOR;
EXEC EX2RGG.RESPUESTAS_EXAMEN02.RESPUESTA_04(:RC)
PRINT RC;