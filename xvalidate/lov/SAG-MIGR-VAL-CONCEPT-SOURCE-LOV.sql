CREATE OR REPLACE FUNCTION SAG_FUNC_MIGR_CONC_SOURC_LOV RETURN SYS_REFCURSOR
AS
  c SYS_REFCURSOR;
BEGIN
  OPEN c FOR SELECT CONCEPT_SOURCE FROM 
    (SELECT CONCEPT_SOURCE,
                             DESCRIPTION,
                             CREATED_BY,
                             DATE_CREATED,
                             Nvl (DATE_MODIFIED, DATE_CREATED) DATE_MODIFIED,
                             MODIFIED_BY
                        FROM SBREXT.concept_sources_lov_ext
              UNION ALL
              SELECT OBJ_KEY_DESC CONCEPT_SOURCE,
                             OBJ_KEY_DEF DESCRIPTION,
                             CREAT_USR_ID CREATED_BY,
                             CREAT_DT DATE_CREATED,
                             Nvl (LST_UPD_DT, CREAT_DT) DATE_MODIFIED,
                             LST_UPD_USR_ID MODIFIED_BY
              FROM ONEDATA_WA.OBJ_KEY where OBJ_TYP_ID=23) t
      GROUP BY CONCEPT_SOURCE,
                     DESCRIPTION,
                     CREATED_BY,
                     DATE_CREATED,
                     DATE_MODIFIED,
                     MODIFIED_BY
      HAVING COUNT (*) <> 2
      ORDER BY CONCEPT_SOURCE;
  RETURN c;
END;
/
GRANT EXECUTE ON ONEDATA_WA.SAG_FUNC_MIGR_CONC_SOURC_LOV to SBREXT;