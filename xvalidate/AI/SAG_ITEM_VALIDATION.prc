CREATE OR REPLACE PROCEDURE ONEDATA_WA.SAG_ITEM_VALIDATION
AS
BEGIN
    /*****************************************************
    Created By : Akhilesh Trikha
    Created on : 06/24/2020
    Version: 1.0
    Details: Validate SBR and SBREXT tables
    Update History:

    *****************************************************/
    -- Validate sbr.DATA_ELEMENTS
    FOR x
        IN (  SELECT DISTINCT ITEM_ID,                          --Primary Keys
                                       VER_NR
                FROM (SELECT ITEM_ID,
                             VER_NR,
                             CREAT_DT,
                             CREAT_USR_ID,
                             LST_UPD_USR_ID,
                             TO_CHAR (REPLACE (FLD_DELETE, 0, 'No'))
                                 FLD_DELETE,
                             LST_UPD_DT
                        FROM ONEDATA_WA.DE
                       WHERE item_id <> -20005
                      UNION ALL
                      SELECT CDE_ID,
                             VERSION,
                             DATE_CREATED,
                             CREATED_BY,
                             MODIFIED_BY,
                             DELETED_IND,
                             NVL (DATE_MODIFIED, DATE_CREATED)
                        FROM sbr.data_elements) t
            GROUP BY ITEM_ID,
                     VER_NR,
                     CREAT_DT,
                     CREAT_USR_ID,
                     LST_UPD_USR_ID,
                     FLD_DELETE,
                     LST_UPD_DT
              HAVING COUNT (*) <> 2
            ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   DE_IDSEQ,
                   CDE_ID,
                   VERSION,
                   'DATAELEMENTS',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'DE'
              FROM sbr.data_elements
             WHERE CDE_id = x.ITEM_ID AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate CONTEXTS
    FOR x IN (  SELECT DISTINCT ITEM_ID,                        --Primary Keys
                                         VER_NR
                  FROM (SELECT ITEM_ID,
                               VER_NR,
                               LANG_ID,
                               CREAT_USR_ID,
                               CREAT_DT,
                               LST_UPD_DT,
                               LST_UPD_USR_ID
                          FROM onedata_wa.CNTXT
                         WHERE item_id <> -20005
                        UNION ALL
                        SELECT ai.ITEM_ID,
                               version,
                               1000,
                               created_by,
                               date_created,
                               NVL (date_modified, date_created),
                               modified_by
                          FROM sbr.contexts c, admin_item ai
                         WHERE TRIM (ai.NCI_IDSEQ) = TRIM (c.conte_idseq)
                          and ai.admin_item_typ_id = 8) t
              GROUP BY ITEM_ID,
                       VER_NR,
                       LANG_ID,
                       CREAT_USR_ID,
                       CREAT_DT,
                       LST_UPD_DT,
                       LST_UPD_USR_ID
                HAVING COUNT (*) <> 2
              ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   CONTE_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'CONTEXTS',
                   NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'CNTXT'
              FROM sbr.contexts c, admin_item ai
             WHERE     TRIM (ai.NCI_IDSEQ) = TRIM (c.conte_idseq)
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    -- Validate CONCEPTUAL_DOMAINS
    FOR x IN (  SELECT DISTINCT ITEM_ID,                        --Primary Keys
                                         VER_NR
                  FROM (SELECT ITEM_ID,
                               VER_NR,
                               DIMNSNLTY,
                               CREAT_USR_ID,
                               CREAT_DT,
                               LST_UPD_DT,
                               LST_UPD_USR_ID
                          FROM onedata_wa.CONC_DOM
                         WHERE item_id <> -20002
                        UNION ALL
                        SELECT ai.ITEM_ID,
                               version,
                               dimensionality,
                               created_by,
                               date_created,
                               NVL (date_modified, date_created),
                               modified_by
                          FROM sbr.conceptual_domains c, admin_item ai
                         WHERE TRIM (ai.NCI_IDSEQ) = TRIM (c.cd_idseq)) t
              GROUP BY ITEM_ID,
                       VER_NR,
                       DIMNSNLTY,
                       CREAT_USR_ID,
                       CREAT_DT,
                       LST_UPD_DT,
                       LST_UPD_USR_ID
                HAVING COUNT (*) <> 2
              ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   CONTE_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'CONCEPTUAL_DOMAINS',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'CONC_DOM'
              FROM sbr.conceptual_domains c, admin_item ai
             WHERE     TRIM (ai.NCI_IDSEQ) = TRIM (c.cd_idseq)
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    -- Validate OBJECT_CLASSES_EXT
    FOR x IN (  SELECT DISTINCT ITEM_ID,                        --Primary Keys
                                         VER_NR
                  FROM (SELECT ITEM_ID,
                               VER_NR,
                               CREAT_USR_ID,
                               CREAT_DT,
                               LST_UPD_DT,
                               LST_UPD_USR_ID
                          FROM onedata_wa.OBJ_CLS
                         WHERE item_id <> -20000
                        UNION ALL
                        SELECT ai.ITEM_ID,
                               version,
                               created_by,
                               date_created,
                               NVL (date_modified, date_created),
                               modified_by
                          FROM sbrext.OBJECT_CLASSES_EXT c, admin_item ai
                         WHERE TRIM (ai.NCI_IDSEQ) = TRIM (c.oc_idseq)) t
              GROUP BY ITEM_ID,
                       VER_NR,
                       CREAT_USR_ID,
                       CREAT_DT,
                       LST_UPD_DT,
                       LST_UPD_USR_ID
                HAVING COUNT (*) <> 2
              ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   OC_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'OBJECT_CLASSES_EXT',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'OBJ_CLS'
              FROM sbrext.object_classes_ext c, admin_item ai
             WHERE     TRIM (ai.NCI_IDSEQ) = TRIM (c.oc_idseq)
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate PROPERTIES_EXT
    FOR x IN (  SELECT DISTINCT ITEM_ID,                        --Primary Keys
                                         VER_NR
                  FROM (SELECT ITEM_ID,
                               VER_NR,
                               CREAT_USR_ID,
                               CREAT_DT,
                               LST_UPD_DT,
                               LST_UPD_USR_ID
                          FROM onedata_wa.PROP
                         WHERE item_id <> -20001
                        UNION ALL
                        SELECT ai.ITEM_ID,
                               version,
                               created_by,
                               date_created,
                               NVL (date_modified, date_created),
                               modified_by
                          FROM sbrext.properties_ext c, admin_item ai
                         WHERE TRIM (ai.NCI_IDSEQ) = TRIM (c.PROP_idseq)) t
              GROUP BY ITEM_ID,
                       VER_NR,
                       CREAT_USR_ID,
                       CREAT_DT,
                       LST_UPD_DT,
                       LST_UPD_USR_ID
                HAVING COUNT (*) <> 2
              ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   PROP_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'PROPERTIES_EXT',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'PROP'
              FROM sbrext.properties_ext c, admin_item ai
             WHERE     TRIM (ai.NCI_IDSEQ) = TRIM (c.PROP_idseq)
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    -- Validate CLASSIFICATION_SCHEMES
    FOR x
        IN (  SELECT DISTINCT ITEM_ID,                          --Primary Keys
                                       VER_NR
                FROM (SELECT ITEM_ID,
                             VER_NR,
                             CLSFCTN_SCHM_TYP_ID,
                             NCI_LABEL_TYP_FLG,
                             CREAT_USR_ID,
                             CREAT_DT,
                             LST_UPD_DT,
                             LST_UPD_USR_ID
                        FROM onedata_wa.CLSFCTN_SCHM
                      UNION ALL
                      SELECT ai.ITEM_ID,
                             version,
                             ok.obj_key_id,
                             label_type_flag,
                             created_by,
                             date_created,
                             NVL (date_modified, date_created),
                             modified_by
                        FROM sbr.classification_schemes c,
                             admin_item                ai,
                             obj_key                   ok
                       WHERE     TRIM (ai.NCI_IDSEQ) = TRIM (c.CS_idseq)
                             AND TRIM (cstl_name) = ok.nci_cd
                             AND ok.obj_typ_id = 3) t
            GROUP BY ITEM_ID,
                     VER_NR,
                     CLSFCTN_SCHM_TYP_ID,
                     NCI_LABEL_TYP_FLG,
                     CREAT_USR_ID,
                     CREAT_DT,
                     LST_UPD_DT,
                     LST_UPD_USR_ID
              HAVING COUNT (*) <> 2
            ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   CS_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'CLASSIFICATION_SCHEMES',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'CLSFCTN_SCHM'
              FROM sbr.CLASSIFICATION_SCHEMES c, admin_item ai
             WHERE     TRIM (ai.NCI_IDSEQ) = TRIM (c.cs_idseq)
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate REPRESENTATIONS_EXT

    FOR x
        IN (  SELECT DISTINCT ITEM_ID,                          --Primary Keys
                                       VER_NR
                FROM (SELECT ITEM_ID,
                             VER_NR,
                             CREAT_USR_ID,
                             CREAT_DT,
                             LST_UPD_DT,
                             LST_UPD_USR_ID
                        FROM onedata_wa.REP_CLS
                      UNION ALL
                      SELECT ai.ITEM_ID,
                             version,
                             created_by,
                             date_created,
                             NVL (date_modified, date_created),
                             modified_by
                        FROM sbrext.representations_ext c, admin_item ai
                       WHERE TRIM (ai.NCI_IDSEQ) = TRIM (c.REP_idseq)) t
            GROUP BY ITEM_ID,
                     VER_NR,
                     CREAT_USR_ID,
                     CREAT_DT,
                     LST_UPD_DT,
                     LST_UPD_USR_ID
              HAVING COUNT (*) <> 2
            ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   REP_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'REPRESENTATIONS_EXT',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'REP_CLS'
              FROM sbrext.REPRESENTATIONS_EXT c, admin_item ai
             WHERE     TRIM (ai.NCI_IDSEQ) = TRIM (c.REP_idseq)
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate DATA_ELEMENT_CONCEPTS

    FOR x IN (  SELECT DISTINCT ITEM_ID,                        --Primary Keys
                                         VER_NR
                  FROM (SELECT ITEM_ID,
                               VER_NR,
                               OBJ_CLS_QUAL,
                               PROP_QUAL,
                               CREAT_USR_ID,
                               CREAT_DT,
                               LST_UPD_DT,
                               LST_UPD_USR_ID
                          FROM onedata_wa.DE_CONC
                         WHERE item_id NOT IN -20003
                        UNION ALL
                        SELECT ai.ITEM_ID,
                               version,
                               OBJ_CLASS_QUALIFIER,
                               PROPERTY_QUALIFIER,
                               created_by,
                               date_created,
                               NVL (date_modified, date_created),
                               modified_by
                          FROM sbr.DATA_ELEMENT_CONCEPTS c, admin_item ai
                         WHERE TRIM (ai.NCI_IDSEQ) = TRIM (c.dec_idseq)) t
              GROUP BY ITEM_ID,
                       VER_NR,
                       OBJ_CLS_QUAL,
                       PROP_QUAL,
                       CREAT_USR_ID,
                       CREAT_DT,
                       LST_UPD_DT,
                       LST_UPD_USR_ID
                HAVING COUNT (*) <> 2
              ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   DEC_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'DATA_ELEMENT_CONCEPTS',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'DE_CONC'
              FROM sbr.data_element_concepts c, admin_item ai
             WHERE     TRIM (ai.NCI_IDSEQ) = TRIM (c.DEC_idseq)
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate VALUE_DOMAINS

    FOR x IN (  SELECT DISTINCT ITEM_ID,                        --Primary Keys
                                         VER_NR
                  FROM (SELECT ITEM_ID,
                               VER_NR,
                               NCI_DEC_PREC,
                               VAL_DOM_HIGH_VAL_NUM,
                               VAL_DOM_LOW_VAL_NUM,
                               VAL_DOM_MAX_CHAR,
                               VAL_DOM_MIN_CHAR,
                               CREAT_USR_ID,
                               CREAT_DT,
                               LST_UPD_DT,
                               LST_UPD_USR_ID
                          FROM onedata_wa.VALUE_DOM
                         WHERE item_id <> -20004
                        UNION ALL
                        SELECT ai.ITEM_ID,
                               version,
                               decimal_place,
                               high_value_num,
                               low_value_num,
                               max_length_num,
                               min_length_num,
                               created_by,
                               date_created,
                               NVL (date_modified, date_created),
                               modified_by
                          FROM sbr.VALUE_DOMAINS c, admin_item ai
                         WHERE TRIM (ai.NCI_IDSEQ) = TRIM (c.vd_idseq)) t
              GROUP BY ITEM_ID,
                       VER_NR,
                       NCI_DEC_PREC,
                       VAL_DOM_HIGH_VAL_NUM,
                       VAL_DOM_LOW_VAL_NUM,
                       VAL_DOM_MAX_CHAR,
                       VAL_DOM_MIN_CHAR,
                       CREAT_USR_ID,
                       CREAT_DT,
                       LST_UPD_DT,
                       LST_UPD_USR_ID
                HAVING COUNT (*) <> 2
              ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   vd_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'VALUE_DOMAINS',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'VALUE_DOM'
              FROM sbr.value_domains c, admin_item ai
             WHERE     TRIM (ai.NCI_IDSEQ) = TRIM (c.vd_idseq)
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate OC_RECS_EXT

    FOR x
        IN (  SELECT DISTINCT ITEM_ID,                          --Primary Keys
                                       VER_NR
                FROM (SELECT ITEM_ID,
                             VER_NR,
                             REL_TYP_NM,
                             SRC_ROLE,
                             TRGT_ROLE,
                             DRCTN,
                             SRC_LOW_MULT,
                             SRC_HIGH_MULT,
                             TRGT_LOW_MULT,
                             TRGT_HIGH_MULT,
                             DISP_ORD,
                             DIMNSNLTY,
                             ARRAY_IND
                        FROM onedata_wa.NCI_OC_RECS
                      UNION ALL
                      SELECT ocr_id,
                             version,
                             rl_name,
                             source_role,
                             target_role,
                             direction,
                             source_low_multiplicity,
                             source_high_multiplicity,
                             target_low_multiplicity,
                             target_high_multiplicity,
                             display_order,
                             dimensionality,
                             array_ind
                        FROM sbrext.oc_recs_ext c, admin_item ai
                       WHERE TRIM (ai.NCI_IDSEQ) = TRIM (c.t_oc_idseq)) t
            GROUP BY ITEM_ID,
                     VER_NR,
                     REL_TYP_NM,
                     SRC_ROLE,
                     TRGT_ROLE,
                     DRCTN,
                     SRC_LOW_MULT,
                     SRC_HIGH_MULT,
                     TRGT_LOW_MULT,
                     TRGT_HIGH_MULT,
                     DISP_ORD,
                     DIMNSNLTY,
                     ARRAY_IND
              HAVING COUNT (*) <> 2
            ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   t_oc_idseq,
                   ITEM_ID,
                   VERSION,
                   'OC_RECS_EXT',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'NCI_OC_RECS'
              FROM sbrext.OC_RECS_EXT c, admin_item ai
             WHERE     TRIM (ai.NCI_IDSEQ) = TRIM (c.t_oc_idseq)
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate CONCEPTS_EXT

    FOR x
        IN (  SELECT DISTINCT ITEM_ID,                          --Primary Keys
                                       VER_NR
                FROM (SELECT ITEM_ID,
                             VER_NR,
                             evs_src_id,
                             CREAT_USR_ID,
                             CREAT_DT,
                             LST_UPD_DT,
                             LST_UPD_USR_ID
                        FROM onedata_wa.CNCPT
                      UNION ALL
                      SELECT con_id,
                             version,
                             ok.obj_key_id,
                             created_by,
                             date_created,
                             NVL (date_modified, date_created),
                             modified_by
                        FROM sbrext.CONCEPTS_EXT c, obj_key ok
                       WHERE     c.evs_source = ok.obj_key_desc(+)
                             AND ok.obj_typ_id(+) = 23) t
            GROUP BY ITEM_ID,
                     VER_NR,
                     evs_src_id,
                     CREAT_USR_ID,
                     CREAT_DT,
                     LST_UPD_DT,
                     LST_UPD_USR_ID
              HAVING COUNT (*) <> 2
            ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   CON_IDSEQ,
                   con_id,
                   VERSION,
                   'CONCEPTS_EXT',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'CNCPT'
              FROM sbrext.CONCEPTS_EXT c
             WHERE con_id = x.ITEM_ID AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate CS_ITEMS

    FOR x
        IN (  SELECT DISTINCT ITEM_ID,                          --Primary Keys
                                       VER_NR
                FROM (SELECT ITEM_ID,
                             VER_NR,
                             CSI_DESC_TXT,
                             CSI_CMNTS,
                             CREAT_USR_ID,
                             CREAT_DT,
                             LST_UPD_DT,
                             LST_UPD_USR_ID
                        FROM onedata_wa.NCI_CLSFCTN_SCHM_ITEM
                      UNION ALL
                      SELECT item_id,
                             version,
                             description,
                             comments,
                             created_by,
                             date_created,
                             NVL (date_modified, date_created),
                             modified_by
                        FROM sbr.cs_items cd, admin_item ai
                       WHERE ai.NCI_IDSEQ = cd.CSI_IDSEQ) t
            GROUP BY ITEM_ID,
                     VER_NR,
                     CSI_DESC_TXT,
                     CSI_CMNTS,
                     CREAT_USR_ID,
                     CREAT_DT,
                     LST_UPD_DT,
                     LST_UPD_USR_ID
              HAVING COUNT (*) <> 2
            ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   CSI_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'CS_ITEMS',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'NCI_CLSFCTN_SCHM_ITEM'
              FROM sbr.CS_ITEMS cd, admin_item ai
             WHERE     ai.NCI_IDSEQ = cd.CSI_IDSEQ
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate VALUE_MEANINGS

    FOR x
        IN (  SELECT DISTINCT ITEM_ID,                          --Primary Keys
                                       VER_NR
                FROM (SELECT ITEM_ID,
                             VER_NR,
                             VM_DESC_TXT,
                             VM_CMNTS,
                             CREAT_USR_ID,
                             CREAT_DT,
                             LST_UPD_DT,
                             LST_UPD_USR_ID
                        FROM onedata_wa.NCI_VAL_MEAN
                      UNION ALL
                      SELECT item_id,
                             version,
                             description,
                             comments,
                             created_by,
                             date_created,
                             NVL (date_modified, date_created),
                             modified_by
                        FROM sbr.VALUE_MEANINGS cd, admin_item ai
                       WHERE ai.NCI_IDSEQ = cd.VM_IDSEQ) t
            GROUP BY ITEM_ID,
                     VER_NR,
                     VM_DESC_TXT,
                     VM_CMNTS,
                     CREAT_USR_ID,
                     CREAT_DT,
                     LST_UPD_DT,
                     LST_UPD_USR_ID
              HAVING COUNT (*) <> 2
            ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   VM_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'VALUE_MEANINGS',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'NCI_VAL_MEAN'
              FROM sbr.value_meanings cd, admin_item ai
             WHERE     ai.NCI_IDSEQ = cd.VM_IDSEQ
                   AND ITEM_ID = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    -- Validate QUEST_CONTENTS_EXT

    FOR x
        IN (  SELECT DISTINCT ITEM_ID,                          --Primary Keys
                                       VER_NR
                FROM (SELECT ITEM_ID,
                             VER_NR,
                             catgry_id,
                             form_typ_id,
                             CREAT_USR_ID,
                             CREAT_DT,
                             LST_UPD_DT,
                             LST_UPD_USR_ID
                        FROM onedata_wa.NCI_FORM
                      UNION ALL
                      SELECT qc_id,
                             version,
                             ok.obj_key_id,
                             DECODE (qc.qtl_name,  'CRF', 70,  'TEMPLATE', 71),
                             created_by,
                             date_created,
                             NVL (date_modified, date_created),
                             modified_by
                        FROM sbrext.quest_contents_ext qc, obj_key ok
                       WHERE     qc.qcdl_name = ok.nci_cd(+)
                             AND ok.obj_typ_id(+) = 22
                             AND qc.qtl_name IN ('TEMPLATE', 'CRF')) t
            GROUP BY ITEM_ID,
                     VER_NR,
                     catgry_id,
                     form_typ_id,
                     CREAT_USR_ID,
                     CREAT_DT,
                     LST_UPD_DT,
                     LST_UPD_USR_ID
              HAVING COUNT (*) <> 2
            ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   QC_IDSEQ,
                   qc_id,
                   VERSION,
                   'QUEST_CONTENTS_EXT',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'NCI_FORM'
              FROM sbrext.QUEST_CONTENTS_EXT
             WHERE qc_id = x.ITEM_ID AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate PROTOCOLS_EXT

    FOR x
        IN (  SELECT DISTINCT ITEM_ID,                          --Primary Keys
                                       VER_NR
                FROM (SELECT ITEM_ID,
                             VER_NR,
                             PROTCL_TYP_ID,
                             PROTCL_ID,
                             LEAD_ORG,
                             PROTCL_PHASE,
                             CREAT_USR_ID,
                             CREAT_DT,
                             LST_UPD_DT,
                             LST_UPD_USR_ID,
                             CHNG_TYP,
                             CHNG_NBR,
                             RVWD_DT,
                             RVWD_USR_ID,
                             APPRVD_DT,
                             APPRVD_USR_ID
                        FROM onedata_wa.NCI_PROTCL
                      UNION ALL
                      SELECT ai.item_id,
                             version,
                             ok.obj_key_id,
                             protocol_id,
                             LEAD_ORG,
                             PHASE,
                             created_by,
                             date_created,
                             NVL (date_modified, date_created),
                             modified_by,
                             CHANGE_TYPE,
                             CHANGE_NUMBER,
                             REVIEWED_DATE,
                             REVIEWED_BY,
                             APPROVED_DATE,
                             APPROVED_BY
                        FROM sbrext.PROTOCOLS_EXT cd, admin_item ai, obj_key ok
                       WHERE     ai.NCI_IDSEQ = cd.proto_IDSEQ
                             AND TRIM (TYPE) = ok.nci_cd(+)
                             AND ok.obj_typ_id(+) = 19
                             AND ai.admin_item_typ_id = 50) t
            GROUP BY ITEM_ID,
                     VER_NR,
                     PROTCL_TYP_ID,
                     PROTCL_ID,
                     LEAD_ORG,
                     PROTCL_PHASE,
                     CREAT_USR_ID,
                     CREAT_DT,
                     LST_UPD_DT,
                     LST_UPD_USR_ID,
                     CHNG_TYP,
                     CHNG_NBR,
                     RVWD_DT,
                     RVWD_USR_ID,
                     APPRVD_DT,
                     APPRVD_USR_ID
              HAVING COUNT (*) <> 2
            ORDER BY ITEM_ID, VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   proto_IDSEQ,
                   ITEM_ID,
                   VERSION,
                   'PROTOCOLS_EXT',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'NCI_PROTCL'
              FROM sbrext.protocols_ext cd, admin_item ai
             WHERE     ai.NCI_IDSEQ = cd.proto_IDSEQ
                   AND proto_IDSEQ = x.ITEM_ID
                   AND VERSION = x.VER_NR;

        COMMIT;
    END LOOP;

    --Validate VALID_QUESTION_VALUES
    FOR x
        IN (  SELECT DISTINCT NCI_PUB_ID,                       --Primary Keys
                                          Q_VER_NR
                FROM (SELECT NCI_PUB_ID,
                             Q_PUB_ID,
                             Q_VER_NR,
                             VM_NM,
                             VM_DEF,
                             VALUE,
                             NCI_IDSEQ,
                             DESC_TXT,
                             MEAN_TXT,
                             CREAT_USR_ID,
                             CREAT_DT,
                             LST_UPD_DT,
                             LST_UPD_USR_ID
                        FROM onedata_wa.NCI_QUEST_VALID_VALUE
                      UNION ALL
                      SELECT qc.qc_id,
                             qc1.qc_id,
                             qc1.VERSION,
                             qc.preferred_name,
                             qc.preferred_definition,
                             qc.long_name,
                             qc.qc_idseq,
                             vv.description_text,
                             vv.meaning_text,
                             qc.created_by,
                             qc.DATE_CREATED,
                             NVL (qc.date_modified, qc.date_created),
                             qc.modified_by
                        FROM sbrext.QUEST_CONTENTS_EXT  qc,
                             sbrext.quest_contents_ext  qc1,
                             sbrext.valid_values_att_ext vv
                       WHERE     qc.qtl_name = 'VALID_VALUE'
                             AND qc1.qtl_name = 'QUESTION'
                             AND qc1.qc_idseq = qc.p_qst_idseq
                             AND qc.qc_idseq = vv.qc_idseq(+)) t
            GROUP BY NCI_PUB_ID,
                     Q_PUB_ID,
                     Q_VER_NR,
                     VM_NM,
                     VM_DEF,
                     VALUE,
                     NCI_IDSEQ,
                     DESC_TXT,
                     MEAN_TXT,
                     CREAT_USR_ID,
                     CREAT_DT,
                     LST_UPD_DT,
                     LST_UPD_USR_ID
              HAVING COUNT (*) <> 2
            ORDER BY NCI_PUB_ID, Q_VER_NR)
    LOOP
        INSERT INTO SBREXT.ONEDATA_MIGRATION_ERROR
            SELECT SBREXT.ERR_SEQ.NEXTVAL,
                   vv.qc_idseq,
                   qc_id,
                   VERSION,
                   'VALID_QUESTION_VALUES',
                   PREFERRED_NAME,
                   'DATA MISMATCH',
                   SYSDATE,
                   USER,
                   'NCI_QUEST_VALID_VALUE'
              FROM sbrext.valid_values_att_ext  vv,
                   sbrext.quest_contents_ext    qc
             WHERE     qc.qc_idseq = vv.qc_idseq
                   AND qc_id = x.NCI_PUB_ID
                   AND VERSION = x.Q_VER_NR;

        COMMIT;
    END LOOP;
END;
/