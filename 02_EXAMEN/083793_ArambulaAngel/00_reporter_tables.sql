CREATE TABLE REPORTER.CONNECTIONS
(
  CONNECTION_ID      NUMBER,
  CONNECTION_NAME    VARCHAR2(50 BYTE),
  CONNECTION_STRING  VARCHAR2(200 BYTE),
  CONSTRAINT CONNECTIONS_PK
  PRIMARY KEY
  (CONNECTION_ID)
  USING INDEX
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
  ENABLE VALIDATE
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE REPORTER.REPORTS
(
  REPORT_ID      NUMBER,
  REPORT_UUID    VARCHAR2(32 BYTE),
  CONNECTION_ID  NUMBER,
  REPORT_NAME    VARCHAR2(100 BYTE),
  REPORT_FORMAT  VARCHAR2(10 BYTE),
  ACTIVE         CHAR(1 BYTE)                   DEFAULT 1,
  CONSTRAINT REPORTS_PK
  PRIMARY KEY
  (REPORT_ID)
  USING INDEX
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
  ENABLE VALIDATE
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

SET DEFINE OFF;
Insert into REPORTER.CONNECTIONS
   (CONNECTION_ID, CONNECTION_NAME, CONNECTION_STRING)
 Values
   (1, 'TESTINDEX', 'Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=BW-7.bw.com)(PORT=1521))(CONNECT_DATA=(SERVER=dedicated)(SERVICE_NAME=XE)));User Id=testindex;Password=testindex;');
COMMIT;


SET DEFINE OFF;
Insert into REPORTER.REPORTS
   (REPORT_ID, REPORT_UUID, CONNECTION_ID, REPORT_NAME, REPORT_FORMAT, 
    ACTIVE)
 Values
   (1, '1', 1, 'TESTINDEX.REPORTS_PKG.get_org_costs_centers_idx', 'PROCEDURE', 
    '1');
Insert into REPORTER.REPORTS
   (REPORT_ID, REPORT_UUID, CONNECTION_ID, REPORT_NAME, REPORT_FORMAT, 
    ACTIVE)
 Values
   (2, '2', 1, 'TESTINDEX.REPORTS_PKG.get_org_costs_centers_noidx', 'PROCEDURE', 
    '1');
COMMIT;
