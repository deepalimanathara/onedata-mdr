

alter table nci_quest_valid_value drop primary key;

alter table nci_quest_valid_value add primary key (NCI_PUB_ID, NCI_VER_NR);

alter table obj_key add (DISP_ORD integer null);

create unique index UX_PERM_VAL on PERM_VAL (VAL_DOM_ITEM_ID, VAL_DOM_VER_NR, PERM_VAL_NM, NCI_VAL_MEAN_ITEM_ID, NCI_VAL_MEAN_VER_NR);

alter table NCI_STG_ADMIN_ITEM add (STRT_OBJ_CLS_ITEM_ID  number, STRT_OBJ_CLS_VER_NR number(4,2), STRT_PROP_ITEM_ID  number, STRT_PROP_VER_NR number(4,2));


alter table NCI_STG_ADMIN_ITEM add (STRT_DE_CONC_ITEM_ID  number, STRT_DE_CONC_VER_NR number(4,2));
											     
											     
alter table NCI_ADMIN_ITEM_REL_ALT_KEY add (ITEM_NM  varchar2(30) null);


drop view vw_cncpt;
create materialized view VW_CNCPT 
  BUILD IMMEDIATE
  REFRESH FORCE
  ON COMMIT AS
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM,  ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.CREATION_DT, 
ADMIN_ITEM.EFF_DT, ADMIN_ITEM.ORIGIN,  ADMIN_ITEM.UNTL_DT,  ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, 
 ADMIN_ITEM.CREAT_DT, ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, ADMIN_ITEM.LST_UPD_DT, 
ADMIN_ITEM.DEF_SRC, OBJ_KEY.OBJ_KEY_DESC EVS_SRC
       FROM ADMIN_ITEM, CNCPT, OBJ_KEY
       WHERE ADMIN_ITEM_TYP_ID = 49 and ADMIN_ITEM.ITEM_ID = CNCPT.ITEM_ID and ADMIN_ITEM.VER_NR = CNCPT.VER_NR
	and cncpt.EVS_SRC_ID = OBJ_KEY.OBJ_KEY_ID (+);
 
drop view VW_CONC_DOM;

CREATE MATERIALIZED VIEW VW_CONC_DOM
  BUILD IMMEDIATE
  REFRESH FORCE
  ON COMMIT AS
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 1;


drop view vw_rep_cls;


CREATE MATERIALIZED VIEW VW_REP_CLS
  BUILD IMMEDIATE
  REFRESH FORCE
  ON COMMIT AS
SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 7;

drop  view VW_CLSFCTN_SCHM;

CREATE MATERIALIZED VIEW VW_CLSFCTN_SCHM
  BUILD IMMEDIATE
  REFRESH FORCE
  ON COMMIT AS
SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT, CS.CLSFCTN_SCHM_TYP_ID, ADMIN_ITEM.NCI_IDSEQ, ADMIN_ITEM.CNTXT_ITEM_ID, ADMIN_ITEM.CNTXT_VER_NR
FROM ADMIN_ITEM, CLSFCTN_SCHM CS
       WHERE ADMIN_ITEM_TYP_ID = 9 and ADMIN_ITEM.ITEM_ID = CS.ITEM_ID and ADMIN_ITEM.VER_NR = CS.VER_NR;


drop view VW_CLSFCTN_SCHM_ITEM;

CREATE MATERIALIZED VIEW VW_CLSFCTN_SCHM_ITEM
  BUILD IMMEDIATE
  REFRESH FORCE
  ON COMMIT AS
 SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM,  ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT, ADMIN_ITEM.NCI_IDSEQ
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 51;



drop table VW_CNTXT;

