CREATE OR REPLACE  VIEW VW_CLSFCTN_SCHM_ITEM As
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.NCI_ITEM_NM, ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 51;



CREATE OR REPLACE  VIEW VW_CSI_NODE As
  SELECT NODE.NCI_PUB_ID, NODE.NCI_VER_NR, CSI.ITEM_ID, CSI.VER_NR, CSI.ITEM_NM, CSI.ITEM_LONG_NM, CSI.ITEM_DESC, 
CSI.CNTXT_NM_DN, CSI.CURRNT_VER_IND, CSI.REGSTR_STUS_NM_DN, CSI.ADMIN_STUS_NM_DN, NODE.CREAT_DT, 
NODE.CREAT_USR_ID, NODE.LST_UPD_USR_ID, NODE.FLD_DELETE, NODE.LST_DEL_DT, NODE.S2P_TRN_DT, 
NODE.LST_UPD_DT,
cs.item_id cs_item_id, cs.ver_nr cs_ver_nr , cs.item_long_nm cs_long_nm, cs.item_desc cs_item_desc,
pcsi.item_id pcsi_item_id, pcsi.ver_nr pcsi_ver_nr, pcsi.item_long_nm pcsi_long_nm
FROM ADMIN_ITEM CSI, NCI_ADMIN_ITEM_REL_ALT_KEY NODE, ADMIN_ITEM CS, ADMIN_ITEM PCSI
       WHERE csi.ADMIN_ITEM_TYP_ID = 51 and node.c_item_id = csi.item_id and node.c_item_ver_nr = csi.ver_nr
       and node.cntxt_cs_item_id = cs.item_id and node.cntxt_cs_Ver_nr = cs.ver_nr
       and node.rel_typ_id = 64
       and node.p_item_id = pcsi.item_id (+)
       and node.p_item_ver_nr = pcsi.ver_nr (+)
       and pcsi.admin_item_typ_id (+) = 51
       and cs.admin_item_typ_id = 9;
       

-- drop this?
CREATE OR REPLACE VIEW VW_NCI_CSI_NM AS
select  x.NCI_PUB_ID, x.NCI_VER_NR, ai.item_nm CSI_NM, ai.item_long_nm  csi_long_nm, cs.ITEM_NM CS_NM, cs.item_id cs_item_id, cs.ver_nr cs_ver_nr, ai.item_id csi_item_id,
       ai.ver_nr  csi_ver_nr, cs.item_long_nm ||  '/' || ai.item_long_nm CSI_FULL_NM,
       x.CREAT_DT, x.CREAT_USR_ID, x.LST_UPD_USR_ID, x.FLD_DELETE, x.LST_DEL_DT, x.S2P_TRN_DT, x.LST_UPD_DT
       from nci_admin_item_rel_alt_key x, admin_item ai , admin_item cs
       where  x.c_item_id = ai.item_id 
       and x.c_item_ver_nr = ai.ver_nr and x.cntxt_cs_item_id = cs.item_id and x.cntxt_cs_ver_nr = cs.ver_nr and
       x.rel_typ_id = 64;
              	

CREATE OR REPLACE VIEW VW_NCI_DE as
  select 
	ADMIN_ITEM.ITEM_ID, 
	ADMIN_ITEM.VER_NR, 
	ADMIN_ITEM.ITEM_NM, 
	ADMIN_ITEM.ITEM_LONG_NM, 
	ADMIN_ITEM.NCI_ITEM_NM, 
	ADMIN_ITEM.ITEM_DESC, 
	ADMIN_ITEM.ADMIN_NOTES, 
	ADMIN_ITEM.CHNG_DESC_TXT, 
	ADMIN_ITEM.CREATION_DT, 
	ADMIN_ITEM.EFF_DT, 
	ADMIN_ITEM.ORIGIN, 
	ADMIN_ITEM.UNRSLVD_ISSUE, 
	ADMIN_ITEM.UNTL_DT, 
	ADMIN_ITEM.CURRNT_VER_IND, 
	ADMIN_ITEM.REGSTR_STUS_ID, 
	ADMIN_ITEM.ADMIN_STUS_ID, 
	ADMIN_ITEM.REGSTR_STUS_NM_DN,
	ADMIN_ITEM.ADMIN_STUS_NM_DN,
	ADMIN_ITEM.CNTXT_NM_DN,
	ADMIN_ITEM.CNTXT_ITEM_ID,
	ADMIN_ITEM.CNTXT_VER_NR,
	ADMIN_ITEM.CREAT_USR_ID, 
	ADMIN_ITEM.LST_UPD_USR_ID, 
	ADMIN_ITEM.FLD_DELETE, 
	ADMIN_ITEM.LST_DEL_DT, 
	ADMIN_ITEM.S2P_TRN_DT, 
	ADMIN_ITEM.LST_UPD_DT, 
	ADMIN_ITEM.CREAT_DT,
