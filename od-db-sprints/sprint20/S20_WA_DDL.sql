create or replace TRIGGER TR_NCI_ALT_NMS_DENORM_INS
  for  insert or update   on ALT_NMS
compound trigger
TYPE r_change_row is RECORD (
  NM_ID   number,
  CNTXT_ITEM_ID  ADMIN_ITEM.CNTXT_ITEM_ID%TYPE,
  OLD_CNTXT_ITEM_ID  ADMIN_ITEM.CNTXT_ITEM_ID%TYPE
);

TYPE t_change_row is TABLE of r_change_row
INDEX by PLS_INTEGER;

t_change t_change_row;

AFTER EACH ROW IS
BEGIN
  t_change(t_change.count+1).NM_ID := :new.NM_ID;
  --t_change(t_change.count).VER_NR := :new.VER_NR;
  t_change(t_change.count).CNTXT_ITEM_ID := nvl(:new.CNTXT_ITEM_ID,9999);
  t_change(t_change.count).OLD_CNTXT_ITEM_ID := nvl(:old.CNTXT_ITEM_ID,9999);

END AFTER EACH ROW;

AFTER STATEMENT IS
s_CNTXT_NM_DN   ADMIN_ITEM.CNTXT_NM_DN%TYPE;

BEGIN
for indx in 1..t_change.count
loop



if ( t_change(indx).CNTXT_ITEM_ID <> t_change(indx).OLD_CNTXT_ITEM_ID) then
select ITEM_NM into s_CNTXT_NM_DN from ADMIN_ITEM where ITEM_ID= t_change(indx).CNTXT_ITEM_ID;
update ALT_NMS set CNTXT_NM_DN = s_CNTXT_NM_DN where NM_ID = t_change(indx).nm_id;
--and ver_nr = t_change(indx).ver_nr;
end if;
end loop;
END AFTER STATEMENT;

END;

/

CREATE OR REPLACE TRIGGER TR_AI_EXT_TAB_INS
  AFTER INSERT
  on ADMIN_ITEM
  for each row
BEGIN

if (:new.admin_item_typ_id not in (5,6,7, 53)) then
insert into NCI_ADMIN_ITEM_EXT (ITEM_ID, VER_NR)
select :new.ITEM_ID, :new.VER_NR from dual;
end if;

if (:new.admin_item_typ_id =52) then
insert into NCI_MODULE (ITEM_ID, VER_NR)
select :new.ITEM_ID, :new.VER_NR from dual;
end if;

END;
/

/*
--MOD or PROTOCOL UPDATING from, MOD updates ADMIN_Item for MODE 
CREATE OR REPLACE TRIGGER TRG_NCI_MOD_PROT_POST
  AFTER INSERT OR UPDATE OR DELETE
  on NCI_ADMIN_ITEM_REL
  for each row
BEGIN

IF :new.REL_TYP_ID =60 then
    update ADMIN_ITEM set LST_UPD_DT = :new.LST_UPD_DT, LST_UPD_USR_ID = :new.LST_UPD_USR_ID 
    where ITEM_ID = :new.C_item_id and VER_NR = :new.C_ITEM_VER_NR ;   

end IF;
IF :new.REL_TYP_ID =61 then
    update ADMIN_ITEM set LST_UPD_DT = :new.LST_UPD_DT, LST_UPD_USR_ID = :new.LST_UPD_USR_ID where ITEM_ID = :new.P_item_id and VER_NR = :new.P_ITEM_VER_NR;
end IF;

END;
/
*/