CREATE MATERIALIZED VIEW VW_CNTXT
  BUILD IMMEDIATE
  REFRESH FORCE
  ON COMMIT AS
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC,
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT, C.NCI_PRG_AREA_ID
FROM ADMIN_ITEM, CNTXT C
       WHERE ADMIN_ITEM_TYP_ID = 8 and ADMIN_ITEM.ITEM_ID = C.ITEM_ID and ADMIN_ITEM.VER_NR = C.VER_NR;


  CREATE OR REPLACE  VIEW VW_NCI_DE_HORT AS
  SELECT 
	ADMIN_ITEM.ITEM_ID ITEM_ID, 
	ADMIN_ITEM.VER_NR, 
	ADMIN_ITEM.ITEM_NM, 
	ADMIN_ITEM.ITEM_LONG_NM, 
	ADMIN_ITEM.ITEM_DESC, 
	ADMIN_ITEM.CNTXT_NM_DN, 
	ADMIN_ITEM.ORIGIN, 
	ADMIN_ITEM.UNTL_DT, 
	ADMIN_ITEM.CURRNT_VER_IND, 
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
	DE.CREAT_USR_ID, 
	DE.LST_UPD_USR_ID, 
	DE.FLD_DELETE, 
	DE.LST_DEL_DT, 
	DE.S2P_TRN_DT, 
	DE.LST_UPD_DT, 
	DE.CREAT_DT, 
	DE.CREAT_USR_ID CREAT_USR_ID_API, 
	DE.LST_UPD_USR_ID LST_UPD_USR_ID_API, 
	DE.CREAT_DT CREAT_DT_API, 
	DE.LST_UPD_DT LST_UPD_DT_API, 
	VALUE_DOM.CONC_DOM_VER_NR, 
	VALUE_DOM.CONC_DOM_ITEM_ID, 
	VALUE_DOM.NON_ENUM_VAL_DOM_DESC, 
	VALUE_DOM.UOM_ID, 
	VALUE_DOM.VAL_DOM_TYP_ID VAL_DOM_TYP_ID, 
	VALUE_DOM.VAL_DOM_MIN_CHAR, 
	VALUE_DOM.VAL_DOM_MAX_CHAR, 
	VALUE_DOM.VAL_DOM_FMT_ID, 
	VALUE_DOM.CHAR_SET_ID, 
	VALUE_DOM.CREAT_DT VALUE_DOM_CREAT_DT, 
	VALUE_DOM.CREAT_USR_ID VALUE_DOM_USR_ID, 
	VALUE_DOM.LST_UPD_USR_ID VALUE_DOM_LST_UPD_USR_ID, 
	VALUE_DOM.LST_UPD_DT VALUE_DOM_LST_UPD_DT,
	VALUE_DOM_AI.ITEM_NM VALUE_DOM_ITEM_NM, 
	VALUE_DOM_AI.ITEM_LONG_NM VALUE_DOM_ITEM_LONG_NM, 
	VALUE_DOM_AI.ITEM_DESC  VALUE_DOM_ITEM_DESC, 
	VALUE_DOM_AI.CNTXT_NM_DN VALUE_DOM_CNTXT_NM, 
	VALUE_DOM_AI.CURRNT_VER_IND VALUE_DOM_CURRNT_VER_IND, 
	VALUE_DOM_AI.REGSTR_STUS_NM_DN VALUE_DOM_REGSTR_STUS_NM, 
	VALUE_DOM_AI.ADMIN_STUS_NM_DN VALUE_DOM_ADMIN_STUS_NM, 
	VALUE_DOM.NCI_STD_DTTYPE_ID,
    VALUE_DOM.DTTYPE_ID,
	ADMIN_ITEM.REGSTR_AUTH_ID,
	DEC_AI.ITEM_NM DEC_ITEM_NM, 
	DEC_AI.ITEM_LONG_NM DEC_ITEM_LONG_NM, 
	DEC_AI.ITEM_DESC  DEC_ITEM_DESC, 
	DEC_AI.CNTXT_NM_DN DEC_CNTXT_NM, 
	DEC_AI.CURRNT_VER_IND DEC_CURRNT_VER_IND, 
	DEC_AI.REGSTR_STUS_NM_DN DEC_REGSTR_STUS_NM, 
	DEC_AI.ADMIN_STUS_NM_DN DEC_ADMIN_STUS_NM, 
	DEC_AI.CREAT_DT DEC_CREAT_DT, 
	DEC_AI.CREAT_USR_ID DEC_USR_ID, 
	DEC_AI.LST_UPD_USR_ID DEC_LST_UPD_USR_ID, 
	DEC_AI.LST_UPD_DT DEC_LST_UPD_DT,
	DE_CONC.OBJ_CLS_ITEM_ID,
	DE_CONC.OBJ_CLS_VER_NR,
        OC.ITEM_NM OBJ_CLS_ITEM_NM,
        OC.ITEM_LONG_NM OBJ_CLS_ITEM_LONG_NM,
        PROP.ITEM_NM PROP_ITEM_NM,
        PROP.ITEM_LONG_NM PROP_ITEM_LONG_NM,
	DE_CONC.PROP_ITEM_ID,
	DE_CONC.PROP_VER_NR,
	DE_CONC.CONC_DOM_ITEM_ID DEC_CD_ITEM_ID,
	DE_CONC.CONC_DOM_VER_NR DEC_CD_VER_NR,
	DEC_CD.ITEM_NM DEC_CD_ITEM_NM, 
	DEC_CD.ITEM_LONG_NM DEC_CD_ITEM_LONG_NM, 
	DEC_CD.ITEM_DESC  DEC_CD_ITEM_DESC, 
	DEC_CD.CNTXT_NM_DN DEC_CD_CNTXT_NM, 
	DEC_CD.CURRNT_VER_IND DEC_CD_CURRNT_VER_IND, 
	DEC_CD.REGSTR_STUS_NM_DN DEC_CD_REGSTR_STUS_NM, 
	DEC_CD.ADMIN_STUS_NM_DN DEC_CD_ADMIN_STUS_NM, 
	CD_AI.ITEM_NM CD_ITEM_NM, 
	CD_AI.ITEM_LONG_NM CD_ITEM_LONG_NM, 
	CD_AI.ITEM_DESC  CD_ITEM_DESC, 
	CD_AI.CNTXT_NM_DN CD_CNTXT_NM, 
	CD_AI.CURRNT_VER_IND CD_CURRNT_VER_IND, 
	CD_AI.REGSTR_STUS_NM_DN CD_REGSTR_STUS_NM, 
	CD_AI.ADMIN_STUS_NM_DN CD_ADMIN_STUS_NM, 
	       ADMIN_ITEM.ADMIN_ITEM_TYP_ID ,
        '' CNTXT_AGG,
        SYSDATE - greatest(DE.LST_UPD_DT, admin_item.lst_upd_dt, Value_dom.LST_UPD_DT, dec_ai.LST_UPD_DT) LST_UPD_CHG_DAYS
       FROM ADMIN_ITEM, DE,  VALUE_DOM, ADMIN_ITEM VALUE_DOM_AI, 
	ADMIN_ITEM DEC_AI, DE_CONC, VW_CONC_DOM DEC_CD,
	VW_CONC_DOM CD_AI, ADMIN_ITEM OC, ADMIN_ITEM PROP
       WHERE ADMIN_ITEM.ADMIN_ITEM_TYP_ID = 4
