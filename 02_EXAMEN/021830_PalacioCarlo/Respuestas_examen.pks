/* Formatted on 21/04/2017 04:36:12 p.m. (QP5 v5.300) */
CREATE OR REPLACE PACKAGE EXAMEN_02_CARLO.Respuestas_Examen2
AS
    /******************************************************************************
       NAME:       Respuestas_Examen2
       PURPOSE:

       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        20/04/2017      rosenblueth       1. Created this package.
    ******************************************************************************/


    PROCEDURE alta_musician (n_music       IN VARCHAR,
                             fecha_nac        DATE,
                             fecha_death      DATE,
                             orig_city     IN NUMBER,
                             resi_city        NUMBER);

    PROCEDURE alta_musician_band (i_id_musician   IN     NUMBER,
                                  i_id_band       IN     NUMBER,
                                  o_mus_band         OUT NUMBER);

    PROCEDURE alta_musician_instrument (i_id_musician_band   IN NUMBER,
                                        i_id_instrument      IN NUMBER,
                                        i_id_genre           IN NUMBER);

    PROCEDURE RECENT_REDNECK (i_id_musician   IN     NUMBER,
                              nu_band            OUT SYS_REFCURSOR);

    PROCEDURE alta_concert (i_con_venue   IN     NUMBER,
                            i_date        IN     DATE,
                            i_org         IN     NUMBER,
                            o_conc           OUT NUMBER);

    PROCEDURE alta_band_concert (i_conc    IN NUMBER,
                                 i_band    IN NUMBER,
                                 i_num     IN NUMBER,
                                 i_order   IN NUMBER);

    PROCEDURE woodstock (i_con_venue IN NUMBER, respuesta OUT SYS_REFCURSOR);

    PROCEDURE alta_banda (i_b_name    IN VARCHAR,
                          i_m_genre   IN NUMBER,
                          i_home      IN NUMBER,
                          i_contact   IN NUMBER,curr_ban out number);
                            
                         
    function first_instrument (i_musician in number) return number;
    procedure super_band (b_name in varchar, respuesta out sys_refcursor);
    procedure virtuoso (b_name in varchar, respuesta out sys_refcursor);
     
END Respuestas_examen2;