drop table nci_dload_hdr;

create table nci_dload_hdr
( hdr_id number,
dload_typ_id integer not null,
dload_fmt_id integer not null,
dload_hdr_nm varchar2(255),
dload_status varchar2(30) default 'CREATED',
 CREAT_DT             DATE DEFAULT sysdate NULL,
       CREAT_USR_ID         VARCHAR2(50) DEFAULT user NULL,
       LST_UPD_USR_ID       VARCHAR2(50) DEFAULT user NULL,
       FLD_DELETE           NUMBER(1) DEFAULT 0 NULL,
       LST_DEL_DT           DATE DEFAULT sysdate NULL,
       S2P_TRN_DT           DATE DEFAULT sysdate NULL,
       LST_UPD_DT           DATE DEFAULT sysdate NULL,
       CREATED_DT           DATE DEFAULT sysdate null,
       CREATED_BY           varchar2(50) null,
       LST_TRIGGER_DT       DATE DEFAULT sysdate null,
       FILE_NM VARCHAR2(350), 
       FILE_BLOB  BLOB,		
primary key (hdr_id));


create table nci_dload_als
( hdr_id number,
als_form_nm  varchar2(255),
als_prot_nm  varchar2(255),
PV_VM_IND  number,
 CREAT_DT             DATE DEFAULT sysdate NULL,
       CREAT_USR_ID         VARCHAR2(50) DEFAULT user NULL,
       LST_UPD_USR_ID       VARCHAR2(50) DEFAULT user NULL,
       FLD_DELETE           NUMBER(1) DEFAULT 0 NULL,
       LST_DEL_DT           DATE DEFAULT sysdate NULL,
       S2P_TRN_DT           DATE DEFAULT sysdate NULL,
       LST_UPD_DT           DATE DEFAULT sysdate NULL,
primary key (hdr_id));

create table nci_dload_dtl
(hdr_id number ,
item_id number,
ver_nr number(4,2),
 CREAT_DT             DATE DEFAULT sysdate NULL,
       CREAT_USR_ID         VARCHAR2(50) DEFAULT user NULL,
       LST_UPD_USR_ID       VARCHAR2(50) DEFAULT user NULL,
       FLD_DELETE           NUMBER(1) DEFAULT 0 NULL,
       LST_DEL_DT           DATE DEFAULT sysdate NULL,
       S2P_TRN_DT           DATE DEFAULT sysdate NULL,
       LST_UPD_DT           DATE DEFAULT sysdate NULL,
primary key (hdr_id, item_id,ver_nr));

alter table NCI_STG_AI_CNCPT_CREAT
add (DTTYPE_ID NUMBER, 
	VAL_DOM_MAX_CHAR number, 
	VAL_DOM_TYP_ID NUMBER, 
	UOM_ID NUMBER, 
	VD_CONC_DOM_VER_NR NUMBER(4,2)  , 
	VD_CONC_DOM_ITEM_ID NUMBER, 
	REP_CLS_VER_NR NUMBER(4,2), 
	REP_CLS_ITEM_ID NUMBER, 
	VAL_DOM_MIN_CHAR NUMBER, 
	VAL_DOM_FMT_ID NUMBER, 
	CHAR_SET_ID NUMBER, 
	VAL_DOM_HIGH_VAL_NUM VARCHAR2(50), 
	VAL_DOM_LOW_VAL_NUM VARCHAR2(50), 
	NCI_DEC_PREC NUMBER(2,0),
	PERM_VAL_NM  varchar2(255),
     NCI_STD_DTTYPE_ID  number,
	PV_1  varchar2(255),
	PV_2  varchar2(255),
	PV_3	varchar2(255),
	PV_4	varchar2(255),
	PV_5	varchar2(255),
	PV_6	varchar2(255),
	PV_7	varchar2(255),
	PV_8	varchar2(255),
	PV_9	varchar2(255),
	PV_10	varchar2(255));



--

--Inserts


insert into OBJ_TYP (OBJ_TYP_ID, OBJ_TYP_DESC) values (31, 'Download Format');
commit;

insert into OBJ_TYP (OBJ_TYP_ID, OBJ_TYP_DESC) values (32, 'Download Component Type');
commit;

			 
insert into OBJ_TYP (OBJ_TYP_ID, OBJ_TYP_DESC) values (33, 'ALS PV-VM type');
commit;
insert into OBJ_KEY (OBJ_KEY_ID, OBJ_TYP_ID, OBJ_KEY_DESC, OBJ_KEY_DEF, OBJ_KEY_CMNTS, NCI_CD) values (90,31,'ALS', 'ALS', '', 'ALS');
insert into OBJ_KEY (OBJ_KEY_ID, OBJ_TYP_ID, OBJ_KEY_DESC, OBJ_KEY_DEF, OBJ_KEY_CMNTS, NCI_CD) values (91,31,'Other', 'Other', '', 'Other');
insert into OBJ_KEY (OBJ_KEY_ID, OBJ_TYP_ID, OBJ_KEY_DESC, OBJ_KEY_DEF, OBJ_KEY_CMNTS, NCI_CD) values (92,32,'Form', 'Form', '', 'Form');
insert into OBJ_KEY (OBJ_KEY_ID, OBJ_TYP_ID, OBJ_KEY_DESC, OBJ_KEY_DEF, OBJ_KEY_CMNTS, NCI_CD) values (93,32,'CDE', 'CDE', '', 'CDE');
insert into OBJ_KEY (OBJ_KEY_ID, OBJ_TYP_ID, OBJ_KEY_DESC, OBJ_KEY_DEF, OBJ_KEY_CMNTS, NCI_CD) values (94,33,'PV', 'PV', '', 'PV');
insert into OBJ_KEY (OBJ_KEY_ID, OBJ_TYP_ID, OBJ_KEY_DESC, OBJ_KEY_DEF, OBJ_KEY_CMNTS, NCI_CD) values (95,33,'PVM', 'PVM', '', 'PVM');
			 
