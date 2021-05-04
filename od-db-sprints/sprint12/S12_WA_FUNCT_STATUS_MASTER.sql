create or replace function get_stus_mstr_id (STATUS_NAME VARCHAR2, STATUS_TYPE_ID number) return number is
v_status_id number;
v_status_name stus_mstr.STUS_NM%TYPE;
v_status_max_id number;
v_status_type_id number;
BEGIN
v_status_type_id := STATUS_TYPE_ID;
v_status_name := STATUS_NAME;

select max(STUS_ID) into v_status_max_id from stus_mstr;
BEGIN
select STUS_ID into v_status_id 
from stus_mstr where STUS_NM = v_status_name and STUS_TYP_ID = v_status_type_id;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
	v_status_id := v_status_max_id + 1;
END;

RETURN v_status_id;
END;
/

create or replace function is_stus_mstr_exist (STATUS_NAME VARCHAR2, STATUS_TYPE_ID number) return varchar2 is
v_status_id number;
v_status_name stus_mstr.STUS_NM%TYPE;
v_found varchar2(5);
v_status_type_id number;
--RETURN varchar2 'TRUE' if a status is found, and 'FALSE' if not
BEGIN
v_status_type_id := STATUS_TYPE_ID;
v_status_name := STATUS_NAME;
v_found := 'TRUE';

BEGIN
select STUS_ID into v_status_id 
from stus_mstr where STUS_NM = v_status_name and STUS_TYP_ID = v_status_type_id;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
	v_found := 'FALSE';
END;

RETURN v_found;
END;
/