ADMIN_ITEM.NCI_IDSEQ,
ADMIN_ITEM_TYP_ID,
  ext.USED_BY CNTXT_AGG,
	ref.ref_desc PREF_QUEST_TXT,
	    substr(ADMIN_ITEM.NCI_ITEM_NM || 	ADMIN_ITEM.ITEM_NM || nvl(ref.ref_desc, ''),1,4000)  SEARCH_STR 
from ADMIN_ITEM, 
NCI_ADMIN_ITEM_EXT ext,
 (select item_id, ver_nr, ref_desc from ref where ref_typ_id = 80) ref
  where ADMIN_ITEM_TYP_ID = 4 
--and ADMIN_ITEM.ITEM_Id = de.item_id 
--and ADMIN_ITEM.VER_NR = DE.VER_NR
and ADMIN_ITEM.ITEM_ID = EXT.ITEM_ID
and ADMIN_ITEM.VER_NR = EXT.VER_NR
and ADMIN_ITEM.ITEM_ID = REF.ITEM_ID(+)
and ADMIN_ITEM.VER_NR = REF.VER_NR(+);




  CREATE OR REPLACE  VIEW VW_OC_PROP AS
  select admin_item.item_id, admin_item.ver_nr, admin_item.item_nm, admin_item.item_long_nm,
admin_item.admin_item_typ_id,
CREAT_DT, CREAT_USR_ID, LST_UPD_USR_ID, FLD_DELETE, LST_DEL_DT, S2P_TRN_DT, LST_UPD_DT
, CNCPT_AGG.CNCPT_CD, CNCPT_AGG.CNCPT_NM from admin_item, (SELECT cai.item_id, cai.ver_nr, LISTAGG(ai.item_nm, ';')WITHIN GROUP (ORDER by cai.ITEM_ID) as CNCPT_CD , LISTAGG(ai.item_long_nm, ';') WITHIN GROUP (ORDER by cai.ITEM_ID) AS CNCPT_NM
from cncpt_admin_item cai, admin_item ai where ai.item_id = cai.cncpt_item_id and ai.ver_nr = cai.cncpt_ver_nr
group by cai.item_id, cai.ver_nr) CNCPT_AGG
where admin_item.item_id = cncpt_agg.item_id (+) and admin_item.ver_nr = cncpt_agg.ver_nr (+)
and admin_item.admin_item_typ_id in (5,6);


create or replace view VW_NCI_DE_PV
as
        SELECT PV.PERM_VAL_BEG_DT, PERM_VAL_END_DT, PERM_VAL_NM, PERM_VAL_DESC_TXT, 
              DE.ITEM_ID  DE_ITEM_ID, 
		DE.VER_NR DE_VER_NR, VM.ITEM_NM, VM.ITEM_LONG_NM, VM.NCI_ITEM_NM,
                VM.ITEM_DESC, NCI_VAL_MEAN_ITEM_ID, NCI_VAL_MEAN_VER_NR, 
		PV.CREAT_DT, PV.CREAT_USR_ID, PV.LST_UPD_USR_ID, PV.FLD_DELETE, PV.LST_DEL_DT, PV.S2P_TRN_DT, PV.LST_UPD_DT
       FROM  DE, PERM_VAL PV, ADMIN_ITEM VM where 
	PV.VAL_DOM_ITEM_ID = DE.VAL_DOM_ITEM_ID and
	PV.VAL_DOM_VER_NR = DE.VAL_DOM_VER_NR and
	PV.NCI_VAL_MEAN_ITEM_ID = vm.ITEM_ID and
	PV.NCI_VAL_MEAN_VER_NR = vm.VER_NR;



