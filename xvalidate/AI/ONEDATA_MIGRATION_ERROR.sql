CREATE TABLE SBREXT.ONEDATA_MIGRATION_ERROR
(
  ERR_ID          NUMBER,
  IDSEQ           VARCHAR2(50 BYTE),
  PUBLIC_ID       NUMBER,
  VERSION         NUMBER(4,2),
  ACTL_NAME       VARCHAR2(50 BYTE),
  PREFERRED_NAME  VARCHAR2(400 BYTE),
  ERROR_DESC      VARCHAR2(50 BYTE),
  DATE_CREATED    DATE                          DEFAULT Sysdate,
  CREATED_BY      VARCHAR2(50 BYTE)             DEFAULT User,
  DESTINATION     VARCHAR2(50 BYTE),
  TIER            VARCHAR2(50 BYTE)
)
TABLESPACE SBREXT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;


CREATE OR REPLACE PUBLIC SYNONYM ONEDATA_MIGRATION_ERROR FOR SBREXT.ONEDATA_MIGRATION_ERROR;


GRANT ALL ON SBREXT.ONEDATA_MIGRATION_ERROR TO ONEDATA_RA;

GRANT ALL ON SBREXT.ONEDATA_MIGRATION_ERROR TO ONEDATA_WA;
