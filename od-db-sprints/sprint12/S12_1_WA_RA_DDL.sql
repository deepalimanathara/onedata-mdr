alter table NCI_STG_AI_CNCPT_CREAT
add (ITEM_LONG_NM  varchar2(30) null,  ITEM_NM varchar2(255) null);

drop materialized view  VW_CLSFCTN_SCHM;


CREATE OR REPLACE VIEW VW_CLSFCTN_SCHM AS
SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT, CS.CLSFCTN_SCHM_TYP_ID, ADMIN_ITEM.NCI_IDSEQ, ADMIN_ITEM.CNTXT_ITEM_ID, ADMIN_ITEM.CNTXT_VER_NR
FROM ADMIN_ITEM, CLSFCTN_SCHM CS
       WHERE ADMIN_ITEM_TYP_ID = 9 and ADMIN_ITEM.ITEM_ID = CS.ITEM_ID and ADMIN_ITEM.VER_NR = CS.VER_NR;


drop materialized view VW_CLSFCTN_SCHM_ITEM;

CREATE OR REPLACE VIEW VW_CLSFCTN_SCHM_ITEM
   AS
 SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM,  ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT, ADMIN_ITEM.NCI_IDSEQ, CSI.P_ITEM_ID, CSI.P_ITEM_VER_NR, CSI.CS_ITEM_ID, CSI.CS_ITEM_VER_NR