create or replace view vw_nci_form as
select air.p_item_id, air.p_item_ver_nr, ai.item_id, ai.ver_nr, ai.item_nm, ai.item_long_nm, ai.nci_item_nm, ai.item_desc, ai.cntxt_item_id, ai.cntxt_ver_nr,
'FORM' admin_item_typ_nm, f.catgry_id, f.FORM_TYP_ID, ai.admin_stus_id,
ai.CREAT_DT, ai.CREAT_USR_ID, ai.LST_UPD_USR_ID, ai.FLD_DELETE, ai.LST_DEL_DT, ai.S2P_TRN_DT, ai.LST_UPD_DT, air.disp_ord, air.rep_no
from admin_item ai, nci_admin_item_rel air, nci_form f where 
ai.item_id = air.c_item_id and ai.ver_nr = air.c_item_ver_nr and air.rel_typ_id = 60 and ai.item_id = f.item_id and ai.ver_nr = f.ver_nr; 




CREATE OR REPLACE VIEW VW_NCI_DE_HORT as
  SELECT 
	ADMIN_ITEM.ITEM_ID ITEM_ID, 
	ADMIN_ITEM.VER_NR, 
	ADMIN_ITEM.ITEM_NM, 
	ADMIN_ITEM.ITEM_LONG_NM, 
	ADMIN_ITEM.NCI_ITEM_NM, 
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
	VALUE_DOM.VAL_DOM_FMT_ID, 
	VALUE_DOM.CHAR_SET_ID, 
	VALUE_DOM.CREAT_DT VALUE_DOM_CREAT_DT, 
	VALUE_DOM.CREAT_USR_ID VALUE_DOM_USR_ID, 
	VALUE_DOM.LST_UPD_USR_ID VALUE_DOM_LST_UPD_USR_ID, 
	VALUE_DOM.LST_UPD_DT VALUE_DOM_LST_UPD_DT,
	VALUE_DOM_AI.ITEM_NM VALUE_DOM_ITEM_NM, 
	VALUE_DOM_AI.NCI_ITEM_NM VALUE_DOM_NCI_ITEM_NM, 
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
	DEC_AI.NCI_ITEM_NM DEC_NCI_ITEM_NM, 
	DEC_AI.ITEM_DESC  DEC_ITEM_DESC, 
	DEC_AI.CNTXT_NM_DN DEC_CNTXT_NM, 
	DEC_AI.CURRNT_VER_IND DEC_CURRNT_VER_IND, 
	DEC_AI.REGSTR_STUS_NM_DN DEC_REGSTR_STUS_NM, 
	DEC_AI.ADMIN_STUS_NM_DN DEC_ADMIN_STUS_NM, 
	DE_CONC.OBJ_CLS_ITEM_ID,
	DE_CONC.OBJ_CLS_VER_NR,
	DE_CONC.PROP_ITEM_ID,
	DE_CONC.PROP_VER_NR,
	CD_AI.ITEM_NM CD_ITEM_NM, 
	CD_AI.ITEM_LONG_NM CD_ITEM_LONG_NM, 
	CD_AI.NCI_ITEM_NM CD_NCI_ITEM_NM, 
	CD_AI.ITEM_DESC  CD_ITEM_DESC, 
	CD_AI.CNTXT_NM_DN CD_CNTXT_NM, 
	CD_AI.CURRNT_VER_IND CD_CURRNT_VER_IND, 
	CD_AI.REGSTR_STUS_NM_DN CD_REGSTR_STUS_NM, 
	CD_AI.ADMIN_STUS_NM_DN CD_ADMIN_STUS_NM, 
	       ADMIN_ITEM.ADMIN_ITEM_TYP_ID ,
        '' CNTXT_AGG,
        SYSDATE - greatest(DE.LST_UPD_DT, admin_item.lst_upd_dt, Value_dom.LST_UPD_DT, dec_ai.LST_UPD_DT) LST_UPD_CHG_DAYS
       FROM ADMIN_ITEM, DE,  VALUE_DOM, ADMIN_ITEM VALUE_DOM_AI, 
	ADMIN_ITEM DEC_AI, DE_CONC,
	ADMIN_ITEM CD_AI
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
and DE.DE_CONC_VER_NR = DE_CONC.VER_NR
and DE_CONC.CONC_DOM_ITEM_ID = CD_AI.ITEM_ID
and DE_CONC.CONC_DOM_VER_NR = CD_AI.VER_NR;

