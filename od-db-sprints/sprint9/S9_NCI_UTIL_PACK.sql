DROP PACKAGE ONEDATA_WA.NCI_UTIL;

CREATE OR REPLACE PACKAGE ONEDATA_WA.nci_util AS
procedure debugHook ( v_param_val in varchar2, v_data_out in clob);
END;
/

DROP PACKAGE BODY ONEDATA_WA.NCI_UTIL;

CREATE OR REPLACE PACKAGE BODY ONEDATA_WA.nci_util AS

procedure debugHook ( v_param_val in varchar2, v_data_out in clob)
as
v_cnt integer;
begin
for cur in (select * from nci_mdr_cntrl where upper(param_nm) = 'HOOK_DEBUG' and upper(param_val) = upper(v_param_val)) loop
insert into NCI_MDR_DEBUG (DATA_CLOB, PARAM_VAL) values (v_data_out, v_param_val);
commit;
end loop;
end;

end;
/