FROM ADMIN_ITEM, NCI_CLSFCTN_SCHM_ITEM csi
       WHERE ADMIN_ITEM_TYP_ID = 51 and ADMIN_ITEM.ITEM_ID = CSI.ITEM_ID and ADMIN_ITEM.VER_NR = CSI.VER_NR;



  CREATE TABLE NCI_STG_CDE_CREAT 
   (	STG_AI_ID NUMBER NOT NULL ENABLE, 
	CTL_VAL_MSG VARCHAR2(4000 BYTE), 
    	CTL_VAL_STUS  varchar2(100) DEFAULT 'CREATED',
	CNCPT_CONCAT_STR_1 VARCHAR2(4000 BYTE) COLLATE USING_NLS_COMP, 
	CNCPT_CONCAT_STR_2 VARCHAR2(4000 BYTE) COLLATE USING_NLS_COMP, 
	CNCPT_CONCAT_STR_3 VARCHAR2(4000 BYTE) COLLATE USING_NLS_COMP, 
	CONC_DOM_ITEM_ID NUMBER, 
	CONC_DOM_VER_NR NUMBER(4,2), 
	CNTXT_ITEM_ID NUMBER, 
	CNTXT_VER_NR NUMBER(4,2), 
	CNCPT_1_ITEM_ID_1 NUMBER, 
	CNCPT_1_VER_NR_1 NUMBER(4,2), 
	CNCPT_1_ITEM_ID_2 NUMBER, 
	CNCPT_1_VER_NR_2 NUMBER(4,2), 
	CNCPT_1_ITEM_ID_3 NUMBER, 
	CNCPT_1_VER_NR_3 NUMBER(4,2), 
	CNCPT_1_ITEM_ID_4 NUMBER, 
	CNCPT_1_VER_NR_4 NUMBER(4,2), 
	CNCPT_1_ITEM_ID_5 NUMBER, 
	CNCPT_1_VER_NR_5 NUMBER(4,2), 
	CNCPT_1_ITEM_ID_6 NUMBER, 
	CNCPT_1_VER_NR_6 NUMBER(4,2), 
	CNCPT_1_ITEM_ID_7 NUMBER, 
	CNCPT_1_VER_NR_7 NUMBER(4,2), 
	CNCPT_1_ITEM_ID_8 NUMBER, 
	CNCPT_1_VER_NR_8 NUMBER(4,2), 
	CNCPT_1_ITEM_ID_9 NUMBER, 
	CNCPT_1_VER_NR_9 NUMBER(4,2), 
	CNCPT_1_ITEM_ID_10 NUMBER, 
	CNCPT_1_VER_NR_10 NUMBER(4,2), 
	CNCPT_2_ITEM_ID_1 NUMBER, 
	CNCPT_2_VER_NR_1 NUMBER(4,2), 
	CNCPT_2_ITEM_ID_2 NUMBER, 
	CNCPT_2_VER_NR_2 NUMBER(4,2), 
	CNCPT_2_ITEM_ID_3 NUMBER, 
	CNCPT_2_VER_NR_3 NUMBER(4,2), 
	CNCPT_2_ITEM_ID_4 NUMBER, 
	CNCPT_2_VER_NR_4 NUMBER(4,2), 
	CNCPT_2_ITEM_ID_5 NUMBER, 
	CNCPT_2_VER_NR_5 NUMBER(4,2), 
	CNCPT_2_ITEM_ID_6 NUMBER, 
	CNCPT_2_VER_NR_6 NUMBER(4,2), 
	CNCPT_2_ITEM_ID_7 NUMBER, 
	CNCPT_2_VER_NR_7 NUMBER(4,2), 
	CNCPT_2_ITEM_ID_8 NUMBER, 
	CNCPT_2_VER_NR_8 NUMBER(4,2), 
	CNCPT_2_ITEM_ID_9 NUMBER, 
	CNCPT_2_VER_NR_9 NUMBER(4,2), 
	CNCPT_2_ITEM_ID_10 NUMBER, 
	CNCPT_2_VER_NR_10 NUMBER(4,2), 
	CNCPT_3_ITEM_ID_1 NUMBER, 
	CNCPT_3_VER_NR_1 NUMBER(4,2), 
	CNCPT_3_ITEM_ID_2 NUMBER, 
	CNCPT_3_VER_NR_2 NUMBER(4,2), 
	CNCPT_3_ITEM_ID_3 NUMBER, 
	CNCPT_3_VER_NR_3 NUMBER(4,2), 
	CNCPT_3_ITEM_ID_4 NUMBER, 
	CNCPT_3_VER_NR_4 NUMBER(4,2), 
	CNCPT_3_ITEM_ID_5 NUMBER, 
	CNCPT_3_VER_NR_5 NUMBER(4,2), 
	CNCPT_3_ITEM_ID_6 NUMBER, 
	CNCPT_3_VER_NR_6 NUMBER(4,2), 
	CNCPT_3_ITEM_ID_7 NUMBER, 
	CNCPT_3_VER_NR_7 NUMBER(4,2), 
	CNCPT_3_ITEM_ID_8 NUMBER, 
	CNCPT_3_VER_NR_8 NUMBER(4,2), 
	CNCPT_3_ITEM_ID_9 NUMBER, 
	CNCPT_3_VER_NR_9 NUMBER(4,2), 
	CNCPT_3_ITEM_ID_10 NUMBER, 
	CNCPT_3_VER_NR_10 NUMBER(4,2), 
	CREAT_DT DATE DEFAULT sysdate, 
	CREAT_USR_ID VARCHAR2(50 BYTE) COLLATE USING_NLS_COMP DEFAULT user, 
	LST_UPD_USR_ID VARCHAR2(50 BYTE) COLLATE USING_NLS_COMP DEFAULT user, 
	FLD_DELETE NUMBER(1,0) DEFAULT 0, 
	LST_DEL_DT DATE DEFAULT sysdate, 
	S2P_TRN_DT DATE DEFAULT sysdate, 
	LST_UPD_DT DATE DEFAULT sysdate, 
	GEN_DE_NM VARCHAR2(255 BYTE) COLLATE USING_NLS_COMP, 
	GEN_DE_CONC_NM VARCHAR2(255 BYTE) COLLATE USING_NLS_COMP, 
	DE_CONC_ITEM_ID_FND  number,
    	DE_CONC_VER_VR_FND  number(4,2),
    	VAL_DOM_ITEM_ID_CREAT  number,
    	DE_CONC_ITEM_ID_CREAT  number,
    	ITEM_1_ID NUMBER, 
	ITEM_1_VER_NR NUMBER(4,2), 
	ITEM_1_NM VARCHAR2(255 BYTE) COLLATE USING_NLS_COMP, 
	ITEM_1_LONG_NM VARCHAR2(255 BYTE) COLLATE USING_NLS_COMP, 
	ITEM_1_DEF VARCHAR2(4000 BYTE) COLLATE USING_NLS_COMP, 
	ITEM_2_ID NUMBER, 
	ITEM_2_VER_NR NUMBER(4,2), 
	ITEM_2_NM VARCHAR2(255 BYTE) COLLATE USING_NLS_COMP, 
	ITEM_2_LONG_NM VARCHAR2(255 BYTE) COLLATE USING_NLS_COMP, 
	ITEM_2_DEF VARCHAR2(4000 BYTE) COLLATE USING_NLS_COMP, 
	ITEM_3_ID NUMBER, 
	ITEM_3_VER_NR NUMBER(4,2), 
	ITEM_3_NM VARCHAR2(255 BYTE) COLLATE USING_NLS_COMP, 
	ITEM_3_LONG_NM VARCHAR2(255 BYTE) COLLATE USING_NLS_COMP, 
	ITEM_3_DEF VARCHAR2(4000 BYTE) COLLATE USING_NLS_COMP, 
	DTTYPE_ID NUMBER, 
	VAL_DOM_MAX_CHAR NUMBER, 
	VAL_DOM_TYP_ID NUMBER, 
	UOM_ID NUMBER, 
	VD_CONC_DOM_VER_NR NUMBER(4,2), 
	VD_CONC_DOM_ITEM_ID NUMBER, 
	REP_CLS_VER_NR NUMBER(4,2), 
	REP_CLS_ITEM_ID NUMBER, 
	VAL_DOM_MIN_CHAR NUMBER, 
	VAL_DOM_FMT_ID NUMBER, 
	CHAR_SET_ID NUMBER, 
	VAL_DOM_HIGH_VAL_NUM VARCHAR2(50 BYTE) COLLATE USING_NLS_COMP, 
	VAL_DOM_LOW_VAL_NUM VARCHAR2(50 BYTE) COLLATE USING_NLS_COMP, 
	NCI_DEC_PREC NUMBER(2,0), 
	NCI_STD_DTTYPE_ID NUMBER, 
	CDE_ITEM_LONG_NM VARCHAR2(30 BYTE) COLLATE USING_NLS_COMP, 
	CDE_ITEM_NM VARCHAR2(255 BYTE) COLLATE USING_NLS_COMP, 
       DE_CONC_ITEM_ID  number,
       DE_CONC_VER_NR number(4,2),
       VAL_DOM_ITEM_ID number,
       VAL_DOM_VER_NR number(4,2),
      VAL_DOM_ITEM_ID_FND number,
       VAL_DOM_VER_NR_FND number(4,2),
       FORM_ITEM_ID  number,
       FORM_VER_NR   number(4,2),
       MOD_NM varchar2(255),
       PREF_QUEST_TXT varchar2(255),
    	BTCH_USR_NM  varchar2(100) not null,
        BTCH_NM  varchar2(100) not null,
        BTCH_SEQ_NBR  integer not null,
    	VAL_DOM_NM  varchar2(255) null,
	 PRIMARY KEY (STG_AI_ID));
		      
		      create or replace view VW_CNCPT 
  AS
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM,  ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.CREATION_DT, 
ADMIN_ITEM.EFF_DT, ADMIN_ITEM.ORIGIN,  ADMIN_ITEM.UNTL_DT,  ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, 
 ADMIN_ITEM.CREAT_DT, ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, ADMIN_ITEM.LST_UPD_DT, 
nvl(decode(ADMIN_ITEM.DEF_SRC, 'NCI', '1-NCI', ADMIN_ITEM.DEF_SRC), 'No Def Source') DEF_SRC,
		      decode(OBJ_KEY.OBJ_KEY_DESC, 'NCI_CONCEPT_CODE', '1-NCI_CONCEPT_CODE', 'NCI_META_CUI', '2-NCI_META_CUI', OBJ_KEY.OBJ_KEY_DESC) EVS_SRC
       FROM ADMIN_ITEM, CNCPT, OBJ_KEY
       WHERE ADMIN_ITEM_TYP_ID = 49 and ADMIN_ITEM.ITEM_ID = CNCPT.ITEM_ID and ADMIN_ITEM.VER_NR = CNCPT.VER_NR
	and cncpt.EVS_SRC_ID = OBJ_KEY.OBJ_KEY_ID (+) and admin_item.admin_stus_nm_dn = 'RELEASED';

		      
		      alter table nci_dload_als modify (PV_VM_IND number default null);
		      