commit;

			 
-- Tracker 636
			 
			 
  CREATE OR REPLACE  VIEW VW_NCI_USED_BY AS
  select distinct ITEM_ID, VER_NR , CNTXT_ITEM_ID, CNTXT_VER_NR, sysdate CREAT_DT, 'ONEDATA' CREAT_USR_ID, 'ONEDATA' LST_UPD_USR_ID, 0 FLD_DELETE, sysdate LST_DEL_DE, sysdate S2P_TRN_DT, sysdate LST_UPD_DT
from (
  SELECT distinct DE.ITEM_ID, DE.VER_NR, a.CNTXT_ITEM_ID, a.CNTXT_VER_NR, sysdate CREAT_DT, 'ONEDATA' CREAT_USR_ID, 'ONEDATA' LST_UPD_USR_ID, a.FLD_DELETE, a.LST_DEL_DT, sysdate S2P_TRN_DT, sysdate LST_UPD_DT
       FROM DE, ALT_NMS a
       WHERE DE.ITEM_ID = a.ITEM_ID and DE.VER_NR = a.VER_NR
       and nvl(a.fld_delete,0) = 0
       and nvl(de.fld_delete,0) = 0
      and a.CNTXT_ITEM_ID is not null
union
  SELECT distinct DE.ITEM_ID, DE.VER_NR, a.NCI_CNTXT_ITEM_ID, a.NCI_CNTXT_VER_NR, sysdate CREAT_DT, 'ONEDATA' CREAT_USR_ID, 'ONEDATA' LST_UPD_USR_ID, a.FLD_DELETE, a.LST_DEL_DT, sysdate S2P_TRN_DT, sysdate LST_UPD_DT
       FROM DE, REF a
       WHERE DE.ITEM_ID = a.ITEM_ID and DE.VER_NR = a.VER_NR
       and nvl(a.fld_delete,0) = 0
       and nvl(de.fld_delete,0) = 0
      and a.NCI_CNTXT_ITEM_ID is not null
union
  SELECT distinct DE.C_ITEM_ID, DE.C_ITEM_VER_NR, cs.CNTXT_ITEM_ID, cs.CNTXT_VER_NR, sysdate CREAT_DT, 'ONEDATA' CREAT_USR_ID, 'ONEDATA' LST_UPD_USR_ID, cscsi.FLD_DELETE, cscsi.LST_DEL_DT, sysdate S2P_TRN_DT,
  sysdate LST_UPD_DT
       FROM NCI_ALT_KEY_ADMIN_ITEM_REL de, NCI_ADMIN_ITEM_REL_ALT_KEY cscsi, admin_item cs
       WHERE DE.NCI_PUB_ID = cscsi.NCI_PUB_ID and de.NCI_VER_NR = cscsi.NCI_VER_NR
       and nvl(cscsi.fld_delete,0) = 0
       and nvl(de.fld_delete,0) = 0
       and cscsi.CNTXT_CS_ITEM_ID = cs.item_id and
       cscsi.CNTXT_CS_VER_NR = cs.ver_nr and
       cs.admin_item_typ_id = 9       and cs.CNTXT_ITEM_ID is not null
union
  SELECT distinct quest.C_ITEM_ID, quest.C_ITEM_VER_NR, ai.CNTXT_ITEM_ID, ai.CNTXT_VER_NR, sysdate CREAT_DT, 'ONEDATA' CREAT_USR_ID, 'ONEDATA' LST_UPD_USR_ID, quest.FLD_DELETE, quest.LST_DEL_DT, sysdate S2P_TRN_DT, sysdate LST_UPD_DT
       FROM NCI_ADMIN_ITEM_REL_ALT_KEY quest, ADMIN_ITEM ai, NCI_ADMIN_ITEM_REL rel
       WHERE AI.ITEM_ID = rel.P_ITEM_ID and AI.VER_NR = rel.P_ITEM_VER_NR
       and nvl(ai.fld_delete,0) = 0
       and nvl(rel.fld_delete,0) = 0
       and rel.C_ITEM_ID = quest.P_ITEM_ID
       and rel.C_ITEM_VER_NR = quest.P_ITEM_VER_NR
       and ai.admin_stus_id = 75 -- only for released forms.
      );


drop view vw_rep_cls;


CREATE or REPLACE VIEW VW_REP_CLS AS
SELECT ADMIN_ITEM.ITEM_ID, ADMIN_ITEM.VER_NR, ADMIN_ITEM.ITEM_NM, ADMIN_ITEM.ITEM_LONG_NM, ADMIN_ITEM.ITEM_DESC, 
ADMIN_ITEM.CNTXT_NM_DN, ADMIN_ITEM.CURRNT_VER_IND, ADMIN_ITEM.REGSTR_STUS_NM_DN, ADMIN_ITEM.ADMIN_STUS_NM_DN, ADMIN_ITEM.CREAT_DT, 
ADMIN_ITEM.CREAT_USR_ID, ADMIN_ITEM.LST_UPD_USR_ID, ADMIN_ITEM.FLD_DELETE, ADMIN_ITEM.LST_DEL_DT, ADMIN_ITEM.S2P_TRN_DT, 
ADMIN_ITEM.LST_UPD_DT
FROM ADMIN_ITEM
       WHERE ADMIN_ITEM_TYP_ID = 7;
