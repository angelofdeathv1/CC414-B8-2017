CREATE OR REPLACE PACKAGE JAVIER2.lastProblem_Pkg
AS
    PROCEDURE theGoodOne (salida OUT SYS_REFCURSOR);
    PROCEDURE getInstrument(musico NUMBER, salida OUT NUMBER);
    PROCEDURE dominguito(fecha DATE, domingo out DATE);
END lastProblem_Pkg;
/