CREATE OR REPLACE VIEW VW_NCI_DEC_CNCPT AS
        SELECT  '2. Object Class' ALT_NMS_LVL, DEC.ITEM_ID  DEC_ITEM_ID, 
		DEC.VER_NR DEC_VER_NR,
		a.ITEM_ID, a.VER_NR, 
		a.CNCPT_ITEM_ID, a.CNCPT_VER_NR, 
		a.CREAT_DT, a.CREAT_USR_ID, a.LST_UPD_USR_ID, 
		a.FLD_DELETE, a.LST_DEL_DT, a.S2P_TRN_DT, 
		a.LST_UPD_DT, a.NCI_ORD, a.NCI_PRMRY_IND, a.NCI_CNCPT_VAL
       FROM CNCPT_ADMIN_ITEM a, DE_CONC DEC where 
	a.ITEM_ID = DEC.OBJ_CLS_ITEM_ID and
	a.VER_NR = DEC.OBJ_CLS_VER_NR
	union
         SELECT '1. Property' ALT_NMS_LVL, DEC.ITEM_ID  DEC_ITEM_ID, 
		DEC.VER_NR DEC_VER_NR,
		a.ITEM_ID, a.VER_NR, 
		a.CNCPT_ITEM_ID, a.CNCPT_VER_NR, 
        	a.CREAT_DT, a.CREAT_USR_ID, a.LST_UPD_USR_ID, 
		a.FLD_DELETE, a.LST_DEL_DT, a.S2P_TRN_DT, 
		a.LST_UPD_DT, a.NCI_ORD, a.NCI_PRMRY_IND, a.NCI_CNCPT_VAL
       FROM CNCPT_ADMIN_ITEM a, DE_CONC DEC where 
	a.ITEM_ID = DEC.PROP_ITEM_ID and
	a.VER_NR = DEC.PROP_VER_NR




CREATE OR REPLACE VIEW VW_NCI_ALT_NMS AS
       SELECT ALT_NMS.NM_ID, 'CDE' ALT_NMS_LVL, DE_AI.ITEM_ID  DE_ITEM_ID, 
		DE_AI.VER_NR DE_VER_NR,
		ALT_NMS.ITEM_ID, ALT_NMS.VER_NR, 
		ALT_NMS.CNTXT_ITEM_ID, ALT_NMS.CNTXT_VER_NR, 
		ALT_NMS.NM_DESC, 
        	ALT_NMS.PREF_NM_IND, ALT_NMS.LANG_ID, AGG.CSI_ALT_NMS,
		ALT_NMS.CREAT_DT, ALT_NMS.CREAT_USR_ID, ALT_NMS.LST_UPD_USR_ID, ALT_NMS.FLD_DELETE, ALT_NMS.LST_DEL_DT, ALT_NMS.S2P_TRN_DT, ALT_NMS.LST_UPD_DT, ALT_NMS.NM_TYP_ID
       FROM ALT_NMS, ADMIN_ITEM DE_AI,
       (select a.nm_id, listagg(cs.item_long_nm ||  '/' || ai.item_long_nm, chr(10)) within group (order by a.item_id) CSI_ALT_NMS
        from alt_nms a , NCI_CSI_ALT_DEFNMS n, nci_admin_item_rel_alt_key x, admin_item ai , admin_item cs, de
       where n.nmdef_id = a.nm_id and n.nci_pub_id = x.nci_pub_id and x.c_item_id = ai.item_id and a.item_id = de.item_id and a.ver_nr = de.ver_nr
       and x.c_item_ver_nr = ai.ver_nr and x.cntxt_cs_item_id = cs.item_id and x.cntxt_cs_ver_nr = cs.ver_nr
       group by a.nm_id) agg
 where DE_AI.ADMIN_ITEM_TYP_ID = 4 and
	ALT_NMS.ITEM_ID = DE_AI.ITEM_ID and
	ALT_NMS.VER_NR = DE_AI.VER_NR and upper(ALT_NMS.NM_DESC) <> upper(ALT_NMS.CNTXT_NM_DN) 
	and alt_nms.nm_id = agg.nm_id (+);      