AND DE.ITEM_ID = ADMIN_ITEM.ITEM_ID
and DE.VER_NR = ADMIN_ITEM.VER_NR
and DE.VAL_DOM_ITEM_ID = VALUE_DOM_AI.ITEM_ID
and DE.VAL_DOM_VER_NR = VALUE_DOM_AI.VER_NR
and DE.VAL_DOM_ITEM_ID = VALUE_DOM.ITEM_ID
and DE.VAL_DOM_VER_NR = VALUE_DOM.VER_NR
and DE.DE_CONC_ITEM_ID = DEC_AI.ITEM_ID
and DE.DE_CONC_VER_NR = DEC_AI.VER_NR
and DE.DE_CONC_ITEM_ID = DE_CONC.ITEM_ID
and DE_CONC.OBJ_CLS_ITEM_ID = OC.ITEM_ID
and DE_CONC.OBJ_CLS_VER_NR = OC.VER_NR
and DE_CONC.PROP_ITEM_ID = PROP.ITEM_ID
and DE_CONC.PROP_VER_NR = PROP.VER_NR
and DE.DE_CONC_VER_NR = DE_CONC.VER_NR
and DE_CONC.CONC_DOM_ITEM_ID = DEC_CD.ITEM_ID
and DE_CONC.CONC_DOM_VER_NR = DEC_CD.VER_NR
and VALUE_DOM.CONC_DOM_ITEM_ID = CD_AI.ITEM_ID
and VALUE_DOM.CONC_DOM_VER_NR = CD_AI.VER_NR;



  CREATE OR REPLACE  VIEW VW_NCI_DE_CNCPT AS
  SELECT  '5. Object Class' ALT_NMS_LVL, DE.ITEM_ID  DE_ITEM_ID, 
		DE.VER_NR DE_VER_NR,
		a.ITEM_ID, a.VER_NR, 
		a.CNCPT_ITEM_ID, a.CNCPT_VER_NR, 
		a.CREAT_DT, a.CREAT_USR_ID, a.LST_UPD_USR_ID, 
		a.FLD_DELETE, a.LST_DEL_DT, a.S2P_TRN_DT, 
		a.LST_UPD_DT, a.NCI_ORD, a.NCI_PRMRY_IND, a.NCI_CNCPT_VAL
       FROM CNCPT_ADMIN_ITEM a, DE, DE_CONC where 
	a.ITEM_ID = DE_CONC.OBJ_CLS_ITEM_ID and
	a.VER_NR = DE_CONC.OBJ_CLS_VER_NR and
	DE.DE_CONC_ITEM_ID = DE_CONC.ITEM_ID and
	DE.DE_CONC_VER_NR = DE_CONC.VER_NR
	union
         SELECT '4. Property' ALT_NMS_LVL, DE.ITEM_ID  DE_ITEM_ID, 
		DE.VER_NR DE_VER_NR,
		a.ITEM_ID, a.VER_NR, 
		a.CNCPT_ITEM_ID, a.CNCPT_VER_NR, 
        	a.CREAT_DT, a.CREAT_USR_ID, a.LST_UPD_USR_ID, 
		a.FLD_DELETE, a.LST_DEL_DT, a.S2P_TRN_DT, 
		a.LST_UPD_DT, a.NCI_ORD, a.NCI_PRMRY_IND, a.NCI_CNCPT_VAL
       FROM CNCPT_ADMIN_ITEM a, DE, DE_CONC where 
	a.ITEM_ID = DE_CONC.PROP_ITEM_ID and
	a.VER_NR = DE_CONC.PROP_VER_NR and
	DE.DE_CONC_ITEM_ID = DE_CONC.ITEM_ID and
	DE.DE_CONC_VER_NR = DE_CONC.VER_NR
	union
         SELECT '3. Representation Term' ALT_NMS_LVL, DE.ITEM_ID  DE_ITEM_ID, 
		DE.VER_NR DE_VER_NR,
		a.ITEM_ID, a.VER_NR, 
		a.CNCPT_ITEM_ID, a.CNCPT_VER_NR, 
        	a.CREAT_DT, a.CREAT_USR_ID, a.LST_UPD_USR_ID, 
		a.FLD_DELETE, a.LST_DEL_DT, a.S2P_TRN_DT, 
		a.LST_UPD_DT, a.NCI_ORD, a.NCI_PRMRY_IND, a.NCI_CNCPT_VAL
       FROM CNCPT_ADMIN_ITEM a, DE, VALUE_DOM VD where 
	a.ITEM_ID = VD.REP_CLS_ITEM_ID and
	a.VER_NR = VD.REP_CLS_VER_NR and
	DE.VAL_DOM_ITEM_ID = VD.ITEM_ID and
	DE.VAL_DOM_VER_NR = VD.VER_NR
	union
         SELECT '1. Value Meaning' ALT_NMS_LVL, DE.ITEM_ID  DE_ITEM_ID, 
		DE.VER_NR DE_VER_NR,
		a.ITEM_ID, a.VER_NR, 
		a.CNCPT_ITEM_ID, a.CNCPT_VER_NR, 
        	a.CREAT_DT, a.CREAT_USR_ID, a.LST_UPD_USR_ID, 
		a.FLD_DELETE, a.LST_DEL_DT, a.S2P_TRN_DT, 
		a.LST_UPD_DT, a.NCI_ORD, a.NCI_PRMRY_IND, a.NCI_CNCPT_VAL
       FROM CNCPT_ADMIN_ITEM a, DE, PERM_VAL PV where 
	a.ITEM_ID = PV.NCI_VAL_MEAN_ITEM_ID and
	a.VER_NR = PV.NCI_VAL_MEAN_VER_NR and
	DE.VAL_DOM_ITEM_ID = PV.VAL_DOM_ITEM_ID and
	DE.VAL_DOM_VER_NR = PV.VAL_DOM_VER_NR
	union
         SELECT '2. Value Domain' ALT_NMS_LVL, DE.ITEM_ID  DE_ITEM_ID, 
		DE.VER_NR DE_VER_NR,
		a.ITEM_ID, a.VER_NR, 
		a.CNCPT_ITEM_ID, a.CNCPT_VER_NR, 
        	a.CREAT_DT, a.CREAT_USR_ID, a.LST_UPD_USR_ID, 
		a.FLD_DELETE, a.LST_DEL_DT, a.S2P_TRN_DT, 
		a.LST_UPD_DT, a.NCI_ORD, a.NCI_PRMRY_IND, a.NCI_CNCPT_VAL
       FROM CNCPT_ADMIN_ITEM a, DE where 
	DE.VAL_DOM_ITEM_ID = a.ITEM_ID and
	DE.VAL_DOM_VER_NR = a.VER_NR;



  CREATE OR REPLACE  VIEW VW_NCI_CSI_NODE AS
  SELECT NODE.NCI_PUB_ID, NODE.NCI_VER_NR, CSI.ITEM_ID, CSI.VER_NR, CSI.ITEM_NM, CSI.ITEM_LONG_NM, CSI.ITEM_DESC, 
