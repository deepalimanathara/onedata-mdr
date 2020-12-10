

/* Formatted on 12/9/2020 10:14:15 AM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.DATA_ELEMENTS_VIEW
(
    DE_IDSEQ,
    CDE_ID,
    VERSION,
    LONG_NAME,
    PREFERRED_NAME,
    VD_IDSEQ,
    DEC_IDSEQ,
    CONTE_IDSEQ,
    DEC_ID,
    DEC_VERSION,
    VD_ID,
    VD_VERSION,
    PREFERRED_DEFINITION,
    ADMIN_NOTES,
    CHANGE_NOTE,
    BEGIN_DATE,
    ORIGIN,
    UNRESOLVED_ISSUE,
    UNTL_DT,
    LATEST_VERSION_IND,
    REGISTRATION_STATUS ,
    ASL_NAME,
    WORKFLOW_STATUS_DESC,
    CONTEXTS_NAME,
    CNTXT_ITEM_ID,
    CNTXT_VER_NR, 
    CREATED_BY,
    MODIFIED_BY,
    DELETED_IND,
    DATE_MODIFIED,
    DATE_CREATED,
    END_DATE,
    ADMIN_ITEM_TYP_ID,
    QUESTION
)
BEQUEATH DEFINER
AS
    SELECT ADMIN_ITEM.NCI_IDSEQ               DE_IDSEQ,
           ADMIN_ITEM.ITEM_ID               CDE_ID,
           ADMIN_ITEM.VER_NR               VERSION,
           ADMIN_ITEM.ITEM_NM               LONG_NAME,
           ADMIN_ITEM.ITEM_LONG_NM               PREFERRED_NAME,
           VD.NCI_IDSEQ            VD_IDSEQ,
           DE_CONC.NCI_IDSEQ               DEC_IDSEQ,
           CONTE.NCI_IDSEQ               CONTE_IDSEQ,
           DE_CONC_ITEM_ID               DEC_ID,
           DE_CONC_VER_NR               DEC_VERSION,
           VAL_DOM_ITEM_ID               VD_ID,
           VAL_DOM_VER_NR               VD_VERSION,
           ADMIN_ITEM.ITEM_DESC        PREFERRED_DEFINITION,
           ADMIN_ITEM.ADMIN_NOTES,
           ADMIN_ITEM.CHNG_DESC_TXT        CHANGE_NOTE,
           --ADMIN_ITEM.CREATION_DT DATE_CREATED,
           TRUNC (ADMIN_ITEM.EFF_DT)       BEGIN_DATE,
           NVL (ADMIN_ITEM.ORIGIN, ADMIN_ITEM.ORIGIN_ID_DN)
               ORIGIN,
           ADMIN_ITEM.UNRSLVD_ISSUE UNRESOLVED_ISSUE,
           ADMIN_ITEM.UNTL_DT END_DATE,
           DECODE (ADMIN_ITEM.CURRNT_VER_IND,  1, 'Yes',  0, 'No')               LATEST_VERSION_IND,
           --ADMIN_ITEM.REGSTR_STUS_ID,
           --ADMIN_ITEM.ADMIN_STUS_ID,
           ADMIN_ITEM.REGSTR_STUS_NM_DN REGISTRATION_STATUS,
           ADMIN_ITEM.ADMIN_STUS_NM_DN     ASL_NAME,
           wf.STUS_DESC WORKFLOW_STATUS_DESC,  
           ADMIN_ITEM.CNTXT_NM_DN CONTEXTS_NAME,
           ADMIN_ITEM.CNTXT_ITEM_ID,
           ADMIN_ITEM.CNTXT_VER_NR,
           ADMIN_ITEM.CREAT_USR_ID               CREATED_BY,
           ADMIN_ITEM.LST_UPD_USR_ID               MODIFIED_BY,
           DECODE (ADMIN_ITEM.FLD_DELETE,  1, 'Yes',  0, 'No')               DELETED_IND,
           TRUNC (ADMIN_ITEM.LST_UPD_DT)               DATE_MODIFIED,
           TRUNC (ADMIN_ITEM.CREAT_DT)               DATE_CREATED,
           TRUNC (ADMIN_ITEM.UNTL_DT)               END_DATE,
           --ADMIN_ITEM.S2P_TRN_DT BEGIN_DATE,
           ADMIN_ITEM.ADMIN_ITEM_TYP_ID,
           DE.PREF_QUEST_TXT      QUESTION
      --SELECT*
      FROM ADMIN_ITEM  ADMIN_ITEM,
           DE,
           ADMIN_ITEM  DE_CONC,
           ADMIN_ITEM  VD,
           ADMIN_ITEM  CONTE,
           STUS_MSTR wf
           
     WHERE     ADMIN_ITEM.ADMIN_ITEM_TYP_ID = 4
           AND ADMIN_ITEM.ITEM_ID = DE.ITEM_ID
           AND ADMIN_ITEM.VER_NR = DE.VER_NR
           AND ADMIN_ITEM.ADMIN_STUS_ID=wf.STUS_ID
           AND wf.STUS_TYP_ID=2
           AND DE.VAL_DOM_ITEM_ID = VD.ITEM_ID
           AND DE.VAL_DOM_VER_NR = VD.VER_NR
           AND DE.DE_CONC_ITEM_ID = DE_CONC.ITEM_ID
           AND DE.DE_CONC_VER_NR = DE_CONC.VER_NR
           AND VD.ADMIN_ITEM_TYP_ID = 3
           AND DE_CONC.ADMIN_ITEM_TYP_ID = 2
           AND ADMIN_ITEM.CNTXT_ITEM_ID = CONTE.ITEM_ID
           AND ADMIN_ITEM.CNTXT_VER_NR = CONTE.VER_NR
           AND CONTE.ADMIN_ITEM_TYP_ID = 8;