CREATE OR REPLACE VIEW VW_NCI_ALT_DEF AS
       SELECT ALT_DEF.DEF_ID, 'CDE' ALT_DEF_LVL, DE_AI.ITEM_ID  DE_ITEM_ID, 
		DE_AI.VER_NR DE_VER_NR,
		ALT_DEF.ITEM_ID, ALT_DEF.VER_NR, 
		ALT_DEF.CNTXT_ITEM_ID, ALT_DEF.CNTXT_VER_NR, 
		ALT_DEF.DEF_DESC, ALT_DEF.NCI_DEF_TYP_ID,
        	ALT_DEF.PREF_DEF_IND, ALT_DEF.LANG_ID, AGG.CSI_ALT_DEFS,
		ALT_DEF.CREAT_DT, ALT_DEF.CREAT_USR_ID, ALT_DEF.LST_UPD_USR_ID, ALT_DEF.FLD_DELETE, 
        ALT_DEF.LST_DEL_DT, ALT_DEF.S2P_TRN_DT, ALT_DEF.LST_UPD_DT
       FROM ALT_DEF, ADMIN_ITEM DE_AI,
      (select a.def_id, listagg(cs.item_long_nm ||  '/' || ai.item_long_nm, chr(10)) within group (order by a.item_id) CSI_ALT_DEFS
        from alt_def a , NCI_CSI_ALT_DEFNMS n, nci_admin_item_rel_alt_key x, admin_item ai , admin_item cs, de
       where n.nmdef_id = a.def_id and n.nci_pub_id = x.nci_pub_id and x.c_item_id = ai.item_id  and a.item_id = de.item_id and a.ver_nr = de.ver_nr
       and x.c_item_ver_nr = ai.ver_nr and x.cntxt_cs_item_id = cs.item_id and x.cntxt_cs_ver_nr = cs.ver_nr
       group by a.def_id) agg
 where DE_AI.ADMIN_ITEM_TYP_ID = 4 and
	ALT_DEF.ITEM_ID = DE_AI.ITEM_ID and
	ALT_DEF.VER_NR = DE_AI.VER_NR and
	ALT_DEF.DEF_ID = AGG.DEF_ID (+);



  CREATE OR REPLACE VIEW VW_CNCPT AS
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.NCI_ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.CREATION_DT, 
ADMIN_ITEM.EFF_DT, ADMIN_ITEM.ORIGIN,  ADMIN_ITEM.UNTL_DT,  ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, 
 ADMIN_ITEM.CREAT_DT, ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, ADMIN_ITEM.LST_UPD_DT, 