CSI.CNTXT_NM_DN, CSI.CURRNT_VER_IND, CSI.REGSTR_STUS_NM_DN, CSI.ADMIN_STUS_NM_DN, NODE.CREAT_DT, 
NODE.CREAT_USR_ID, NODE.LST_UPD_USR_ID, NODE.FLD_DELETE, NODE.LST_DEL_DT, NODE.S2P_TRN_DT, 
NODE.LST_UPD_DT,
cs.item_id cs_item_id, cs.ver_nr cs_ver_nr , cs.item_long_nm cs_long_nm, cs.item_nm cs_item_nm, cs.item_desc cs_item_desc,
pcsi.item_id pcsi_item_id, pcsi.ver_nr pcsi_ver_nr, pcsi.item_long_nm pcsi_long_nm, pcsi.item_nm pcsi_item_nm, cs.admin_stus_nm_dn cs_admin_stus_nm_dn,CS.CLSFCTN_SCHM_TYP_ID
FROM VW_CLSFCTN_SCHM_ITEM CSI, NCI_ADMIN_ITEM_REL_ALT_KEY NODE, VW_CLSFCTN_SCHM CS, VW_CLSFCTN_SCHM_ITEM PCSI
       WHERE  node.c_item_id = csi.item_id and node.c_item_ver_nr = csi.ver_nr
       and node.cntxt_cs_item_id = cs.item_id and node.cntxt_cs_Ver_nr = cs.ver_nr
       and node.rel_typ_id = 64
       and node.p_item_id = pcsi.item_id (+)
       and node.p_item_ver_nr = pcsi.ver_nr (+);


  CREATE OR REPLACE  VIEW VW_OBJ_CLS AS
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC,
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT, e.CNCPT_CONCAT, e.CNCPT_CONCAT_NM
FROM ADMIN_ITEM, NCI_ADMIN_ITEM_EXT e
       WHERE ADMIN_ITEM_TYP_ID = 5 and ADMIN_ITEM.ITEM_ID = e.ITEM_ID and ADMIN_ITEM.VER_NR = e.VER_NR;



  CREATE OR REPLACE  VIEW VW_PROP AS
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT, e.CNCPT_CONCAT, e.CNCPT_CONCAT_NM
FROM ADMIN_ITEM, NCI_ADMIN_ITEM_EXT e
       WHERE ADMIN_ITEM_TYP_ID = 6 and ADMIN_ITEM.ITEM_ID = e.ITEM_ID and ADMIN_ITEM.VER_NR = e.VER_NR;



  CREATE OR REPLACE  VIEW VW_VALUE_DOM AS
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN,  ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN,  VALUE_DOM.DTTYPE_ID, VALUE_DOM.VAL_DOM_MAX_CHAR, VALUE_DOM.CONC_DOM_VER_NR, VALUE_DOM.CONC_DOM_ITEM_ID, 
VALUE_DOM.NON_ENUM_VAL_DOM_DESC, VALUE_DOM.UOM_ID, VALUE_DOM.VAL_DOM_TYP_ID, VALUE_DOM.VAL_DOM_MIN_CHAR, VALUE_DOM.VAL_DOM_FMT_ID, 
VALUE_DOM.CHAR_SET_ID, VALUE_DOM.CREAT_DT, VALUE_DOM.CREAT_USR_ID, VALUE_DOM.LST_UPD_USR_ID, 
VALUE_DOM.FLD_DELETE, VALUE_DOM.LST_DEL_DT, VALUE_DOM.S2P_TRN_DT, VALUE_DOM.LST_UPD_DT , RC.ITEM_NM  REP_TERM_ITEM_NM
FROM ADMIN_ITEM, VALUE_DOM, VW_REP_CLS RC
       WHERE ADMIN_ITEM.ADMIN_ITEM_TYP_ID = 3
