CREATE OR REPLACE Procedure SAG_LOAD_CONCEPT_SYNONYMS 
(p_NM_DESC IN VARCHAR2,
V_ITEM_ID IN NUMBER,
V_VER_NR IN NUMBER,
V_CREAT_USR_ID IN VARCHAR2,
V_CREAT_DT IN DATE, 
V_LST_UPD_USR_ID IN VARCHAR2, 
V_LST_UPD_DT IN  DATE)
AS
--DECLARE
V_NM_DESC VARCHAR2 (8000);
TYPE T_syn_name IS TABLE OF VARCHAR2 (2000);--nested table type for synonyms names

arr_full    T_syn_name := T_syn_name (); -- table type for synonyms
arr_clean   T_syn_name := T_syn_name ();
BEGIN
     V_NM_DESC := p_NM_DESC;
     --DBMS_OUTPUT.PUT_LINE('p_NM_DESC ' || p_NM_DESC);
     --DBMS_OUTPUT.PUT_LINE('V_ITEM_ID ' || V_ITEM_ID);
     --DBMS_OUTPUT.PUT_LINE('V_VER_NR ' || V_VER_NR);
     --DBMS_OUTPUT.PUT_LINE('V_CREAT_USR_ID ' ||V_CREAT_USR_ID);
     --DBMS_OUTPUT.PUT_LINE('V_CREAT_DT ' ||V_CREAT_DT);    
     --DBMS_OUTPUT.PUT_LINE('V_LST_UPD_USR_ID ' ||V_LST_UPD_USR_ID);  
     --DBMS_OUTPUT.PUT_LINE('V_LST_UPD_DT ' ||V_LST_UPD_DT);
-- For performance triggers shall be disabled : TR_ALT_NMS_POST TR_NCI_ALT_NMS_DENORM_INS
-- This is done when called from SAG_LOAD_CONCEPT_ADMIN_ITEM_DESIG
--create an nested table of synonyms
FOR record IN (
select 
     regexp_substr (V_NM_DESC, '[^|]+', 1, rn) as splited
     from dual
     cross
     join (select rownum as rn
              from (select length (regexp_replace(V_NM_DESC, '[^|]+')) + 1 as mx from dual
          )
     connect by level <= mx)
)
LOOP
   arr_full.EXTEND;
   arr_full (arr_full.LAST) := substr(record.splited,1, 2000);
END LOOP; --table of synonyms created
-- create Alternate names from flat table concepts synonyms splitted by '|'
-- TODO check that the synonym does not exist before insert
IF arr_full IS NOT empty THEN
   -- same array into array 2
   arr_clean := arr_full;

   -- Identify distinct and return to main arr_full
   arr_full := arr_full MULTISET UNION DISTINCT arr_clean;

FOR idx_arr IN arr_full.FIRST .. arr_full.LAST
   LOOP
INSERT INTO /*+ APPEND */ ALT_NMS (NM_DESC,
     NM_TYP_ID,
     -- NCI_IDSEQ, --newly generated value
     -- LANG_ID,
    CNTXT_ITEM_ID, --trigger 20000000024 NCIP
    CNTXT_VER_NR,
    CNTXT_NM_DN,
     -- UNTL_DT,
     -- PREF_NM_IND
     ITEM_ID, --AI reference
     VER_NR, --AI reference
     CREAT_USR_ID,
     CREAT_DT,
     LST_UPD_USR_ID,
     LST_UPD_DT
     )
VALUES (arr_full(idx_arr),
     1064,--'Synonym',
     20000000024, 1, 'NCIP',
     V_ITEM_ID, V_VER_NR,
     V_CREAT_USR_ID,
     V_CREAT_DT,
     V_LST_UPD_USR_ID,
     V_LST_UPD_DT);
END LOOP; --INSERT
END IF; --arr_full
commit;
END;
/
CREATE OR REPLACE Procedure SAG_LOAD_CONCEPT_ADMIN_ITEM_DESIG AS
--DECLARE
v_eff_date DATE := sysdate;
BEGIN
	--disable compaund triggers
	EXECUTE IMMEDIATE 'ALTER TRIGGER TR_NCI_AI_DENORM_INS DISABLE';
	EXECUTE IMMEDIATE 'ALTER TRIGGER TR_NCI_ALT_NMS_DENORM_INS DISABLE';
	EXECUTE IMMEDIATE 'ALTER TRIGGER TR_ALT_NMS_POST DISABLE';
	
INSERT INTO /*+ APPEND */ admin_item (--NCI_IDSEQ,
     ADMIN_ITEM_TYP_ID,
     ADMIN_STUS_ID, --75 
     ADMIN_STUS_NM_DN, -- compound trigger RELEASED
     EFF_DT,
     -- CHNG_DESC_TXT, N/A
     CNTXT_ITEM_ID, -- trigger 20000000024 
     CNTXT_VER_NR, --1
     CNTXT_NM_DN, --NCIP
     -- UNTL_DT,
     -- CURRNT_VER_IND, default
     ITEM_LONG_NM,
     -- ORIGIN, default trigger
     ITEM_DESC, 
     --ITEM_ID,
     ITEM_NM,
     VER_NR,
     CREAT_USR_ID,
     CREAT_DT,
     LST_UPD_DT,
     LST_UPD_USR_ID,
     DEF_SRC)
