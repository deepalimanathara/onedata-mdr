create or replace FUNCTION SAG_FUNC_MIGR_CSI_TYPES_LOV RETURN SYS_REFCURSOR
AS
  c SYS_REFCURSOR;
BEGIN
  OPEN c FOR SELECT CSITL_NAME FROM 
    (SELECT CSITL_NAME,
                             DESCRIPTION,
                             COMMENTS,
                             CREATED_BY,
                             DATE_CREATED,
                             Nvl (DATE_MODIFIED, DATE_CREATED) DATE_MODIFIED,
                             MODIFIED_BY
                        FROM sbr.CSI_TYPES_LOV
              UNION ALL
              SELECT OBJ_KEY_DESC CSITL_NAME,
                             OBJ_KEY_DEF DESCRIPTION,
                             OBJ_KEY_CMNTS COMMENTS,
                             CREAT_USR_ID CREATED_BY,
                             CREAT_DT DATE_CREATED,
                             Nvl (LST_UPD_DT, CREAT_DT) DATE_MODIFIED,
                             LST_UPD_USR_ID MODIFIED_BY
              FROM ONEDATA_WA.OBJ_KEY where OBJ_TYP_ID=20) t
      GROUP BY CSITL_NAME,
                     DESCRIPTION,
                     COMMENTS,
                     CREATED_BY,
                     DATE_CREATED,
                     DATE_MODIFIED,
                     MODIFIED_BY
      HAVING COUNT (*) <> 2
      ORDER BY CSITL_NAME;
  RETURN c;
END;
/
GRANT EXECUTE ON ONEDATA_WA.SAG_FUNC_MIGR_CSI_TYPES_LOV to SBREXT;