AND ADMIN_ITEM.ITEM_ID = VALUE_DOM.ITEM_ID
AND ADMIN_ITEM.VER_NR=VALUE_DOM.VER_NR and
VALUE_DOM.REP_CLS_ITEM_ID = RC.ITEM_ID (+) and 
VALUE_DOM.REP_CLS_VER_NR = RC.VER_NR (+);

  CREATE OR REPLACE VIEW VW_VAL_MEAN AS
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM,  ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT, ext.cncpt_concat, ext.cncpt_concat_nm, nvl(admin_item.origin_id_dn, origin) ORIGIN_NM
FROM ADMIN_ITEM, NCI_ADMIN_ITEM_EXT ext
       WHERE ADMIN_ITEM_TYP_ID = 53 and admin_item.item_id = ext.item_id and admin_item.ver_nr = ext.ver_nr;

/*
alter table ADMIN_ITEM modify (LST_UPD_DT null);
alter table ALT_DEF modify (LST_UPD_DT null);
alter table ALT_NMS modify (LST_UPD_DT null);
alter table CHAR_SET modify (LST_UPD_DT null);
alter table CLSFCTN_SCHM modify (LST_UPD_DT null);
alter table CNCPT modify (LST_UPD_DT null);
alter table CNTCT modify (LST_UPD_DT null);
alter table CNTXT modify (LST_UPD_DT null);
alter table CONC_DOM modify (LST_UPD_DT null);
alter table DATA_TYP modify (LST_UPD_DT null);
alter table DE modify (LST_UPD_DT null);
alter table DE_CONC modify (LST_UPD_DT null);
alter table FMT modify (LST_UPD_DT null);
alter table LANG modify (LST_UPD_DT null);
alter table OBJ_CLS modify (LST_UPD_DT null);
alter table OBJ_KEY modify (LST_UPD_DT null);
alter table OBJ_TYP modify (LST_UPD_DT null);
alter table ORG modify (LST_UPD_DT null);
alter table ORG_CNTCT modify (LST_UPD_DT null);
alter table PERM_VAL modify (LST_UPD_DT null);
alter table PROP modify (LST_UPD_DT null);
alter table REF modify (LST_UPD_DT null);
alter table REF_DOC modify (LST_UPD_DT null);
alter table REP_CLS modify (LST_UPD_DT null);
alter table STUS_MSTR modify (LST_UPD_DT null);
alter table UOM modify (LST_UPD_DT null);
alter table USR_GRP modify (LST_UPD_DT null);
alter table VAL_MEAN modify (LST_UPD_DT null);
alter table CONC_DOM_VAL_MEAN modify (LST_UPD_DT null);
alter table NCI_ADMIN_ITEM_REL modify (LST_UPD_DT null);
alter table NCI_ALT_KEY_ADMIN_ITEM_REL modify (LST_UPD_DT null);
alter table NCI_CLSFCTN_SCHM_ITEM modify (LST_UPD_DT null);
alter table NCI_VAL_MEAN modify (LST_UPD_DT null);
alter table NCI_PROTCL modify (LST_UPD_DT null);
alter table NCI_ADMIN_ITEM_REL_ALT_KEY modify (LST_UPD_DT null);
alter table NCI_INSTR modify (LST_UPD_DT null);
alter table NCI_STG_ADMIN_ITEM modify (LST_UPD_DT null);
alter table NCI_FORM modify (LST_UPD_DT null);
alter table NCI_OC_RECS modify (LST_UPD_DT null);
alter table NCI_QUEST_VALID_VALUE modify (LST_UPD_DT null);
alter table NCI_CSI_ALT_DEFNMS modify (LST_UPD_DT null);
alter table NCI_QUEST_VV_REP modify (LST_UPD_DT null);
alter table NCI_FORM_TA modify (LST_UPD_DT null);
alter table NCI_USR_CART modify (LST_UPD_DT null);
alter table NCI_STG_AI_CNCPT modify (LST_UPD_DT null);
alter table VALUE_DOM modify (LST_UPD_DT null);
alter table CNCPT_ADMIN_ITEM modify (LST_UPD_DT null);
alter table NCI_ADMIN_ITEM_EXT modify (LST_UPD_DT null);
*/


  CREATE OR REPLACE VIEW VW_NCI_MODULE_DE AS
  select frm.item_long_nm frm_item_long_nm, frm.item_nm frm_item_nm, frm.item_id frm_item_id, frm.ver_nr frm_ver_nr, 