select --'D12B8399-3EE0-0244-E053-5801D00A0E12', --for test
49, 75, 'RELEASED', v_eff_date, 
20000000024, 1, 'NCIP',
code, -- ITEM_LONG_NM
substr(NVL(definition, 'No value exists.'), 1, 4000), 
EVS_PREF_NAME, 1, 
'ONEDATA', v_eff_date, v_eff_date, 
'ONEDATA', 'NCI'
from SAG_LOAD_CONCEPTS_EVS where
 code not in (select item_long_nm from ADMIN_ITEM where admin_item_typ_id = 49 and cntxt_item_id = 20000000024)-- and context restriction NCIP
 and (CONCEPT_STATUS is NULL and CON_IDSEQ is null);-- use an empty status concepts
commit;
dbms_output.put_line('loaded concepts to admin_item !!!');

--Add concept table records based on AI table
insert into /*+ APPEND */ cncpt (item_id,
     ver_nr,
     evs_src_id,
     CREAT_USR_ID,
     CREAT_DT,
     LST_UPD_DT,
     LST_UPD_USR_ID)
SELECT item_id,
     ver_nr,
     218,-- NCI_CONCEPT_CODE
     CREAT_USR_ID,
     CREAT_DT,
     LST_UPD_DT,
     LST_UPD_USR_ID from admin_item where (item_id, ver_nr) in
(select item_id, ver_nr from admin_item where admin_item_typ_id = 49 minus select item_id, ver_nr from cncpt);
commit;
dbms_output.put_line('loaded concepts to cncpt !!!'); 
-- Add IDSEQ generated for concepts in AI to flat table
MERGE INTO SAG_LOAD_CONCEPTS_EVS t1
USING
(
SELECT * FROM ADMIN_ITEM where ADMIN_ITEM_TYP_ID = 49 and cntxt_item_id = 20000000024 -- and context restriction NCIP
--and CREAT_USR_ID = 'ONEDATA' 
)t2
ON(t1.code = t2.item_long_nm)
WHEN MATCHED THEN UPDATE SET
t1.con_idseq = t2.nci_idseq,
t1.item_id = t2.item_id,
t1.ver_nr = t2.ver_nr;
commit;
dbms_output.put_line('updated con_idseq SAG_LOAD_CONCEPTS_EVS !!!');
-- remove all concept alt names synonyms loaded by ONEDATA and which have a record in the EVS table
delete from alt_nms where creat_usr_id = 'ONEDATA' and lst_upd_usr_id = 'ONEDATA'
and NM_TYP_ID = 1064
and (item_id , ver_nr) in
(select item_id , ver_nr from CNCPT)
and (item_id , ver_nr) in
(select item_id , ver_nr from SAG_LOAD_CONCEPTS_EVS);
commit;
EXECUTE IMMEDIATE 'CREATE INDEX IDX_SAG_LOAD_CNCPT_ID_VER ON SAG_LOAD_CONCEPTS_EVS (ITEM_ID, VER_NR)';
-- create Alternate names from flat table concepts synonyms
for record in (select ld.synonyms synonyms,
     ai.ITEM_ID ITEM_ID, 
     ai.VER_NR VER_NR,
     ai.CREAT_USR_ID CREAT_USR_ID,
     ai.CREAT_DT CREAT_DT,
     ai.LST_UPD_USR_ID LST_UPD_USR_ID,
     ai.LST_UPD_DT LST_UPD_DT
from SAG_LOAD_CONCEPTS_EVS ld, admin_item ai 
     where ai.admin_item_typ_id = 49
     and ld.item_id = ai.item_id
     and ld.ver_nr = ai.ver_nr
     and CONCEPT_STATUS is NULL 
     --and CON_IDSEQ is not null --not needed since item ID is used
     and instr (SYNONYMS, '|') > 0) -- just one synonym is pref name
LOOP
     SAG_LOAD_CONCEPT_SYNONYMS(
     substr(record.synonyms, instr(record.synonyms, '|')+1),
     record.ITEM_ID, record.VER_NR, 
     'ONEDATA', v_eff_date, 
     'ONEDATA', v_eff_date);
END LOOP;
dbms_output.put_line('loaded concepts synonyms to ALT_NMS !!!');

	EXECUTE IMMEDIATE 'ALTER TRIGGER TR_NCI_AI_DENORM_INS ENABLE';
	EXECUTE IMMEDIATE 'ALTER TRIGGER TR_NCI_ALT_NMS_DENORM_INS ENABLE';
	EXECUTE IMMEDIATE 'ALTER TRIGGER TR_ALT_NMS_POST ENABLE';-- this trigger updates AI audit info on degignation updates
	EXECUTE IMMEDIATE 'DROP INDEX IDX_SAG_LOAD_CNCPT_ID_VER';
END;
/