ADMIN_ITEM.DEF_SRC, OBJ_KEY.OBJ_KEY_DESC EVS_SRC
       FROM ADMIN_ITEM, CNCPT, OBJ_KEY
       WHERE ADMIN_ITEM_TYP_ID = 49 and ADMIN_ITEM.ITEM_ID = CNCPT.ITEM_ID and ADMIN_ITEM.VER_NR = CNCPT.VER_NR
	and cncpt.EVS_SRC_ID = OBJ_KEY.OBJ_KEY_ID (+);



  CREATE OR REPLACE  VIEW VW_VAL_MEAN As
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.NCI_ITEM_NM,  ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT, ext.cncpt_concat, ext.cncpt_concat_nm
FROM ADMIN_ITEM, NCI_ADMIN_ITEM_EXT ext
       WHERE ADMIN_ITEM_TYP_ID = 53 and admin_item.item_id = ext.item_id and admin_item.ver_nr = ext.ver_nr;



  CREATE OR REPLACE  VIEW VW_CONC_DOM As
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.NCI_ITEM_NM, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 1;


  CREATE OR REPLACE  VIEW VW_REP_CLS As
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.NCI_ITEM_NM, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 7;


  CREATE OR REPLACE  VIEW VW_OBJ_CLS As
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.NCI_ITEM_NM, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 5;


CREATE OR REPLACE VIEW VW_DE AS
       SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.NCI_ITEM_NM, 
ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.CNTXT_NM_DN, 
ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, 
 DE.DE_CONC_VER_NR, DE.DE_CONC_ITEM_ID, DE.VAL_DOM_VER_NR, DE.VAL_DOM_ITEM_ID, DE.REP_CLS_VER_NR, DE.REP_CLS_ITEM_ID, 
DE.CREAT_USR_ID, DE.LST_UPD_USR_ID, DE.FLD_DELETE, DE.LST_DEL_DT, DE.S2P_TRN_DT, DE.LST_UPD_DT, DE.CREAT_DT
   FROM ADMIN_ITEM, DE
       WHERE ADMIN_ITEM.ADMIN_ITEM_TYP_ID = 4
AND DE.ITEM_ID = ADMIN_ITEM.ITEM_ID
and DE.VER_NR = ADMIN_ITEM.VER_NR;

  CREATE OR REPLACE  VIEW VW_PROP As
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.NCI_ITEM_NM, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 6;

 


  CREATE OR REPLACE  VIEW VW_CNTXT As
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.NCI_ITEM_NM, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 8;

  CREATE OR REPLACE  VIEW VW_CLSFCTN_SCHM As
  SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.NCI_ITEM_NM, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 9;

CREATE OR REPLACE VIEW VW_VALUE_DOM AS
       SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.NCI_ITEM_NM, 
ADMIN_ITEM.CNTXT_NM_DN,  ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN,  VALUE_DOM.DTTYPE_ID, VALUE_DOM.VAL_DOM_MAX_CHAR, VALUE_DOM.CONC_DOM_VER_NR, VALUE_DOM.CONC_DOM_ITEM_ID, 
VALUE_DOM.NON_ENUM_VAL_DOM_DESC, VALUE_DOM.UOM_ID, VALUE_DOM.VAL_DOM_TYP_ID, VALUE_DOM.VAL_DOM_MIN_CHAR, VALUE_DOM.VAL_DOM_FMT_ID, 
VALUE_DOM.CHAR_SET_ID, VALUE_DOM.CREAT_DT, VALUE_DOM.CREAT_USR_ID, VALUE_DOM.LST_UPD_USR_ID, 
VALUE_DOM.FLD_DELETE, VALUE_DOM.LST_DEL_DT, VALUE_DOM.S2P_TRN_DT, VALUE_DOM.LST_UPD_DT 
FROM ADMIN_ITEM, VALUE_DOM
       WHERE ADMIN_ITEM.ADMIN_ITEM_TYP_ID = 3
AND ADMIN_ITEM.ITEM_ID = VALUE_DOM.ITEM_ID
AND ADMIN_ITEM.VER_NR=VALUE_DOM.VER_NR;


