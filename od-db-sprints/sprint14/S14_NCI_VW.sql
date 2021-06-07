/* Formatted on 6/7/2021 3:53:54 PM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.VW_NCI_DE_HORT
(
    ITEM_ID,
    VER_NR,
    ITEM_NM,
    ITEM_LONG_NM,
    ITEM_DESC,
    CNTXT_NM_DN, 
    ORIGIN_ID,
    ORIGIN,   
    ORIGIN_ID_DN,
    UNTL_DT,
    CURRNT_VER_IND,
    REGISTRR_CNTCT_ID,
    SUBMT_CNTCT_ID,
    STEWRD_CNTCT_ID,
    SUBMT_ORG_ID,
    STEWRD_ORG_ID,
    REGSTR_AUTH_ID,
    DE_PREC,
    DE_CONC_ITEM_ID,
    DE_CONC_VER_NR,
    VAL_DOM_VER_NR,
    VAL_DOM_ITEM_ID,
    REP_CLS_VER_NR,
    REP_CLS_ITEM_ID,
    DERV_DE_IND,
    DERV_MTHD,
    DERV_RUL,
    DERV_TYP_ID,
    CONCAT_CHAR,
    CREAT_USR_ID,
    LST_UPD_USR_ID,
    FLD_DELETE,
    LST_DEL_DT,
    S2P_TRN_DT,
    LST_UPD_DT,
    CREAT_DT,
    CREAT_USR_ID_API,
    LST_UPD_USR_ID_API,
    CREAT_DT_API,
    LST_UPD_DT_API,
    CONC_DOM_VER_NR,
    CONC_DOM_ITEM_ID,
    NON_ENUM_VAL_DOM_DESC,
    UOM_ID,
    VAL_DOM_TYP_ID,
    VAL_DOM_MIN_CHAR,
    VAL_DOM_MAX_CHAR,
    VAL_DOM_HIGH_VAL_NUM,
    VAL_DOM_LOW_VAL_NUM,
    VAL_DOM_FMT_ID,
    CHAR_SET_ID,
    VALUE_DOM_CREAT_DT,
    VALUE_DOM_USR_ID,
    VALUE_DOM_LST_UPD_USR_ID,
    VALUE_DOM_LST_UPD_DT,
    VALUE_DOM_ITEM_NM,
    VALUE_DOM_ITEM_LONG_NM,
    VALUE_DOM_ITEM_DESC,
    VALUE_DOM_CNTXT_NM,
    VALUE_DOM_CURRNT_VER_IND,
    VALUE_DOM_REGSTR_STUS_NM,
    VALUE_DOM_ADMIN_STUS_NM,
    NCI_STD_DTTYPE_ID,
    DTTYPE_ID,
    DEC_ITEM_NM,
    DEC_ITEM_LONG_NM,
    DEC_ITEM_DESC,
    DEC_CNTXT_NM,
    DEC_CURRNT_VER_IND,
    DEC_REGSTR_STUS_NM,
    DEC_ADMIN_STUS_NM,
    DEC_CREAT_DT,
    DEC_USR_ID,
    DEC_LST_UPD_USR_ID,
    DEC_LST_UPD_DT,
    OBJ_CLS_ITEM_ID,
    OBJ_CLS_VER_NR,
    OBJ_CLS_ITEM_NM,
    OBJ_CLS_ITEM_LONG_NM,
    PROP_ITEM_NM,
    PROP_ITEM_LONG_NM,
    PROP_ITEM_ID,
    PROP_VER_NR,
    DEC_CD_ITEM_ID,
    DEC_CD_VER_NR,
    DEC_CD_ITEM_NM,
    DEC_CD_ITEM_LONG_NM,
    DEC_CD_ITEM_DESC,
    DEC_CD_CNTXT_NM,
    DEC_CD_CURRNT_VER_IND,
    DEC_CD_REGSTR_STUS_NM,
    DEC_CD_ADMIN_STUS_NM,
    CD_ITEM_NM,
    CD_ITEM_LONG_NM,
    CD_ITEM_DESC,
    CD_CNTXT_NM,
    CD_CURRNT_VER_IND,
    CD_REGSTR_STUS_NM,
    CD_ADMIN_STUS_NM,
    ADMIN_ITEM_TYP_ID,
    CNTXT_AGG,
    LST_UPD_CHG_DAYS
)
BEQUEATH DEFINER
AS
    SELECT ADMIN_ITEM.ITEM_ID                ITEM_ID,
           ADMIN_ITEM.VER_NR,
           ADMIN_ITEM.ITEM_NM,
           ADMIN_ITEM.ITEM_LONG_NM,
           ADMIN_ITEM.ITEM_DESC,
           ADMIN_ITEM.CNTXT_NM_DN,
           ADMIN_ITEM.ORIGIN_ID,
           ADMIN_ITEM.ORIGIN,
           ADMIN_ITEM.ORIGIN_ID_DN,
           ADMIN_ITEM.UNTL_DT,
           ADMIN_ITEM.CURRNT_VER_IND,
           ADMIN_ITEM.REGISTRR_CNTCT_ID,
           ADMIN_ITEM.SUBMT_CNTCT_ID,
           ADMIN_ITEM.STEWRD_CNTCT_ID,
           ADMIN_ITEM.SUBMT_ORG_ID,
           ADMIN_ITEM.STEWRD_ORG_ID,
           ADMIN_ITEM.REGSTR_AUTH_ID,
           DE.DE_PREC,
           DE.DE_CONC_ITEM_ID,
           DE.DE_CONC_VER_NR,
           DE.VAL_DOM_VER_NR,
           DE.VAL_DOM_ITEM_ID,
           DE.REP_CLS_VER_NR,
           DE.REP_CLS_ITEM_ID,
           DE.DERV_DE_IND,
           DE.DERV_MTHD,
           DE.DERV_RUL,
           DE.DERV_TYP_ID,
           DE.CONCAT_CHAR,
           DE.CREAT_USR_ID,
           DE.LST_UPD_USR_ID,
           DE.FLD_DELETE,
           DE.LST_DEL_DT,
           DE.S2P_TRN_DT,
           DE.LST_UPD_DT,
           DE.CREAT_DT,
           DE.CREAT_USR_ID                   CREAT_USR_ID_API,
           DE.LST_UPD_USR_ID                 LST_UPD_USR_ID_API,
           DE.CREAT_DT                       CREAT_DT_API,
           DE.LST_UPD_DT                     LST_UPD_DT_API,
           VALUE_DOM.CONC_DOM_VER_NR,
           VALUE_DOM.CONC_DOM_ITEM_ID,
           VALUE_DOM.NON_ENUM_VAL_DOM_DESC,
           VALUE_DOM.UOM_ID,
           VALUE_DOM.VAL_DOM_TYP_ID          VAL_DOM_TYP_ID,
           VALUE_DOM.VAL_DOM_MIN_CHAR,
           VALUE_DOM.VAL_DOM_MAX_CHAR,
           VALUE_DOM.VAL_DOM_HIGH_VAL_NUM,
           VALUE_DOM.VAL_DOM_LOW_VAL_NUM,
           VALUE_DOM.VAL_DOM_FMT_ID,
           VALUE_DOM.CHAR_SET_ID,
           VALUE_DOM.CREAT_DT                VALUE_DOM_CREAT_DT,
           VALUE_DOM.CREAT_USR_ID            VALUE_DOM_USR_ID,
           VALUE_DOM.LST_UPD_USR_ID          VALUE_DOM_LST_UPD_USR_ID,
           VALUE_DOM.LST_UPD_DT              VALUE_DOM_LST_UPD_DT,
           VALUE_DOM_AI.ITEM_NM              VALUE_DOM_ITEM_NM,
           VALUE_DOM_AI.ITEM_LONG_NM         VALUE_DOM_ITEM_LONG_NM,
           VALUE_DOM_AI.ITEM_DESC            VALUE_DOM_ITEM_DESC,
           VALUE_DOM_AI.CNTXT_NM_DN          VALUE_DOM_CNTXT_NM,
           VALUE_DOM_AI.CURRNT_VER_IND       VALUE_DOM_CURRNT_VER_IND,
           VALUE_DOM_AI.REGSTR_STUS_NM_DN    VALUE_DOM_REGSTR_STUS_NM,
           VALUE_DOM_AI.ADMIN_STUS_NM_DN     VALUE_DOM_ADMIN_STUS_NM,
           VALUE_DOM.NCI_STD_DTTYPE_ID,
           VALUE_DOM.DTTYPE_ID,
           DEC_AI.ITEM_NM                    DEC_ITEM_NM,
           DEC_AI.ITEM_LONG_NM               DEC_ITEM_LONG_NM,
           DEC_AI.ITEM_DESC                  DEC_ITEM_DESC,
           DEC_AI.CNTXT_NM_DN                DEC_CNTXT_NM,
           DEC_AI.CURRNT_VER_IND             DEC_CURRNT_VER_IND,
           DEC_AI.REGSTR_STUS_NM_DN          DEC_REGSTR_STUS_NM,
           DEC_AI.ADMIN_STUS_NM_DN           DEC_ADMIN_STUS_NM,
           DEC_AI.CREAT_DT                   DEC_CREAT_DT,
           DEC_AI.CREAT_USR_ID               DEC_USR_ID,
           DEC_AI.LST_UPD_USR_ID             DEC_LST_UPD_USR_ID,
           DEC_AI.LST_UPD_DT                 DEC_LST_UPD_DT,
           DE_CONC.OBJ_CLS_ITEM_ID,
           DE_CONC.OBJ_CLS_VER_NR,
           OC.ITEM_NM                        OBJ_CLS_ITEM_NM,
           OC.ITEM_LONG_NM                   OBJ_CLS_ITEM_LONG_NM,
           PROP.ITEM_NM                      PROP_ITEM_NM,
           PROP.ITEM_LONG_NM                 PROP_ITEM_LONG_NM,
           DE_CONC.PROP_ITEM_ID,
           DE_CONC.PROP_VER_NR,
           DE_CONC.CONC_DOM_ITEM_ID          DEC_CD_ITEM_ID,
           DE_CONC.CONC_DOM_VER_NR           DEC_CD_VER_NR,
           DEC_CD.ITEM_NM                    DEC_CD_ITEM_NM,
           DEC_CD.ITEM_LONG_NM               DEC_CD_ITEM_LONG_NM,
           DEC_CD.ITEM_DESC                  DEC_CD_ITEM_DESC,
           DEC_CD.CNTXT_NM_DN                DEC_CD_CNTXT_NM,
           DEC_CD.CURRNT_VER_IND             DEC_CD_CURRNT_VER_IND,
           DEC_CD.REGSTR_STUS_NM_DN          DEC_CD_REGSTR_STUS_NM,
           DEC_CD.ADMIN_STUS_NM_DN           DEC_CD_ADMIN_STUS_NM,
           CD_AI.ITEM_NM                     CD_ITEM_NM,
           CD_AI.ITEM_LONG_NM                CD_ITEM_LONG_NM,
           CD_AI.ITEM_DESC                   CD_ITEM_DESC,
           CD_AI.CNTXT_NM_DN                 CD_CNTXT_NM,
           CD_AI.CURRNT_VER_IND              CD_CURRNT_VER_IND,
           CD_AI.REGSTR_STUS_NM_DN           CD_REGSTR_STUS_NM,
           CD_AI.ADMIN_STUS_NM_DN            CD_ADMIN_STUS_NM,
           ADMIN_ITEM.ADMIN_ITEM_TYP_ID,
           ''                                CNTXT_AGG,
             SYSDATE
           - GREATEST (DE.LST_UPD_DT,
                       admin_item.lst_upd_dt,
                       Value_dom.LST_UPD_DT,
                       dec_ai.LST_UPD_DT)    LST_UPD_CHG_DAYS
      FROM ADMIN_ITEM,
           DE,
           VALUE_DOM,
           ADMIN_ITEM   VALUE_DOM_AI,
           ADMIN_ITEM   DEC_AI,
           DE_CONC,
           VW_CONC_DOM  DEC_CD,
           VW_CONC_DOM  CD_AI,
           ADMIN_ITEM   OC,
           ADMIN_ITEM   PROP
     WHERE     ADMIN_ITEM.ADMIN_ITEM_TYP_ID = 4
           AND DE.ITEM_ID = ADMIN_ITEM.ITEM_ID
           AND DE.VER_NR = ADMIN_ITEM.VER_NR
           AND DE.VAL_DOM_ITEM_ID = VALUE_DOM_AI.ITEM_ID
           AND DE.VAL_DOM_VER_NR = VALUE_DOM_AI.VER_NR
           AND DE.VAL_DOM_ITEM_ID = VALUE_DOM.ITEM_ID
           AND DE.VAL_DOM_VER_NR = VALUE_DOM.VER_NR
           AND DE.DE_CONC_ITEM_ID = DEC_AI.ITEM_ID
           AND DE.DE_CONC_VER_NR = DEC_AI.VER_NR
           AND DE.DE_CONC_ITEM_ID = DE_CONC.ITEM_ID
           AND DE_CONC.OBJ_CLS_ITEM_ID = OC.ITEM_ID
           AND DE_CONC.OBJ_CLS_VER_NR = OC.VER_NR
           AND DE_CONC.PROP_ITEM_ID = PROP.ITEM_ID
           AND DE_CONC.PROP_VER_NR = PROP.VER_NR
           AND DE.DE_CONC_VER_NR = DE_CONC.VER_NR
           AND DE_CONC.CONC_DOM_ITEM_ID = DEC_CD.ITEM_ID
           AND DE_CONC.CONC_DOM_VER_NR = DEC_CD.VER_NR
           AND VALUE_DOM.CONC_DOM_ITEM_ID = CD_AI.ITEM_ID
           AND VALUE_DOM.CONC_DOM_VER_NR = CD_AI.VER_NR;

/* Formatted on 6/7/2021 11:47:28 AM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.VW_NCI_AI
(
    ITEM_ID,
    VER_NR,
    ITEM_ID_STR,
    CREAT_USR_ID,
    LST_UPD_USR_ID,
    FLD_DELETE,
    LST_DEL_DT,
    S2P_TRN_DT,
    LST_UPD_DT,
    CREAT_DT,
    SEARCH_STR
)
BEQUEATH DEFINER
AS
    SELECT ADMIN_ITEM.ITEM_ID,
           ADMIN_ITEM.VER_NR,
           '.' || ADMIN_ITEM.ITEM_ID || '.'    ITEM_ID_STR,
           ADMIN_ITEM.CREAT_USR_ID,
           ADMIN_ITEM.LST_UPD_USR_ID,
           ADMIN_ITEM.FLD_DELETE,
           ADMIN_ITEM.LST_DEL_DT,
           ADMIN_ITEM.S2P_TRN_DT,
           ADMIN_ITEM.LST_UPD_DT,
           ADMIN_ITEM.CREAT_DT,
         trim(SUBSTR (
                 trim(ADMIN_ITEM.ITEM_LONG_NM)
              || '||'
              || trim(ADMIN_ITEM.ITEM_NM)
              || '||'
              || trim(ADMIN_ITEM.ITEM_DESC),1,
              4290))
              || '||'
              || 
              SUBSTR ( trim(REF_DESC),
             1,
              30000)                          SEARCH_STR
      FROM ADMIN_ITEM  ADMIN_ITEM,
           (  SELECT item_id,
                     ver_nr,
                     LISTAGG (trim(ref_desc),
                              '||'
                              ON OVERFLOW TRUNCATE )
                     WITHIN GROUP (ORDER BY ref_desc DESC)    ref_desc
                FROM REF, OBJ_KEY
               WHERE     REF_TYP_ID = OBJ_KEY.OBJ_KEY_ID
                     AND LOWER (OBJ_KEY_DESC) LIKE '%question%'
            GROUP BY item_id, ver_nr) REF                                   --
     WHERE     ADMIN_ITEM.ITEM_ID = REF.ITEM_ID(+)
           AND ADMIN_ITEM.VER_NR = REF.VER_NR(+);


GRANT SELECT ON ONEDATA_WA.VW_NCI_AI TO ONEDATA_RO;
