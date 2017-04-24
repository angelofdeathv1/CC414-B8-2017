/* Formatted on 4/23/2017 11:22:16 PM (QP5 v5.300) */
DECLARE
    result     SYS_REFCURSOR;

    n1         VARCHAR (100);                        -- guessing the data type
    n2         VARCHAR (100);
    n3         VARCHAR (100);
    k2         NUMBER;
    k3         NUMBER;

    c_name     VARCHAR (100);
    cty_name   VARCHAR (100);
    b_name     VARCHAR (100);
    c_date     DATE;
BEGIN
    -- RESULTADO DEL PROCEDIMIENTO 1
    EXAMEN_02_CARLO.RESPUESTAS_EXAMEN2.RECENT_REDNECK (1, result);

    LOOP
        FETCH result INTO n1, n2, n3;           -- and other columns if needed

        EXIT WHEN result%NOTFOUND;
        DBMS_OUTPUT.put_line (n1 || n2 || n3);
    END LOOP;

    -- RESULTADO DEL PROCEDIMIENTO 2

    EXAMEN_02_CARLO.RESPUESTAS_EXAMEN2.woodstock (20, result);

    LOOP
        FETCH result INTO n1, k2, k3;           -- and other columns if needed

        EXIT WHEN result%NOTFOUND;
        DBMS_OUTPUT.put_line (n1 || k2 || k3);
    END LOOP;

    -- RESULTADO DEL PROCEDIMIENTO 3

    EXAMEN_02_CARLO.RESPUESTAS_EXAMEN2.super_band ('Los Moonlight', result);

    LOOP
        FETCH result INTO n1, n2, n3;

        EXIT WHEN result%NOTFOUND;
        DBMS_OUTPUT.put_line (n1 || n2 || n3);
    END LOOP;

    -- RESULTADO DEL PROCEDIMIENTO 4

    EXAMEN_02_CARLO.RESPUESTAS_EXAMEN2.virtuoso ('B r o n c o w a v e',
                                                 result);

    LOOP
        FETCH result
            INTO c_name,
                 cty_name,
                 b_name,
                 c_date;

        DBMS_OUTPUT.put_line (
            c_name || ' ' || cty_name || ' ' || b_name || ' ' || c_date);
        EXIT WHEN result%NOTFOUND;
    END LOOP;
END;