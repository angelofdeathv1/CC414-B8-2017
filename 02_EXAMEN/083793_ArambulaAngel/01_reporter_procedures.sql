CREATE OR REPLACE PACKAGE REPORTER.ia_rpt_configuration_pkg
AS
    PROCEDURE get_report_configuration (
        in_n_rpt_id      IN     INTEGER,
        out_s_result        OUT VARCHAR2,
        out_c_rpt_data      OUT SYS_REFCURSOR);
END ia_rpt_configuration_pkg;
/
CREATE OR REPLACE PACKAGE BODY REPORTER.ia_rpt_configuration_pkg
AS
    PROCEDURE get_report_configuration (
        in_n_rpt_id      IN     INTEGER,
        out_s_result        OUT VARCHAR2,
        out_c_rpt_data      OUT SYS_REFCURSOR)
    AS
    BEGIN
        out_s_result := 'OK';

        OPEN out_c_rpt_data FOR
            SELECT rep.connection_id     AS id_connection,
                   rep.report_id         AS id_rpt,
                   con.connection_name   AS name,
                   con.connection_string AS connection_string,
                   rep.report_format     AS rpt_datasource_format,
                   rep.report_name       AS rpt_datasource_qry
              FROM reporter.reports  rep
                   INNER JOIN reporter.connections con
                       ON rep.connection_id = con.connection_id;
    END get_report_configuration;
END ia_rpt_configuration_pkg;
/