air.p_item_id mod_item_id, air.p_item_ver_nr mod_ver_nr,
 air.c_item_id de_item_id, air.c_item_ver_nr de_ver_nr, air.disp_ord,
aim.item_nm MOD_ITEM_NM,
 aim.item_long_nm  mod_item_long_nm, aim.item_desc mod_item_desc,
'QUESTION' admin_item_typ_nm, air.nci_pub_id,air.nci_ver_nr, 
air.CREAT_DT, air.CREAT_USR_ID, air.LST_UPD_USR_ID, air.FLD_DELETE, air.LST_DEL_DT, air.S2P_TRN_DT, air.LST_UPD_DT, air.item_long_nm QUEST_LONG_TXT, air.item_nm QUEST_TXT
from  nci_admin_item_rel_alt_key air, admin_item aim,
admin_item frm, nci_admin_item_rel frm_mod 
where  air.rel_typ_id = 63
and aim.item_id = air.p_item_id and aim.ver_nr = air.p_item_ver_nr
and frm.item_id = frm_mod.p_item_id and frm.ver_nr = frm_mod.p_item_ver_nr and aim.item_id = frm_mod.c_item_id and aim.ver_nr = frm_mod.c_item_ver_nr
and frm_mod.rel_typ_id in (61,62) 
and frm.admin_item_typ_id in ( 54,55); 


  CREATE OR REPLACE VIEW VW_NCI_CSI_NODE AS
  SELECT NODE.NCI_PUB_ID, NODE.NCI_VER_NR, CSI.ITEM_ID, CSI.VER_NR, CSI.ITEM_NM, CSI.ITEM_LONG_NM, CSI.ITEM_DESC, 
CSI.CNTXT_NM_DN, CSI.CURRNT_VER_IND, CSI.REGSTR_STUS_NM_DN, CSI.ADMIN_STUS_NM_DN, NODE.CREAT_DT, 
NODE.CREAT_USR_ID, NODE.LST_UPD_USR_ID, NODE.FLD_DELETE, NODE.LST_DEL_DT, NODE.S2P_TRN_DT, 
NODE.LST_UPD_DT, cs.CNTXT_ITEM_ID, CS.CNTXT_VER_NR,
cs.item_id cs_item_id, cs.ver_nr cs_ver_nr , cs.item_long_nm cs_long_nm, cs.item_nm cs_item_nm, cs.item_desc cs_item_desc,
pcsi.item_id pcsi_item_id, pcsi.ver_nr pcsi_ver_nr, pcsi.item_long_nm pcsi_long_nm, pcsi.item_nm pcsi_item_nm, cs.admin_stus_nm_dn cs_admin_stus_nm_dn,CS.CLSFCTN_SCHM_TYP_ID
FROM VW_CLSFCTN_SCHM_ITEM CSI, NCI_ADMIN_ITEM_REL_ALT_KEY NODE, VW_CLSFCTN_SCHM CS, VW_CLSFCTN_SCHM_ITEM PCSI
       WHERE  node.c_item_id = csi.item_id and node.c_item_ver_nr = csi.ver_nr
       and node.cntxt_cs_item_id = cs.item_id and node.cntxt_cs_Ver_nr = cs.ver_nr
       and node.rel_typ_id = 64
       and node.p_item_id = pcsi.item_id (+)
       and node.p_item_ver_nr = pcsi.ver_nr (+);
                                                                                                       


