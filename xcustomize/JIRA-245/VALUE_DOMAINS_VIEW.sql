DROP VIEW ONEDATA_WA.VALUE_DOMAINS_VIEW;

/* Formatted on 12/4/2020 7:28:50 PM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.VALUE_DOMAINS_VIEW
(
    VD_IDSEQ,
    VERSION,
    PREFERRED_NAME,
    CONTE_IDSEQ,
    PREFERRED_DEFINITION,
    BEGIN_DATE,
    CONTE_NAME,
    CONTE_ITEM_ID,
    CONTE_VER_NR,
    DTL_NAME,
    CD_IDSEQ,
    CONC_DOM_ITEM_ID,
    CONC_DOM_VER_NR,
    END_DATE,
    VD_TYPE,
    ASL_NAME,
    CHANGE_NOTE,
    UOML_NAME,
    LONG_NAME,
    FORML_NAME,
    MAX_LENGTH_NUM,
    MIN_LENGTH_NUM,
    HIGH_VALUE_NUM,
    LOW_VALUE_NUM,
    DECIMAL_PLACE,
    LATEST_VERSION_IND,
    DELETED_IND,
    CREATED_BY,
    MODIFIED_BY,
    DATE_MODIFIED,
    DATE_CREATED,
    CHAR_SET_NAME,
    REP_IDSEQ,
    ORIGIN,
    VD_ID,
    VD_TYPE_FLAG
)
BEQUEATH DEFINER
AS
    SELECT ai.NCI_IDSEQ                         VD_IDSEQ,
           ai.ver_nr                            VERSION,
           ai.ITEM_LONG_NM                      PREFERRED_NAME,
           con.nci_idseq                        CONTE_IDSEQ,
           ai.ITEM_DESC                         PREFERRED_DEFINITION,
           AI.EFF_DT                            BEGIN_DATE,
           AI.CNTXT_NM_DN                       CONTE_NAME,
           AI.CNTXT_ITEM_ID                     CONTE_ITEM_ID,
           AI.CNTXT_VER_NR                      CONTE_VER_NR,
           data_typ.nci_cd                      DTL_NAME,
           cd.nci_idseq                         CD_IDSEQ,
           CONC_DOM_ITEM_ID,
           CONC_DOM_VER_NR,
           ai.UNTL_DT                           END_DATE,
           VAL_DOM_TYP_ID                       VD_TYPE,
           ai.ADMIN_STUS_NM_DN                  ASL_NAME,
           ai.CHNG_DESC_TXT                     CHANGE_NOTE,
           uom.nci_cd                           UOML_NAME,
           ai.ITEM_NM                           LONG_NAME,
           fmt.nci_cd                           FORML_NAME,
           VAL_DOM_HIGH_VAL_NUM                 MAX_LENGTH_NUM,
           VAL_DOM_LOW_VAL_NUM                  MIN_LENGTH_NUM,
           VAL_DOM_MAX_CHAR                     HIGH_VALUE_NUM,
           VAL_DOM_MIN_CHAR                     LOW_VALUE_NUM,
           NCI_DEC_PREC                         DECIMAL_PLACE,
           decode(ai.CURRNT_VER_IND,1,'YES',0,'NO') LATEST_VERSION_IND,
           ai.FLD_DELETE                        DELETED_IND,
           ai.CREAT_USR_ID                      CREATED_BY,
           ai.LST_UPD_USR_ID                    MODIFIED_BY,
           ai.LST_UPD_DT                        DATE_MODIFIED,
           ai.CREAT_DT                          DATE_CREATED,
           --ai.LST_DEL_DT                                 END_DATE,
           CHAR_SET_ID                          CHAR_SET_NAME,
           rep.NCI_IDSEQ                        REP_IDSEQ,
           --QUALIFIER_NAME,
           NVL (AI.ORIGIN, AI.ORIGIN_ID_DN)     ORIGIN,
           ai.item_id                           VD_ID,
          DECODE(vd.VAL_DOM_TYP_ID,17,'E',18,'N') VD_TYPE_FLAG

      FROM VALUE_DOM   vd,
           admin_item  ai,
           admin_item  cd,
           fmt,
           admin_item  con,
           admin_item  rep,
           uom,
           data_typ
     WHERE     vd.item_id = ai.item_id
           AND vd.ver_nr = ai.ver_nr
           AND ai.ADMIN_ITEM_TYP_ID = 3
           AND ai.CNTXT_ITEM_ID = con.ITEM_ID
           AND AI.CNTXT_VER_NR = con.VER_NR
           AND REP_CLS_ITEM_ID = rep.item_id
           AND vd.REP_CLS_VER_NR = rep.ver_nr
           AND fmt.fmt_id(+) = vd.VAL_DOM_FMT_ID
           AND vd.uom_id = uom.uom_id(+)
           AND vd.DTTYPE_ID = data_typ.DTTYPE_ID
           AND cd.item_id = vd.CONC_DOM_ITEM_ID
           AND cd.ver_nr = vd.CONC_DOM_VER_NR;
