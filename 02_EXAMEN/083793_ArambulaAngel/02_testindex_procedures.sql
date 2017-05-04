CREATE OR REPLACE PACKAGE TESTINDEX.reports_pkg
AS
    PROCEDURE get_org_costs_centers_idx (
        in_s_organization   IN     VARCHAR2,
        out_c_rpt_data         OUT SYS_REFCURSOR,
        out_s_result           OUT VARCHAR2);

    PROCEDURE get_org_costs_centers_idx (
        in_d_date_from   IN     DATE,
        in_d_date_to     IN     DATE,
        out_c_rpt_data      OUT SYS_REFCURSOR,
        out_s_result        OUT VARCHAR2);

    PROCEDURE get_org_costs_centers_noidx (
        in_s_organization   IN     VARCHAR2,
        out_c_rpt_data         OUT SYS_REFCURSOR,
        out_s_result           OUT VARCHAR2);

    PROCEDURE get_org_costs_centers_noidx (
        in_d_date_from   IN     DATE,
        in_d_date_to     IN     DATE,
        out_c_rpt_data      OUT SYS_REFCURSOR,
        out_s_result        OUT VARCHAR2);
END reports_pkg;
/
CREATE OR REPLACE PACKAGE BODY TESTINDEX.reports_pkg
AS
    PROCEDURE get_org_costs_centers_idx (
        in_s_organization   IN     VARCHAR2,
        out_c_rpt_data         OUT SYS_REFCURSOR,
        out_s_result           OUT VARCHAR2)
    IS
    BEGIN
        out_s_result := 'OK';

        OPEN out_c_rpt_data FOR
            SELECT st.organization, oi.cost_center, st.serialnumber
              FROM testindex.bigtable_with_index  st
                   INNER JOIN testindex.org_info oi
                       ON oi.organization = st.organization
             WHERE st.organization = in_s_organization;
    END get_org_costs_centers_idx;

    PROCEDURE get_org_costs_centers_idx (
        in_d_date_from   IN     DATE,
        in_d_date_to     IN     DATE,
        out_c_rpt_data      OUT SYS_REFCURSOR,
        out_s_result        OUT VARCHAR2)
    IS
    BEGIN
        out_s_result := 'OK';

        OPEN out_c_rpt_data FOR
            SELECT st.organization,
                   oi.cost_center,
                   st.serialnumber,
                   st.partnumber,
                   st.creationdate
              FROM testindex.bigtable_with_index  st
                   INNER JOIN testindex.org_info oi
                       ON oi.organization = st.organization
             WHERE st.creationdate BETWEEN in_d_date_from AND in_d_date_to;
    END get_org_costs_centers_idx;

    PROCEDURE get_org_costs_centers_noidx (
        in_s_organization   IN     VARCHAR2,
        out_c_rpt_data         OUT SYS_REFCURSOR,
        out_s_result           OUT VARCHAR2)
    IS
    BEGIN
        out_s_result := 'OK';

        OPEN out_c_rpt_data FOR
            SELECT st.organization, oi.cost_center, st.serialnumber
              FROM testindex.bigtable  st
                   INNER JOIN testindex.org_info oi
                       ON oi.organization = st.organization
             WHERE st.organization = in_s_organization;
    END get_org_costs_centers_noidx;

    PROCEDURE get_org_costs_centers_noidx (
        in_d_date_from   IN     DATE,
        in_d_date_to     IN     DATE,
        out_c_rpt_data      OUT SYS_REFCURSOR,
        out_s_result        OUT VARCHAR2)
    IS
    BEGIN
        out_s_result := 'OK';

        OPEN out_c_rpt_data FOR
            SELECT st.organization,
                   oi.cost_center,
                   st.serialnumber,
                   st.partnumber,
                   st.creationdate
              FROM testindex.bigtable  st
                   INNER JOIN testindex.org_info oi
                       ON oi.organization = st.organization
             WHERE st.creationdate BETWEEN in_d_date_from AND in_d_date_to;
    END get_org_costs_centers_noidx;
END reports_pkg;
/