create or replace view VW_CSI_NODE_DE_REL as 
select ak.NCI_PUB_ID, ak.NCI_VER_NR, ak.CREAT_DT, ak.CREAT_USR_ID, ak.LST_UPD_USR_ID, ak.LST_UPD_DT, ak.S2P_TRN_DT, ak.LST_DEL_DT, ak.FLD_DELETE,
ai.ITEM_NM, ai.ITEM_LONG_NM, ai.ITEM_ID, ai.VER_NR, ai.ITEM_DESC
from NCI_ALT_KEY_ADMIN_ITEM_REL ak, ADMIN_ITEM ai
where ak.C_ITEM_ID  = ai.ITEM_ID and ak.C_ITEM_VER_NR  = ai.VER_NR and ai.ADMIN_ITEM_TYP_ID = 4;

create or replace view VW_CSI_NODE_DEC_REL as 
select ak.NCI_PUB_ID, ak.NCI_VER_NR, ak.CREAT_DT, ak.CREAT_USR_ID, ak.LST_UPD_USR_ID, ak.LST_UPD_DT, ak.S2P_TRN_DT, ak.LST_DEL_DT, ak.FLD_DELETE,
ai.ITEM_NM, ai.ITEM_LONG_NM, ai.ITEM_ID, ai.VER_NR, ai.ITEM_DESC
from NCI_ALT_KEY_ADMIN_ITEM_REL ak, ADMIN_ITEM ai
where ak.C_ITEM_ID  = ai.ITEM_ID and ak.C_ITEM_VER_NR  = ai.VER_NR and ai.ADMIN_ITEM_TYP_ID = 2;


create or replace view VW_CSI_NODE_VD_REL as 
select ak.NCI_PUB_ID, ak.NCI_VER_NR, ak.CREAT_DT, ak.CREAT_USR_ID, ak.LST_UPD_USR_ID, ak.LST_UPD_DT, ak.S2P_TRN_DT, ak.LST_DEL_DT, ak.FLD_DELETE,
ai.ITEM_NM, ai.ITEM_LONG_NM, ai.ITEM_ID, ai.VER_NR, ai.ITEM_DESC
from NCI_ALT_KEY_ADMIN_ITEM_REL ak, ADMIN_ITEM ai
where ak.C_ITEM_ID  = ai.ITEM_ID and ak.C_ITEM_VER_NR  = ai.VER_NR and ai.ADMIN_ITEM_TYP_ID = 3;


create or replace view VW_CSI_NODE_FORM_REL as 
select ak.NCI_PUB_ID, ak.NCI_VER_NR, ak.CREAT_DT, ak.CREAT_USR_ID, ak.LST_UPD_USR_ID, ak.LST_UPD_DT, ak.S2P_TRN_DT, ak.LST_DEL_DT, ak.FLD_DELETE,
ai.ITEM_NM, ai.ITEM_LONG_NM, ai.ITEM_ID, ai.VER_NR, ai.ITEM_DESC
from NCI_ALT_KEY_ADMIN_ITEM_REL ak, ADMIN_ITEM ai
where ak.C_ITEM_ID  = ai.ITEM_ID and ak.C_ITEM_VER_NR  = ai.VER_NR and ai.ADMIN_ITEM_TYP_ID = 54;

alter table alt_def modify (LST_UPD_DT default sysdate);


  CREATE TABLE NCI_STG_AI_REL
   (	
	STG_AI_ID NUMBER NOT NULL , 
	ITEM_ID NUMBER NOT NULL , 
	VER_NR NUMBER(4,2) NOT NULL , 
	LVL_NM VARCHAR2(10 BYTE) NOT NULL , 
	CREAT_DT DATE DEFAULT sysdate, 
	CREAT_USR_ID VARCHAR2(50 BYTE) DEFAULT user, 
	LST_UPD_USR_ID VARCHAR2(50 BYTE) DEFAULT user, 
	FLD_DELETE NUMBER(1,0) DEFAULT 0, 
	LST_DEL_DT DATE DEFAULT sysdate, 
	S2P_TRN_DT DATE DEFAULT sysdate, 
	LST_UPD_DT DATE DEFAULT sysdate, 
	 PRIMARY KEY (STG_AI_ID, ITEM_ID, VER_NR));


create or replace trigger TR_AI_EXT_TAB_INS
  AFTER INSERT
  on ADMIN_ITEM
  for each row