CREATE OR REPLACE VIEW VW_DE_CONC (LST_UPD_DT, S2P_TRN_DT, LST_DEL_DT, FLD_DELETE, LST_UPD_USR_ID, CREAT_USR_ID, CREAT_DT, 
OBJ_CLS_VER_NR, OBJ_CLS_ITEM_ID, PROP_ITEM_ID, PROP_VER_NR, CONC_DOM_ITEM_ID, CONC_DOM_VER_NR, ITEM_ID, VER_NR, ITEM_NM,
 ITEM_LONG_NM, NCI_ITEM_NM, ITEM_DESC, CNTXT_ITEM_ID, CNTXT_VER_NR, ADMIN_NOTES, CHNG_DESC_TXT, CREATION_DT, EFF_DT, DATA_ID_STR, ADMIN_ITEM_TYP_ID, CURRNT_VER_IND, REGSTR_STUS_ID, ADMIN_STUS_ID, STEWRD_CNTCT_ID, SUBMT_CNTCT_ID, REGISTRR_CNTCT_ID, STEWRD_ORG_ID, SUBMT_ORG_ID, DEC_CNTXT_NM, ALT_KEY, DE_CONC_CNTXT_STUS_VER_NM)  AS
       SELECT DE_CONC.LST_UPD_DT, DE_CONC.S2P_TRN_DT, DE_CONC.LST_DEL_DT, DE_CONC.FLD_DELETE, DE_CONC.LST_UPD_USR_ID, DE_CONC.CREAT_USR_ID, DE_CONC.CREAT_DT, 
DE_CONC.OBJ_CLS_VER_NR, DE_CONC.OBJ_CLS_ITEM_ID, DE_CONC.PROP_ITEM_ID, DE_CONC.PROP_VER_NR, DE_CONC.CONC_DOM_ITEM_ID, DE_CONC.CONC_DOM_VER_NR, ADMIN_ITEM.ITEM_ID, 
ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.NCI_ITEM_NM, ADMIN_ITEM.ITEM_DESC, ADMIN_ITEM.CNTXT_ITEM_ID, ADMIN_ITEM.CNTXT_VER_NR, ADMIN_ITEM.ADMIN_NOTES, ADMIN_ITEM.CHNG_DESC_TXT, ADMIN_ITEM.CREATION_DT, ADMIN_ITEM.EFF_DT, ADMIN_ITEM.DATA_ID_STR, ADMIN_ITEM.ADMIN_ITEM_TYP_ID, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_ID, ADMIN_ITEM.ADMIN_STUS_ID, ADMIN_ITEM.STEWRD_CNTCT_ID, ADMIN_ITEM.SUBMT_CNTCT_ID, ADMIN_ITEM.REGISTRR_CNTCT_ID, ADMIN_ITEM.STEWRD_ORG_ID, ADMIN_ITEM.SUBMT_ORG_ID, ADMIN_ITEM.ITEM_NM || ' ( ' || CNTXT_AI.ITEM_NM || ' )', ADMIN_ITEM.ALT_KEY,  '[' || nvl(STUS_MSTR.STUS_ACRO,STUS_MSTR.STUS_NM) || '] ' || CNTXT.CNTXT_ACRO || ' : ' ||
ADMIN_ITEM.ITEM_NM || ' - ' || ADMIN_ITEM.VER_NR
FROM ADMIN_ITEM, DE_CONC, ADMIN_ITEM CNTXT_AI, CNTXT, STUS_MSTR
       WHERE ADMIN_ITEM.ADMIN_ITEM_TYP_ID=2 
AND ADMIN_ITEM.ITEM_ID = DE_CONC.ITEM_ID
AND ADMIN_ITEM.VER_NR = DE_CONC.VER_NR
and ADMIN_ITEM.CNTXT_ITEM_ID = CNTXT_AI.ITEM_ID (+)
and ADMIN_ITEM.CNTXT_VER_NR = CNTXT_AI.VER_NR (+)
and ADMIN_ITEM.CNTXT_ITEM_ID = CNTXT.ITEM_ID(+)
and ADMIN_ITEM.CNTXT_VER_NR = CNTXT.VER_NR(+)
and ADMIN_ITEM.REGSTR_STUS_ID=STUS_MSTR.STUS_ID(+);