BEGIN

if (:new.admin_item_typ_id in (5,6)) then
insert into NCI_ADMIN_ITEM_EXT (ITEM_ID, VER_NR,CNCPT_CONCAT, CNCPT_CONCAT_NM, cncpt_concat_def )
select :new.item_id, :new.ver_nr, :new.item_long_nm, :new.item_nm, :new.item_desc from dual;
else
insert into NCI_ADMIN_ITEM_EXT (ITEM_ID, VER_NR)
select :new.ITEM_ID, :new.VER_NR from dual;
end if;
END;

create table NCI_STG_AI_CNCPT_CREAT
( STG_AI_ID  number not null primary key,
  CTL_VAL_MSG  varchar2(4000) null,
  GEN_STR   varchar2(255) null,
  CNCPT_CONCAT_STR_1  varchar2(4000) null,
  CNCPT_CONCAT_STR_2  varchar2(4000) null,
  ITEM_1_ID  number null,
  ITEM_1_VER_NR number(4,2) null,
  ITEM_2_ID number null,
  ITEM_2_VER_NR number(4,2) null, 
  ITEM_1_NM  varchar2(255) null,
  ITEM_1_LONG_NM varchar2(255) null,
  ITEM_1_DEF  varchar2(4000) null,
  ITEM_2_NM  varchar2(255) null,
  ITEM_2_LONG_NM varchar2(255) null,
  ITEM_2_DEF  varchar2(4000) null, 
  CONC_DOM_ITEM_ID number null,
  CONC_DOM_VER_NR  number(4,2) null,
       CNTXT_ITEM_ID        NUMBER NULL,
       CNTXT_VER_NR         NUMBER(4,2) NULL,
       ADMIN_STUS_ID        SMALLINT NULL,
       REGSTR_STUS_ID       SMALLINT NULL,
  CNCPT_1_ITEM_ID_1 number null,
  CNCPT_1_VER_NR_1 number(4,2)   null,
  CNCPT_1_ITEM_ID_2 number null,
  CNCPT_1_VER_NR_2 number(4,2)  null,
  CNCPT_1_ITEM_ID_3 number null,
  CNCPT_1_VER_NR_3 number(4,2) null,
  CNCPT_1_ITEM_ID_4 number null,
  CNCPT_1_VER_NR_4 number(4,2)  null,
  CNCPT_1_ITEM_ID_5 number null,
  CNCPT_1_VER_NR_5 number(4,2) null,
CNCPT_1_ITEM_ID_6 number null,
  CNCPT_1_VER_NR_6 number(4,2) null,
  CNCPT_1_ITEM_ID_7 number null,
  CNCPT_1_VER_NR_7 number(4,2) null,
  CNCPT_1_ITEM_ID_8 number null,
  CNCPT_1_VER_NR_8 number(4,2) null,
  CNCPT_1_ITEM_ID_9 number null,
  CNCPT_1_VER_NR_9 number(4,2) null,
  CNCPT_1_ITEM_ID_10 number null,
  CNCPT_1_VER_NR_10 number(4,2) null,
  CNCPT_2_ITEM_ID_1 number null,
  CNCPT_2_VER_NR_1 number(4,2)  null,
  CNCPT_2_ITEM_ID_2 number null,
  CNCPT_2_VER_NR_2 number(4,2) null,
  CNCPT_2_ITEM_ID_3 number null,
  CNCPT_2_VER_NR_3 number(4,2)  null,
  CNCPT_2_ITEM_ID_4 number null,
  CNCPT_2_VER_NR_4 number(4,2)  null,
  CNCPT_2_ITEM_ID_5 number null,
  CNCPT_2_VER_NR_5 number(4,2)  null,
  CNCPT_2_ITEM_ID_6 number null,
  CNCPT_2_VER_NR_6 number(4,2)  null,
  CNCPT_2_ITEM_ID_7 number null,
  CNCPT_2_VER_NR_7 number(4,2)  null,
  CNCPT_2_ITEM_ID_8 number null,
  CNCPT_2_VER_NR_8 number(4,2)  null,
  CNCPT_2_ITEM_ID_9 number null,
  CNCPT_2_VER_NR_9 number(4,2)  null,
  CNCPT_2_ITEM_ID_10 number null,
  CNCPT_2_VER_NR_10 number(4,2) null,
       CREAT_DT             DATE DEFAULT sysdate NULL,
       CREAT_USR_ID         VARCHAR2(50) DEFAULT user NULL,
       LST_UPD_USR_ID       VARCHAR2(50) DEFAULT user NULL,
       FLD_DELETE           NUMBER(1) DEFAULT 0 NULL,
       LST_DEL_DT           DATE DEFAULT sysdate NULL,
       S2P_TRN_DT           DATE DEFAULT sysdate NULL,
       LST_UPD_DT           DATE DEFAULT sysdate NULL
);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
