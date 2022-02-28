create or replace PACKAGE            nci_PV_VM AS

PROCEDURE spPVVMCreateNew (v_data_in in clob, v_data_out out clob, v_usr_id  IN varchar2);
PROCEDURE spPVVMCreateNew2 (v_data_in in clob, v_data_out out clob, v_usr_id  IN varchar2);
PROCEDURE spPVVMCreateNewBulk (v_data_in in clob, v_data_out out clob, v_usr_id  IN varchar2);
PROCEDURE spVMEdit (v_data_in in clob, v_data_out out clob, v_usr_id  IN varchar2);
PROCEDURE spVMCreateEdit (v_data_in in clob, v_data_out out clob, v_usr_id  IN varchar2);

procedure spPVVMCommon ( v_init in t_rowset,  v_op  in varchar2, hookInput in t_hookInput, hookOutput in out t_hookOutput);
procedure spPVVMCommon2 ( v_init_rows in t_rows,  v_op  in varchar2, hookInput in t_hookInput, hookOutput in out t_hookOutput);
procedure spPVVMImport ( row_ori in out t_row,actions in out t_actions);
procedure createPVVMBulk ( rowform in t_row,  hookInput in t_hookInput, hookOutput in out t_hookOutput);

procedure setDefaultParamPVVM (row_ori in t_row, row in out t_row);
procedure setDefaultParamPVVM2 (row_ori in t_row, row in out t_row);
procedure chkPVVMActionValid ( row_ori in t_row, v_usr_id in varchar2);


function getPVVMQuestion return t_question;
function getVMEditQuestion (v_src_tbl_nm in varchar2, v_dup in boolean) return t_question;
function getVMCreateEditQuestion (v_src_tbl_nm in varchar2) return t_question;
function getPVVMQuestionBulk return t_question;
function getPVVMCreateFormBulk (v_rowset in t_rowset) return t_forms;
procedure createVMWithoutConcept(rowform in out t_row, v_typ in varchar2,  v_long_nm in varchar2, v_desc in varchar2, actions in out t_actions);

function getPVVMCreateForm (v_rowset in t_rowset) return t_forms;
function getPVVMCreateForm2 (v_init_rows in t_rows) return t_forms;
function getVMEditForm (v_rowset in t_rowset) return t_forms;
function getVMCreateEditForm (v_rowset in t_rowset) return t_forms;
procedure VMEditCore ( v_init in t_rowset,  hookInput in t_hookInput, hookOutput in out t_hookOutput);
procedure VMCreateEditCore ( v_init in t_rowset,  hookInput in t_hookInput, hookOutput in out t_hookOutput);

procedure createVMConcept (rowform in out t_row, v_cncpt_src in varchar2, v_mode in varchar2,  actions in out t_actions);

END;
/
create or replace PACKAGE BODY            nci_PV_VM AS

c_long_nm_len  integer := 30;
c_nm_len integer := 255;
c_ver_suffix varchar2(5) := 'v1.00';
v_dflt_txt    varchar2(100) := 'Enter text or auto-generated';

v_int_cncpt_id  number := 2433736;


--- Used to create VM with no concepts. Can be used for any Admin Item Type where there are no concepts but a string is to be used for comparison.
procedure createVMWithoutConcept(rowform in out t_row, v_typ in varchar2,  v_long_nm in varchar2, v_desc in varchar2, actions in out t_actions) as
v_def  varchar2(4000);
row t_row;
rows t_rows;
 action t_actionRowset;

 v_temp_id  number;
 v_temp_ver number(4,2);
 v_item_id  number;
 v_ver_nr number(4,2);
 v_id integer;
j integer;
v_obj_nm  varchar2(100);
v_temp varchar2(4000);
begin

if (v_typ = 'V') then
j := 1;
    for cur in (select ai.item_id, ai.ver_nr from nci_admin_item_ext e, admin_item ai where ai.item_id = e.item_id and ai.ver_nr = e.ver_nr
    and upper(cncpt_concat_nm) = upper(v_long_nm) and ai.admin_item_typ_id = 53) loop
        ihook.setColumnValue(rowform,'CNCPT_2_ITEM_ID_' || j,cur.item_id);
        ihook.setColumnValue(rowform,'CNCPT_2_VER_NR_'|| j,cur.ver_nr);
       j := j+ 1;
    end loop;
    return;
   end if;

    if (v_typ = 'C') then
        v_id := nci_11179.getItemId;
        rows := t_rows();
        row := t_row();

        ihook.setColumnValue(rowform,'CTL_VAL_MSG', 'VM Created: ' || v_id);

     -- to return values to calling program
--       ihook.setColumnValue(rowform,'ITEM_' || idx || '_ID', v_id);
 --      ihook.setColumnValue(rowform,'ITEM_' || idx || '_VER_NR', 1);

        ihook.setColumnValue(row,'ITEM_ID', v_id);
        ihook.setColumnValue(row,'ADMIN_ITEM_TYP_ID', 53);
        nci_11179_2.setStdAttr(row);
        nci_11179_2.setItemLongNm (row, v_id);
        ihook.setColumnValue(row,'ITEM_DESC',nvl(v_desc, v_long_nm));
        ihook.setColumnValue(row,'ITEM_NM', v_long_nm);
        ihook.setColumnValue(row,'CNTXT_ITEM_ID', nvl(ihook.getColumnValue(rowform,'CNTXT_ITEM_ID'),20000000024 ));  -- NCIP
        ihook.setColumnValue(row,'CNTXT_VER_NR', nvl(ihook.getColumnValue(rowform,'CNTXT_VER_NR'),1));
        ihook.setColumnValue(row,'CNCPT_CONCAT', v_long_nm);
        ihook.setColumnValue(row,'CNCPT_CONCAT_DEF',v_long_nm);
        ihook.setColumnValue(row,'CNCPT_CONCAT_NM', v_long_nm);
        ihook.setColumnValue(row,'CNCPT_CONCAT_NM_WITH_INT', v_long_nm);
          ihook.setColumnValue(row,'LST_UPD_DT',sysdate );

      ihook.setColumnValue(rowform,'ITEM_2_ID', v_id);
      ihook.setColumnValue(rowform,'ITEM_2_VER_NR', 1);
        ihook.setColumnValue(rowform,'ITEM_2_DEF', v_desc);


        rows.extend;
        rows(rows.last) := row;
    -- raise_application_error(-20000, 'HEre ' || v_nm || v_long_nm || v_def);


        action := t_actionrowset(rows, 'Administered Item (No Sequence)', 2,1,'insert');
        actions.extend;
        actions(actions.last) := action;


        action := t_actionrowset(rows, 'NCI AI Extension (Hook)', 2,3,'insert');
        actions.extend;
        actions(actions.last) := action;

       v_obj_nm := 'Value Meaning';
        action := t_actionrowset(rows, v_obj_nm, 2,2,'insert');
        actions.extend;
        actions(actions.last) := action;
end if;
end;



procedure setDefaultParamPVVM ( row_ori in t_row, row in out t_row)
as
begin
    ihook.setColumnValue(row, 'STG_AI_ID', 1);
    ihook.setColumnValue(row, 'VAL_DOM_ITEM_ID', ihook.getColumnValue(row_ori, 'ITEM_ID')); --Using not used attribute ITEM_2_NM to show selected VD.
   ihook.setColumnValue(row, 'VAL_DOM_VER_NR', ihook.getColumnValue(row_ori, 'VER_NR')); --Using not used attribute ITEM_2_NM to show selected VD.
     ihook.setColumnValue(row, 'ITEM_2_ID', ihook.getColumnValue(row_ori, 'ITEM_ID')); --Using not used attribute ITEM_2_NM to show selected VD.
   ihook.setColumnValue(row, 'ITEM_2_VER_NR', ihook.getColumnValue(row_ori, 'VER_NR')); --Using not used attribute ITEM_2_NM to show selected VD.
  --- Set default Conc Dom
    for cur in (select * from value_dom where item_id =ihook.getColumnValue(row_ori,'ITEM_ID') and ver_nr = ihook.getColumnValue(row_ori,'VER_NR') )loop
           ihook.setColumnValue(row, 'CONC_DOM_ITEM_ID', cur.CONC_DOM_ITEM_ID);
         ihook.setColumnValue(row, 'CONC_DOM_VER_NR', cur.CONC_DOM_VER_NR);
     end loop;

     -- Set default context to NCIP
    ihook.setColumnValue(row, 'CNTXT_ITEM_ID',20000000024 );
    ihook.setColumnValue(row, 'CNTXT_VER_NR', 1);

end;



procedure setDefaultParamPVVM2 ( row_ori in t_row, row in out t_row)
as
begin
    ihook.setColumnValue(row, 'STG_AI_ID', 1);
    ihook.setColumnValue(row, 'VAL_DOM_ITEM_ID', ihook.getColumnValue(row_ori, 'ITEM_ID')); --Using not used attribute ITEM_2_NM to show selected VD.
   ihook.setColumnValue(row, 'VAL_DOM_VER_NR', ihook.getColumnValue(row_ori, 'VER_NR')); --Using not used attribute ITEM_2_NM to show selected VD.
  --   ihook.setColumnValue(row, 'ITEM_2_ID', ihook.getColumnValue(row_ori, 'ITEM_ID')); --Using not used attribute ITEM_2_NM to show selected VD.
  -- ihook.setColumnValue(row, 'ITEM_2_VER_NR', ihook.getColumnValue(row_ori, 'VER_NR')); --Using not used attribute ITEM_2_NM to show selected VD.
  --- Set default Conc Dom
    for cur in (select * from value_dom where item_id =ihook.getColumnValue(row_ori,'ITEM_ID') and ver_nr = ihook.getColumnValue(row_ori,'VER_NR') )loop
           ihook.setColumnValue(row, 'CONC_DOM_ITEM_ID', cur.CONC_DOM_ITEM_ID);
         ihook.setColumnValue(row, 'CONC_DOM_VER_NR', cur.CONC_DOM_VER_NR);
     end loop;

     -- Set default context to NCIP
    ihook.setColumnValue(row, 'CNTXT_ITEM_ID',20000000024 );
    ihook.setColumnValue(row, 'CNTXT_VER_NR', 1);

end;


procedure chkPVVMActionValid ( row_ori in t_row, v_usr_id in varchar2)
as
begin

  -- Raise error if not authorized
     if (nci_11179_2.isUserAuth(ihook.getColumnValue(row_ori,'ITEM_ID'),ihook.getColumnValue(row_ori,'VER_NR') , v_usr_id) = false) then
        raise_application_error(-20000, 'You are not authorized to insert/update or delete in this context. ');
        return;
    end if;

    if (ihook.getColumnValue(row_ori, 'ADMIN_ITEM_TYP_ID') <> 3) then
        raise_application_error(-20000, 'This action is only applicable for Value Domains.');
        return;
    end if;

    for cur in (select * from value_dom where item_id = ihook.getColumnValue(row_ori,'ITEM_ID') and ver_nr = ihook.getColumnValue(row_ori,'VER_NR')
    and VAL_DOM_TYP_ID <> 17) loop
        raise_application_error(-20000, 'PV/VM cannot be added - Selected Value Domain is non-enumerated. ');
        return;
   end loop;

end;

-- Create new PV/VM with multiple concepts in VM
PROCEDURE spPVVMCreateNew ( v_data_in IN CLOB, v_data_out OUT CLOB, v_usr_id  IN varchar2)
as
  hookInput t_hookInput;
    hookOutput t_hookOutput := t_hookOutput();
    row_ori  t_row;
    row  t_row;
    rows t_rows;
    v_dflt_txt    varchar2(100) := 'Enter text or auto-generated.';
    rowsetai  t_rowset;
begin
    -- Standard header
    hookinput                    := Ihook.gethookinput (v_data_in);
    hookoutput.invocationnumber  := hookinput.invocationnumber;
    hookoutput.originalrowset    := hookinput.originalrowset;

    row_ori :=  hookInput.originalRowset.rowset(1);

    chkPVVMActionValid ( row_ori, v_usr_id );
    -- Default for new row. Dummy Identifier has to be set else error.
    row := t_row();
    setDefaultParamPVVM (row_ori, row);

    rows := t_rows();    rows.extend;    rows(rows.last) := row;
    rowsetai := t_rowset(rows, 'AI Creation With Concepts', 1, 'NCI_STG_AI_CNCPT_CREAT'); -- Default values for form

    spPVVMCommon(rowsetai, 'insert', hookinput, hookoutput);

    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);
     --nci_util.debugHook('GENERAL',v_data_out);
end;


-- Create new PV/VM with multiple concepts in VM
PROCEDURE spPVVMCreateNew2 ( v_data_in IN CLOB, v_data_out OUT CLOB, v_usr_id  IN varchar2)
as
  hookInput t_hookInput;
    hookOutput t_hookOutput := t_hookOutput();
    row_ori  t_row;
    row  t_row;
    rows t_rows;
    v_dflt_txt    varchar2(100) := 'Enter text or auto-generated.';
    rowsetai  t_rowset;
    i integer;
begin
    -- Standard header
    hookinput                    := Ihook.gethookinput (v_data_in);
    hookoutput.invocationnumber  := hookinput.invocationnumber;
    hookoutput.originalrowset    := hookinput.originalrowset;

    row_ori :=  hookInput.originalRowset.rowset(1);

    chkPVVMActionValid ( row_ori, v_usr_id );
    -- Default for new row. Dummy Identifier has to be set else error.
   -- row := t_row();
    --setDefaultParamPVVM (row_ori, row);
rows := t_rows();
 for i in 1..10 loop
   row := t_row();
   ihook.setColumnValue(row, 'STG_AI_ID', i);
        rows.extend;    rows(rows.last) := row;
    end loop;

  --  rowset := t_rowset(rows, 'AI Creation With Concepts', 1, 'NCI_STG_AI_CNCPT_CREAT'); -- Default values for form
   -- rows := t_rows();    rows.extend;    rows(rows.last) := row;
   -- rowsetai := t_rowset(rows, 'AI Creation With Concepts', 1, 'NCI_STG_AI_CNCPT_CREAT'); -- Default values for form

    spPVVMCommon2(rows, 'insert', hookinput, hookoutput);

    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);
 --nci_util.debugHook('GENERAL',v_data_out);
end;


-- Create new PV/VM with  concepts in VM
PROCEDURE spPVVMCreateNewBulk ( v_data_in IN CLOB, v_data_out OUT CLOB, v_usr_id  IN varchar2)
as
  hookInput t_hookInput;
    hookOutput t_hookOutput := t_hookOutput();
    row_ori  t_row;
    row  t_row;
    rows t_rows;
    v_dflt_txt    varchar2(100) := 'Enter text or auto-generated.';
    rowsetai  t_rowset;
    forms t_forms;
  form1 t_form;
 rowform  t_row;
begin
    -- Standard header
    hookinput                    := Ihook.gethookinput (v_data_in);
    hookoutput.invocationnumber  := hookinput.invocationnumber;
    hookoutput.originalrowset    := hookinput.originalrowset;

    row_ori :=  hookInput.originalRowset.rowset(1);
    chkPVVMActionValid ( row_ori, v_usr_id );

    if (hookinput.invocationnumber = 0) then
    -- Default for new row. Dummy Identifier has to be set else error.
    row := t_row();
    setDefaultParamPVVM (row_ori, row);
    rows := t_rows();    rows.extend;    rows(rows.last) := row;
    rowsetai := t_rowset(rows, 'AI Creation With Concepts', 1, 'NCI_STG_AI_CNCPT_CREAT'); -- Default values for form
    hookoutput.question := getPVVMQuestionBulk;
        -- Send initial rowset to create the form.
    hookOutput.forms :=getPVVMCreateFormBulk(rowsetai);

    else -- second invocation
        forms              := hookInput.forms;
        form1              := forms(1);
        rowform := form1.rowset.rowset(1);
        createPVVMBulk(rowform,hookInput,hookOutput);

    end if;
    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);
   --  nci_util.debugHook('GENERAL',v_data_out);
end;


--Inplace edit of VM

PROCEDURE spVMEdit ( v_data_in IN CLOB, v_data_out OUT CLOB, v_usr_id  IN varchar2)
as
    hookInput t_hookInput;
    hookOutput t_hookOutput := t_hookOutput();
    row_ori  t_row;
    row  t_row;
    rows t_rows;
    v_item_nm varchar2(255);
    v_item_def varchar2(4000);
    v_item_long_nm varchar2(255);
    v_item_id  number;
    v_ver_nr  number(4,2);
    v_item_type_id number;
   rowset  t_rowset;
    v_tbl_nm varchar2(100);
    v_nm_typ_nm varchar2(100) := 'Biomarker Synonym';
begin
    -- Standard header
    hookInput                    := Ihook.gethookinput (v_data_in);
    hookOutput.invocationnumber  := hookInput.invocationnumber;
    hookOutput.originalrowset    := hookInput.originalrowset;

    -- Get the selected row
    row_ori :=  hookInput.originalRowset.rowset(1);
    v_item_id := ihook.getColumnValue(row_ori, 'ITEM_ID');
    v_ver_nr := ihook.getColumnValue(row_ori, 'VER_NR');
    v_item_type_id := ihook.getColumnValue(row_ori, 'ADMIN_ITEM_TYP_ID');
    v_tbl_nm := hookinput.originalRowset.tablename;

  --  raise_application_error(-20000, v_tbl_nm);

    if (v_tbl_nm <> 'Administered Item') then  -- being called from PV
       v_item_id := ihook.getColumnValue(row_ori, 'NCI_VAL_MEAN_ITEM_ID');
        v_ver_nr := ihook.getColumnValue(row_ori, 'NCI_VAL_MEAN_VER_NR');
        nci_11179.spReturnAIRow(v_item_id, v_ver_nr, row_ori);

    end if;
        v_item_id := ihook.getColumnValue(row_ori, 'ITEM_ID');
        v_ver_nr := ihook.getColumnValue(row_ori, 'VER_NR');
        v_item_nm := ihook.getColumnValue(row_ori, 'ITEM_NM');
        v_item_def := ihook.getColumnValue(row_ori, 'ITEM_DESC');
        v_item_long_nm := ihook.getColumnValue(row_ori, 'ITEM_LONG_NM');

    -- Check if user is authorized to edit
    if (nci_11179_2.isUserAuth(v_item_id, v_ver_nr, v_usr_id) = false) then
        raise_application_error(-20000, 'You are not authorized to insert/update or delete in this context. ');
        return;
    end if;

    -- If called from Admin Item
    if (v_item_type_id <> 53 and upper(hookinput.originalRowset.tablename) like 'ADMIN%') then
        raise_application_error(-20000,'!!! This functionality is only applicable for VM !!!');
    end if;

    row := row_ori;


     -- Copy VM concepts
    nci_11179.spReturnConceptRow (v_item_id, v_ver_nr, 53, 1, row );

    -- Internal dummy is is set to 1.
    ihook.setColumnValue(row, 'STG_AI_ID', 1);
    ihook.setColumnValue(row, 'ITEM_1_ID', v_item_id);  --- Used in update later
    ihook.setColumnValue(row, 'ITEM_1_VER_NR', v_ver_nr);   --- Used in update later

  --  raise_application_error(-20000, ihook.getColumnValue(row, 'CNCPT_1_ITEM_ID_1'));
        ihook.setColumnValue(row, 'ITEM_1_NM',  v_item_nm);
        ihook.setColumnValue(row, 'ITEM_1_DEF',  v_item_def);
        ihook.setColumnValue(row, 'ITEM_1_LONG_NM',  v_item_long_nm);

-- Manually Curated Alternate name
    for cur in (select nm_desc from alt_nms  a where a.nm_typ_id = 83
    and a.item_Id = v_item_id and a.ver_nr = v_ver_nr) loop
        ihook.setColumnValue(row, 'CNCPT_CONCAT_STR_2', cur.nm_desc);
    end loop;
-- Manually curated alternate defintiion
    for cur in (select def_desc from alt_def a where nci_def_typ_id = 82
    and a.item_Id = v_item_id and a.ver_nr = v_ver_nr) loop
        ihook.setColumnValue(row, 'CNCPT_CONCAT_STR_1', cur.def_desc);
    end loop;

    rows := t_rows();    rows.extend;    rows(rows.last) := row;
    rowset := t_rowset(rows, 'VM Edit (Hook)', 1, 'NCI_STG_AI_CNCPT_CREAT');

    nci_pv_vm.VMEditCore(rowset, hookinput, hookoutput);

    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);

--nci_util.debugHook('GENERAL', v_data_out);

end;



-- Change PV Association May result in creation of new VM

PROCEDURE spVMCreateEdit ( v_data_in IN CLOB, v_data_out OUT CLOB, v_usr_id  IN varchar2)
as
    hookInput t_hookInput;
    hookOutput t_hookOutput := t_hookOutput();
    row_ori  t_row;
    row  t_row;
    rows t_rows;
    v_item_nm varchar2(255);
    v_item_def varchar2(4000);
    v_item_long_nm varchar2(255);
    v_item_id  number;
    v_ver_nr  number(4,2);
    v_item_type_id number;
    v_cd_item_id number;
    v_cd_ver_nr number(4,2);
   rowset  t_rowset;
    v_tbl_nm varchar2(100);
begin
    -- Standard header
    hookInput                    := Ihook.gethookinput (v_data_in);
    hookOutput.invocationnumber  := hookInput.invocationnumber;
    hookOutput.originalrowset    := hookInput.originalrowset;

    -- Get the selected row
    row_ori :=  hookInput.originalRowset.rowset(1);
    v_item_id := ihook.getColumnValue(row_ori, 'ITEM_ID');
    v_ver_nr := ihook.getColumnValue(row_ori, 'VER_NR');
    v_item_type_id := ihook.getColumnValue(row_ori, 'ADMIN_ITEM_TYP_ID');
        v_item_id := ihook.getColumnValue(row_ori, 'NCI_VAL_MEAN_ITEM_ID');
        v_ver_nr := ihook.getColumnValue(row_ori, 'NCI_VAL_MEAN_VER_NR');
        select item_nm, item_desc, item_long_nm into v_item_nm, v_item_def, v_item_long_nm from admin_item where item_id = v_item_id and ver_nr = v_ver_nr;
    -- Check if user is authorized to edit
    if (nci_11179_2.isUserAuth(v_item_id, v_ver_nr, v_usr_id) = false) then
        raise_application_error(-20000, 'You are not authorized to insert/update or delete in this context. ');
        return;
    end if;


    row := row_ori;


     -- Copy VM concepts
    nci_11179.spReturnConceptRow (v_item_id, v_ver_nr, 53, 1, row );

    -- Internal dummy is is set to 1.
    ihook.setColumnValue(row, 'STG_AI_ID', 1);
  --  ihook.setColumnValue(row, 'ITEM_2_ID', v_item_id);  --- Used in update later
  --  ihook.setColumnValue(row, 'ITEM_2_VER_NR', v_ver_nr);   --- Used in update later
    ihook.setColumnValue(row, 'VAL_DOM_ITEM_ID', ihook.getColumnValue(row_ori, 'VAL_DOM_ITEM_ID'));
    ihook.setColumnValue(row, 'VAL_DOM_VER_NR', ihook.getColumnValue(row_ori, 'VAL_DOM_VER_NR'));
    ihook.setColumnValue(row, 'PERM_VAL_NM', ihook.getColumnValue(row_ori, 'PERM_VAL_NM'));

    select conc_dom_item_id, conc_dom_Ver_nr into v_cd_item_id, v_cd_ver_nr from value_dom where item_id = ihook.getColumnValue(row_ori, 'VAL_DOM_ITEM_ID')
    and ver_nr = ihook.getColumnValue(row_ori, 'VAL_DOM_VER_NR');

    ihook.setColumnValue(row, 'CONC_DOM_ITEM_ID', v_cd_item_id);
    ihook.setColumnValue(row, 'CONC_DOM_VER_NR', v_cd_ver_nr);

        ihook.setColumnValue(row, 'ITEM_1_NM',  v_item_nm);
        ihook.setColumnValue(row, 'ITEM_1_DEF',  v_item_def);
        ihook.setColumnValue(row, 'ITEM_1_LONG_NM',  v_item_long_nm);
        ihook.setColumnValue(row, 'ITEM_1_ID',  v_item_id);
        ihook.setColumnValue(row, 'ITEM_1_VER_NR',  v_ver_nr);


    rows := t_rows();    rows.extend;    rows(rows.last) := row;
    rowset := t_rowset(rows, 'VM Edit (Hook)', 1, 'NCI_STG_AI_CNCPT_CREAT');

    nci_pv_vm.VMCreateEditCore(rowset, hookinput, hookoutput);

    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);

--nci_util.debugHook('GENERAL', v_data_out);

end;


procedure createPVVMBulk ( rowform in t_row,  hookInput in t_hookInput, hookOutput in out t_hookOutput)
AS
  forms t_forms;
  form1 t_form;

  row t_row;
  row_ori t_row;
  rowset            t_rowset;
 v_cncpt_long_nm  varchar2(255);
 v_cncpt_long_nm_int  varchar2(255);
 v_cncpt_nm  varchar2(255);
 v_cncpt_def varchar2(4000);
 v_item_id number;
 v_ver_nr number(4,2);
  cnt integer;
    actions t_actions := t_actions();
  action t_actionRowset;
  i integer := 0;
  v_cncpt_id number;
  v_cncpt_ver_nr number(4,2);
 v_temp integer;
  v_item_typ_glb integer;
  v_cncpt_id_int integer;
  v_pv  varchar2(255);
  v_vd_item_id number;
  v_vd_ver_nr number(4,2);
  v_cncpt_str  varchar2(255);
  v_vm_rows t_rows;
  v_vm_cd_rows t_rows;
  v_pv_rows  t_rows;
  v_cncpt_assoc_rows t_rows;
begin
    v_item_typ_glb := 53;
    row_ori :=  hookInput.originalRowset.rowset(1);
    v_vm_rows := t_rows();
    v_vm_cd_rows := t_rows();
    v_pv_rows := t_rows();
    v_cncpt_assoc_rows := t_rows();

      v_vd_item_id := ihook.getColumnValue(row_ori,'ITEM_ID');
      v_vd_ver_nr := ihook.getColumnValue(row_ori,'VER_NR');

      for i in 1..10 loop  -- Max of 10 pairs
        v_cncpt_id := ihook.getColumnValue(rowform,'CNCPT_1_ITEM_ID_' || i );
        v_cncpt_ver_nr := ihook.getColumnValue(rowform,'CNCPT_1_VER_NR_' || i );
        v_cncpt_str := ihook.getColumnValue(rowform,'STR_' || i );
        v_cncpt_id_int :=ihook.getColumnValue(rowform,'CNCPT_INT_1_' || i );
        if (v_cncpt_id is not null or v_cncpt_str is not null) then
            -- check if VM already exists

            -- IF concept ID specified and not integer
            if (v_cncpt_id is not null and (v_cncpt_id <> v_int_cncpt_id or (v_cncpt_id = v_int_cncpt_id and v_cncpt_id_int is null))  ) then
                select item_nm, item_long_nm, item_long_nm, item_desc into v_cncpt_nm, v_cncpt_long_nm,v_cncpt_long_nm_int, v_cncpt_def
                from admin_item where item_id = v_cncpt_id and ver_nr = v_cncpt_ver_nr;
            end if;
            -- IF concept ID specified and integer. Default for int is going to be 1
            if (v_cncpt_id = v_int_cncpt_id and v_cncpt_id_int is not null) then
                select  v_cncpt_id_int , item_long_nm, item_long_nm || '::' || v_cncpt_id_int , item_desc || '::' || v_cncpt_id_int into v_cncpt_nm, v_cncpt_long_nm,v_cncpt_long_nm_int, v_cncpt_def
                from admin_item where item_id = v_cncpt_id and ver_nr = v_cncpt_ver_nr;
            end if;
            -- if concept string specified
            if (v_cncpt_str is not null) then
                 v_cncpt_long_nm := v_cncpt_str;
                 v_cncpt_long_nm_int := v_cncpt_str;
                 v_cncpt_nm := v_cncpt_str;
                 v_cncpt_def := nvl(ihook.getColumnValue( rowform, 'STR_DESC_' || i), v_cncpt_str);
            end if;
        -- if PV is null, use VM name.

            v_pv :=  trim(nvl(ihook.getColumnValue(rowform,'PV_' || i), v_cncpt_nm));

                v_item_id := null;
                v_ver_nr := 1;
                -- Check if VM exists
                for cur in (select ai.item_id , ai.ver_nr from admin_item ai, nci_admin_item_ext e where ai.admin_item_typ_id = 53 and
                ai.item_id = e.item_id and ai.ver_nr = e.ver_nr and e.cncpt_concat_with_int = v_cncpt_long_nm_int) loop
                  v_item_id := cur.item_id;
                  v_ver_nr :=cur.ver_nr;
                end loop;
   --  raise_application_error(-20000, v_cncpt_long_nm || ' ' || v_item_id);

                if (v_item_id is null) then -- create new VM
                    v_ver_nr := 1;

                        row := t_row();
                        v_item_id := nci_11179.getItemId;
                        ihook.setColumnValue(row,'ITEM_ID', v_item_id);
                        ihook.setColumnValue(row,'VER_NR', 1);
                        ihook.setColumnValue(row,'CNCPT_ITEM_ID',v_cncpt_id);
                        ihook.setColumnValue(row,'CNCPT_VER_NR', v_cncpt_ver_nr);
                        if (v_cncpt_id = v_int_cncpt_id and v_cncpt_id_int is not null) then
                            ihook.setColumnValue(row,'NCI_CNCPT_VAL', v_cncpt_id_int);
                        end if;
                        ihook.setColumnValue(row,'NCI_ORD', 1);
                        ihook.setColumnValue(row,'NCI_PRMRY_IND', 1);
                        ihook.setColumnValue(row,'CURRNT_VER_IND', 1);
                        ihook.setColumnValue(row,'ADMIN_ITEM_TYP_ID', 53);
                        ihook.setColumnValue(row,'ADMIN_STUS_ID',66 );
                        ihook.setColumnValue(row,'REGSTR_STUS_ID',9 );
                        ihook.setColumnValue(row,'ITEM_LONG_NM', nci_11179_2.getStdShortName(v_item_id, 1));
                        ihook.setColumnValue(row,'ITEM_DESC', v_cncpt_def);
                        ihook.setColumnValue(row,'ITEM_NM', v_cncpt_nm);
                        ihook.setColumnValue(row,'CNTXT_ITEM_ID',20000000024); -- NCIP
                        ihook.setColumnValue(row,'CNTXT_VER_NR', 1);
                        ihook.setColumnValue(row,'CNCPT_CONCAT', v_cncpt_long_nm);
                        ihook.setColumnValue(row,'CNCPT_CONCAT_DEF', v_cncpt_def);
                        ihook.setColumnValue(row,'CNCPT_CONCAT_NM', v_cncpt_nm);
                        ihook.setColumnValue(row,'CNCPT_CONCAT_WITH_INT', v_cncpt_long_nm_int);
                        ihook.setColumnValue(row,'LST_UPD_DT',sysdate );

                          v_vm_rows.extend;            v_vm_rows(v_vm_rows.last) := row;

                    if (v_cncpt_id is not null) then
                          v_cncpt_assoc_rows.extend;            v_cncpt_assoc_rows(v_cncpt_assoc_rows.last) := row;
                    end if;

                end if;

                -- Check if VM-CD exists
                select count(*) into v_temp from CONC_DOM_VAL_MEAN where CONC_DOM_ITEM_ID = ihook.getColumnValue(rowform, 'CONC_DOM_ITEM_ID') and
                CONC_DOM_VER_NR = ihook.getColumnValue(rowform, 'CONC_DOM_VER_NR') and NCI_VAL_MEAN_ITEM_ID = v_item_id and NCI_VAL_MEAN_VER_NR =v_ver_nr;

                if (v_temp = 0) then
                    row := t_row();
                    ihook.setColumnValue(row,'CONC_DOM_ITEM_ID', ihook.getColumnValue(rowform, 'CONC_DOM_ITEM_ID'));
                    ihook.setColumnValue(row,'CONC_DOM_VER_NR', ihook.getColumnValue(rowform, 'CONC_DOM_VER_NR'));
                    ihook.setColumnValue(row,'NCI_VAL_MEAN_ITEM_ID',  v_item_id);
                    ihook.setColumnValue(row,'NCI_VAL_MEAN_VER_NR', v_ver_nr);

                    v_vm_cd_rows.extend;            v_vm_cd_rows(v_vm_cd_rows.last) := row;
                end if;

                -- Check if PV exists
                select count(*) into v_temp from PERM_VAL where VAL_DOM_ITEM_ID = ihook.getColumnValue(row_ori, 'ITEM_ID') and
                VAL_DOM_VER_NR = ihook.getColumnValue(row_ori, 'VER_NR') and NCI_VAL_MEAN_ITEM_ID = v_item_id and NCI_VAL_MEAN_VER_NR = v_ver_nr
                and upper(PERM_VAL_NM) = upper(v_pv);

                if (v_temp = 0) then
                    row := t_row();
                    ihook.setColumnValue(row,'PERM_VAL_NM', v_pv);
                    ihook.setColumnValue(row,'VAL_DOM_ITEM_ID', ihook.getColumnValue(row_ori, 'ITEM_ID'));
                    ihook.setColumnValue(row,'VAL_DOM_VER_NR', ihook.getColumnValue(row_ori, 'VER_NR'));
                    ihook.setColumnValue(row,'NCI_VAL_MEAN_ITEM_ID',  v_item_id);
                    ihook.setColumnValue(row,'NCI_VAL_MEAN_VER_NR', v_ver_nr);
                    ihook.setColumnValue(row,'VAL_ID',-1);
                    v_pv_rows.extend;   v_pv_rows(v_pv_rows.last) := row;
            end if;
           end if;  -- all values needed are not null
          end loop; -- i 1 to 10


        if (v_vm_rows.count > 0) then
                action := t_actionrowset(v_vm_rows, 'Administered Item (No Sequence)', 2,1,'insert');
                actions.extend;
                actions(actions.last) := action;

                action := t_actionrowset(v_vm_rows, 'NCI AI Extension (Hook)', 2,3,'insert');
                actions.extend;
                actions(actions.last) := action;

                action := t_actionrowset(v_vm_rows, 'Value Meaning', 2,2,'insert');
                actions.extend;
                actions(actions.last) := action;

        if (v_cncpt_assoc_rows.count > 0) then
                action := t_actionrowset(v_cncpt_assoc_rows, 'Items under Concept (Hook)', 2,6,'insert');
                actions.extend;
                actions(actions.last) := action;
            end if;
         end if;

          if (v_vm_cd_rows.count > 0) then
            action := t_actionrowset(v_vm_cd_rows, 'Value Meanings', 2,10,'insert');
            actions.extend;
            actions(actions.last) := action;
         end if;

          if (v_pv_rows.count > 0) then
            action := t_actionrowset(v_pv_rows, 'Permissible Values (Edit AI)', 2,11,'insert');
            actions.extend;
            actions(actions.last) := action;
         end if;


    if (actions.count > 0) then
        hookoutput.actions := actions;
        hookoutput.message := v_pv_rows.count || ' PV/VM created. ';
    end if;

END;


-- Common routine for DEC - Create or Update
-- v_init is the initial rowset to populate.
-- v_op is insert or update
PROCEDURE       spPVVMCommon ( v_init in t_rowset,  v_op  in varchar2,  hookInput in t_hookInput, hookOutput in out t_hookOutput)
AS
  rowform t_row;
  forms t_forms;
  form1 t_form;

  row t_row;
  rows  t_rows;
  row_ori t_row;
  rowset            t_rowset;
 v_str  varchar2(255);
 v_nm  varchar2(255);
 v_item_id number;
 v_ver_nr number(4,2);
  cnt integer;
k integer;
    actions t_actions := t_actions();
  action t_actionRowset;
  v_msg varchar2(1000);
  i integer := 0;
  v_err  integer;
  column  t_column;
  v_dec_nm varchar2(255);
  v_cncpt_nm varchar2(255);
  v_long_nm varchar2(255);
  v_def varchar2(4000);
  v_temp integer;
  is_valid boolean;
  v_item_typ_glb integer;
  v_pv  varchar2(255);
begin
    v_item_typ_glb := 53;
    row_ori :=  hookInput.originalRowset.rowset(1);

   if hookInput.invocationNumber = 0 then
        --  Get question. Either create or edit
          HOOKOUTPUT.QUESTION    := getPVVMQuestion;

        -- Send initial rowset to create the form.
          hookOutput.forms :=getPVVMCreateForm(v_init);

    else
        forms              := hookInput.forms;
        form1              := forms(1);
        rowform := form1.rowset.rowset(1);
        row := t_row();        rows := t_rows();
        is_valid := true;
        k := 1;
      -- Context is always going to be NCIP
        ihook.setColumnValue(rowform,'CNTXT_ITEM_ID',20000000024); -- NCIP
        ihook.setColumnValue(rowform,'CNTXT_VER_NR', 1);

        if HOOKINPUT.ANSWERID = 1 or Hookinput.answerid = 3 then  -- Validate using string
                     for i in  1..10 loop
                            ihook.setColumnValue(rowform, 'CNCPT_' || k  ||'_ITEM_ID_' || i,'');
                            ihook.setColumnValue(rowform, 'CNCPT_' || k || '_VER_NR_' || i, '');
                    end loop;
                nci_dec_mgmt.createValAIWithConcept(rowform , k,v_item_typ_glb ,'V','STRING',actions);
            end if;

        if HOOKINPUT.ANSWERID = 2 or Hookinput.answerid = 4 then  -- Validate using drop-down
          --  for k in  1..2  loop
               nci_dec_mgmt.createValAIWithConcept(rowform , k,v_item_typ_glb ,'V','DROP-DOWN',actions);
         --   end loop;
        end if;

       ihook.setColumnValue(rowform, 'GEN_STR',ihook.getColumnValue(rowform,'ITEM_1_NM') ) ;
       ihook.setColumnValue(rowform, 'CTL_VAL_MSG', 'VALIDATED');

        if (   ihook.getColumnValue(rowform, 'CNCPT_1_ITEM_ID_1') is null and hookinput.answerId < 5) then
                  ihook.setColumnValue(rowform, 'CTL_VAL_MSG', 'Concept missing');
                  is_valid := false;
        end if;
        if (   ihook.getColumnValue(rowform, 'ITEM_2_LONG_NM') is null and hookinput.answerid = 5) then
                  ihook.setColumnValue(rowform, 'CTL_VAL_MSG', 'No specified VM name');
                  is_valid := false;
        end if;

        if (   ihook.getColumnValue(rowform, 'ITEM_1_ID') is null and hookinput.answerid = 6) then
                  ihook.setColumnValue(rowform, 'CTL_VAL_MSG', 'No VM Specified');
                  is_valid := false;
        end if;

         rows := t_rows();

         -- If any of the test fails or if the user has triggered validation, then go back to the screen.
        if (is_valid=false or hookinput.answerid = 1 or hookinput.answerid = 2) then

              -- Read-only drop-downs do not migrate
                ihook.setColumnValue(rowform, 'VAL_DOM_ITEM_ID', ihook.getColumnValue(row_ori, 'ITEM_ID')); --Using not used attribute ITEM_2_NM to show selected VD.
                ihook.setColumnValue(rowform, 'VAL_DOM_VER_NR', ihook.getColumnValue(row_ori, 'VER_NR')); --Using not used attribute ITEM_2_NM to show selected VD.
                ihook.setColumnValue(rowform, 'ITEM_2_ID', ihook.getColumnValue(row_ori, 'ITEM_ID')); --Using not used attribute ITEM_2_NM to show selected VD.
                ihook.setColumnValue(rowform, 'ITEM_2_VER_NR', ihook.getColumnValue(row_ori, 'VER_NR')); --Using not used attribute ITEM_2_NM to show selected VD.
                rows.extend;
                rows(rows.last) := rowform;
                rowset := t_rowset(rows, 'AI Creation With Concepts', 1, 'NCI_STG_AI_CNCPT_CREAT');
                hookOutput.forms := getPVVMCreateForm(rowset);
                HOOKOUTPUT.QUESTION    := getPVVMQuestion;
                return;
        end if;

    -- If all the tests have passed and the user has asked for create, then create DEC and optionally OC and Prop.

    IF HOOKINPUT.ANSWERID in ( 3,4)  and is_valid = true THEN  -- Create
        nci_dec_mgmt.createValAIWithConcept(rowform , 1,v_item_typ_glb ,'C','DROP-DOWN',actions); -- Vm
    elsif (hookinput.answerid = 5 and is_Valid = true) then
        nci_dec_mgmt.createAIWithoutConcept(rowform , 1, 53, ihook.getColumnValue(rowform, 'ITEM_2_LONG_NM'),nvl(ihook.getColumnValue(rowform, 'ITEM_2_DEF'), ihook.getColumnValue(rowform, 'ITEM_2_LONG_NM')),'C',
        actions);
    end if;
      -- Create PV

      v_item_id := ihook.getColumnValue(rowform,'ITEM_1_ID');
      v_ver_nr := ihook.getColumnValue(rowform,'ITEM_1_VER_NR');
      v_pv := ihook.getColumnValue(rowform,'PERM_VAL_NM');

      if (hookinput.answerid = 5) then -- use specified value
        v_pv :=  nvl(ihook.getColumnValue(rowform,'PERM_VAL_NM'),ihook.getColumnValue(rowform,'ITEM_2_LONG_NM') );
      end if;
      if (hookinput.answerid in (3,4)) then -- use specified value
        v_pv :=  nvl(ihook.getColumnValue(rowform,'PERM_VAL_NM'),ihook.getColumnValue(rowform,'ITEM_1_NM') );
      end if;

      if (hookinput.answerid =6 and v_pv is null) then -- use specified value
      select item_nm into v_pv from admin_item where item_id = v_item_id and ver_nr = v_ver_nr;
      end if;

      -- Show resue if string specified.
      if (hookinput.answerid = 5) then
        hookoutput.message := ihook.getColumnValue(rowform,'CTL_VAL_MSG');
    else
      hookoutput.message := 'PV/VM Created Successfully with VM ID: ' || v_item_id;
    end if;
        select count(*) into v_temp from CONC_DOM_VAL_MEAN where CONC_DOM_ITEM_ID = ihook.getColumnValue(rowform, 'CONC_DOM_ITEM_ID') and
        CONC_DOM_VER_NR = ihook.getColumnValue(rowform, 'CONC_DOM_VER_NR') and NCI_VAL_MEAN_ITEM_ID = v_item_id and NCI_VAL_MEAN_VER_NR = v_ver_nr;

        if (v_temp = 0) then
        rows := t_rows();
        row := t_row();
        ihook.setColumnValue(row,'CONC_DOM_ITEM_ID', ihook.getColumnValue(rowform, 'CONC_DOM_ITEM_ID'));
        ihook.setColumnValue(row,'CONC_DOM_VER_NR', ihook.getColumnValue(rowform, 'CONC_DOM_VER_NR'));
        ihook.setColumnValue(row,'NCI_VAL_MEAN_ITEM_ID',  v_item_id);
        ihook.setColumnValue(row,'NCI_VAL_MEAN_VER_NR', ihook.getColumnValue(rowform, 'ITEM_1_VER_NR'));

            rows.extend;
            rows(rows.last) := row;
          action := t_actionrowset(rows, 'Value Meanings', 2,10,'insert');
           actions.extend;
           actions(actions.last) := action;

      end if;
      if (v_pv is not null) then
        select count(*) into v_temp from PERM_VAL where VAL_DOM_ITEM_ID = ihook.getColumnValue(row_ori, 'ITEM_ID') and
        VAL_DOM_VER_NR = ihook.getColumnValue(row_ori, 'VER_NR') and NCI_VAL_MEAN_ITEM_ID = v_item_id and NCI_VAL_MEAN_VER_NR = v_ver_nr
        and upper(PERM_VAL_NM) = upper(v_pv);

        if (v_temp = 0) then
        rows := t_rows();
        row := t_row();
        ihook.setColumnValue(row,'PERM_VAL_NM', v_pv);
        ihook.setColumnValue(row,'VAL_DOM_ITEM_ID', ihook.getColumnValue(row_ori, 'ITEM_ID'));
        ihook.setColumnValue(row,'VAL_DOM_VER_NR', ihook.getColumnValue(row_ori, 'VER_NR'));
        ihook.setColumnValue(row,'NCI_VAL_MEAN_ITEM_ID',  v_item_id);
        ihook.setColumnValue(row,'NCI_VAL_MEAN_VER_NR', 1);

        ihook.setColumnValue(row,'VAL_ID',-1);
            rows.extend;
            rows(rows.last) := row;
          action := t_actionrowset(rows, 'Permissible Values (Edit AI)', 2,19,'insert');
           actions.extend;
           actions(actions.last) := action;

        end if;

      end if;
     end if;


    if (actions.count > 0) then
        hookoutput.actions := actions;
         --   raise_application_error(-20000,'Inside 1' || v_item_id);

    end if;

END;

PROCEDURE       spPVVMCommon2 ( v_init_rows in t_rows,  v_op  in varchar2,  hookInput in t_hookInput, hookOutput in out t_hookOutput)
AS
  rowform t_row;
  forms t_forms;
  form1 t_form;

  row t_row;
  rows  t_rows;
  rowforms t_rows;
  row_ori t_row;
  rowset            t_rowset;
 v_str  varchar2(255);
 v_nm  varchar2(255);
 v_item_id number;
 v_ver_nr number(4,2);
  v_cnt integer;
k integer;
    actions t_actions := t_actions();
  action t_actionRowset;
  v_msg varchar2(1000);
  i integer := 0;
  v_err  integer;
  column  t_column;
  v_dec_nm varchar2(255);
  v_cncpt_nm varchar2(255);
  v_long_nm varchar2(255);
  v_def varchar2(4000);
  v_temp integer;
  is_valid boolean;
  v_dup integer;
  v_item_typ_glb integer;
  v_pv  varchar2(255);
  rep_idx integer;
  v_opt  integer;
begin
    v_item_typ_glb := 53;
    row_ori :=  hookInput.originalRowset.rowset(1);

   if hookInput.invocationNumber = 0 then
        --  Get question. Either create or edit
          HOOKOUTPUT.QUESTION    := getPVVMQuestion;

        -- Send initial rowset to create the form.
          hookOutput.forms :=getPVVMCreateForm2(v_init_rows);

    else
        forms              := hookInput.forms;

        is_valid := true;
        k := 1;
        rowforms := t_rows();
        for rep_idx in 1..10 loop
            form1              := forms(rep_idx);
            rowform := form1.rowset.rowset(1);
           setDefaultParamPVVM2 (row_ori, rowform);
        -- Rowforms holds all the data

        -- Context is always going to be NCIP

            ihook.setColumnValue(rowform,'CNTXT_ITEM_ID',20000000024); -- NCIP
            ihook.setColumnValue(rowform,'CNTXT_VER_NR', 1);

        -- determine what logic to use
        -- 1 - Use Existing
        -- 2 - Use Specified
        -- 3 - Concept String
        -- 4 - Concept Drop-down
            v_opt := 0    ;
           if (  ihook.getColumnValue(rowform, 'ITEM_2_ID') is not null) then -- user selected Vm
                v_opt := 1;
                ihook.setColumnValue(rowform, 'CTL_VAL_MSG', 'VALIDATED: User Specified VM will be used.');
                ihook.setColumnValue(rowform, 'CTL_VAL_STUS', '1');

          elsif (ihook.getColumnValue(rowform, 'ITEM_2_LONG_NM') is not null) then -- String
                v_opt := 2;
                ihook.setColumnValue(rowform, 'CTL_VAL_MSG', 'VALIDATED: User specified VM String will be used.');
                ihook.setColumnValue(rowform, 'CTL_VAL_STUS', '2');
          elsif (ihook.getColumnValue(rowform, 'CNCPT_CONCAT_STR_1') is not null) then -- Concept String
                v_opt := 3;

         elsif (ihook.getColumnValue(rowform, 'CNCPT_1_ITEM_ID_1') is not null) then
                v_opt := 4;
         end if;

         if (v_opt > 0) then
            if v_opt = 3 then
                     for i in  1..10 loop
                            ihook.setColumnValue(rowform, 'CNCPT_' || k  ||'_ITEM_ID_' || i,'');
                            ihook.setColumnValue(rowform, 'CNCPT_' || k || '_VER_NR_' || i, '');
                    end loop;
                nci_dec_mgmt.createValAIWithConcept(rowform , k,v_item_typ_glb ,'V','STRING',actions);
                ihook.setColumnValue(rowform, 'CTL_VAL_MSG', 'VALIDATED: Concept String will be used.');
                ihook.setColumnValue(rowform, 'CTL_VAL_STUS', '3');
     end if;

        if v_opt = 4 then
          --  for k in  1..2  loop
               nci_dec_mgmt.createValAIWithConcept(rowform , k,v_item_typ_glb ,'V','DROP-DOWN',actions);
               ihook.setColumnValue(rowform, 'CTL_VAL_MSG', 'VALIDATED: Concept drop-down will be used.');
               ihook.setColumnValue(rowform, 'CTL_VAL_STUS', '4');
         --   end loop;
        end if;

       ihook.setColumnValue(rowform, 'GEN_STR',replace(ihook.getColumnValue(rowform,'ITEM_1_NM'),'Integer::','') ) ;

        if (   ihook.getColumnValue(rowform, 'CNCPT_1_ITEM_ID_1') is null and v_opt > 2) then
                  ihook.setColumnValue(rowform, 'CTL_VAL_MSG', 'Concept missing');
                  is_valid := false;
        end if;
      end if;
        ihook.setColumnValue(rowform, 'STG_AI_ID', rep_idx);

        rowforms.extend;
                rowforms(rowforms.last) := rowform;

   end loop;


         -- If any of the test fails or if the user has triggered validation, then go back to the screen.
        if ( hookinput.answerid = 1 or is_valid = false) then

                hookOutput.forms := getPVVMCreateForm2(rowforms);
                HOOKOUTPUT.QUESTION    := getPVVMQuestion;
                return;
        end if;

    -- If all the tests have passed and the user has asked for create, then create DEC and optionally OC and Prop.

    v_cnt := 0;
            for rep_idx in 1..10 loop

                rowform :=rowforms(rep_idx);
                v_opt := nvl(ihook.getColumnValue(rowform, 'CTL_VAL_STUS'),0);
                v_dup := nvl(ihook.getColumnValue(rowform, 'UOM_ID'),0);
                if (v_opt > 0) then
                    IF v_opt in ( 3,4) and v_dup =0  THEN  -- Create; no duplicate allowed
                        nci_dec_mgmt.createValAIWithConcept(rowform , 1,v_item_typ_glb ,'C','DROP-DOWN',actions); -- Vm
                    end if;
                     IF v_opt in ( 3,4) and v_dup = 1  THEN  -- Create; Duplicate
                        nci_dec_mgmt.createValAIWithConcept(rowform , 1,v_item_typ_glb ,'O','DROP-DOWN',actions); -- Vm
                    end if;
                    if (v_opt = 2 ) and v_dup = 0 then
                        nci_dec_mgmt.createAIWithoutConcept(rowform , 1, 53, ihook.getColumnValue(rowform, 'ITEM_2_LONG_NM'),nvl(ihook.getColumnValue(rowform, 'ITEM_2_DEF'), ihook.getColumnValue(rowform, 'ITEM_2_LONG_NM')),'C',
                        actions);
                    end if;
                          if (v_opt = 2 ) and v_dup = 1 then
                        nci_dec_mgmt.createAIWithoutConcept(rowform , 1, 53, ihook.getColumnValue(rowform, 'ITEM_2_LONG_NM'),nvl(ihook.getColumnValue(rowform, 'ITEM_2_DEF'), ihook.getColumnValue(rowform, 'ITEM_2_LONG_NM')),'O',
                        actions);
                    end if;

                      v_item_id := ihook.getColumnValue(rowform,'ITEM_1_ID');
                      v_ver_nr := ihook.getColumnValue(rowform,'ITEM_1_VER_NR');

                if (v_opt = 1 ) then
                      v_item_id := ihook.getColumnValue(rowform,'ITEM_2_ID');
                      v_ver_nr := ihook.getColumnValue(rowform,'ITEM_2_VER_NR');
                end if;

                    -- Create PV
      v_pv := ihook.getColumnValue(rowform,'PERM_VAL_NM');

                      if (v_opt = 2) then -- use specified value
                        v_pv :=  nvl(ihook.getColumnValue(rowform,'PERM_VAL_NM'),ihook.getColumnValue(rowform,'ITEM_2_LONG_NM') );
                      end if;
                      if (v_opt in (3,4)) then -- use specified value
                        v_pv :=  nvl(ihook.getColumnValue(rowform,'PERM_VAL_NM'),ihook.getColumnValue(rowform,'ITEM_1_NM') );
                      end if;

                        if (v_opt = 1 and v_pv is null) then -- use specified value
                            select item_nm into v_pv from admin_item where item_id = v_item_id and ver_nr = v_ver_nr;
                        end if;

                    select count(*) into v_temp from CONC_DOM_VAL_MEAN where CONC_DOM_ITEM_ID = ihook.getColumnValue(rowform, 'CONC_DOM_ITEM_ID') and
                    CONC_DOM_VER_NR = ihook.getColumnValue(rowform, 'CONC_DOM_VER_NR') and NCI_VAL_MEAN_ITEM_ID = v_item_id and NCI_VAL_MEAN_VER_NR = v_ver_nr;

                    if (v_temp = 0) then
                        rows := t_rows();
                        row := t_row();
                        ihook.setColumnValue(row,'CONC_DOM_ITEM_ID', ihook.getColumnValue(rowform, 'CONC_DOM_ITEM_ID'));
                        ihook.setColumnValue(row,'CONC_DOM_VER_NR', ihook.getColumnValue(rowform, 'CONC_DOM_VER_NR'));
                        ihook.setColumnValue(row,'NCI_VAL_MEAN_ITEM_ID',  v_item_id);
                        ihook.setColumnValue(row,'NCI_VAL_MEAN_VER_NR', nvl(ihook.getColumnValue(rowform, 'ITEM_1_VER_NR'),1));

                        rows.extend;
                        rows(rows.last) := row;
                        action := t_actionrowset(rows, 'Value Meanings', 2,10,'insert');
                        actions.extend;
                        actions(actions.last) := action;
                    end if;

                    if (v_pv is not null) then
                        select count(*) into v_temp from PERM_VAL where VAL_DOM_ITEM_ID = ihook.getColumnValue(row_ori, 'ITEM_ID') and
                        VAL_DOM_VER_NR = ihook.getColumnValue(row_ori, 'VER_NR') and NCI_VAL_MEAN_ITEM_ID = v_item_id and NCI_VAL_MEAN_VER_NR = v_ver_nr
                        and upper(PERM_VAL_NM) = upper(v_pv);

                        if (v_temp = 0) then
                            rows := t_rows();
                            row := t_row();
                            ihook.setColumnValue(row,'PERM_VAL_NM', v_pv);
                            ihook.setColumnValue(row,'VAL_DOM_ITEM_ID', ihook.getColumnValue(row_ori, 'ITEM_ID'));
                            ihook.setColumnValue(row,'VAL_DOM_VER_NR', ihook.getColumnValue(row_ori, 'VER_NR'));
                            ihook.setColumnValue(row,'NCI_VAL_MEAN_ITEM_ID',  v_item_id);
                            ihook.setColumnValue(row,'NCI_VAL_MEAN_VER_NR', 1);
                            v_cnt := v_cnt + 1;
                            ihook.setColumnValue(row,'VAL_ID',-1);
                            rows.extend;     rows(rows.last) := row;
                              action := t_actionrowset(rows, 'Permissible Values (Edit AI)', 2,19,'insert');
                               actions.extend;
                               actions(actions.last) := action;
                        end if;
                    end if;
        end if; -- v_opt > 0
        end loop;

        end if;

    if (actions.count > 0) then
        hookoutput.actions := actions;
        hookoutput.message := v_cnt || ' PV/VM created.';
         --   raise_application_error(-20000,'Inside 1' || v_item_id);

    end if;

END;

procedure spPVVMImport ( row_ori in out t_row, actions in out t_actions)
AS

  forms t_forms;
  form1 t_form;

  row t_row;
  rows  t_rows;
  rowset            t_rowset;
  v_str  varchar2(255);
 v_nm  varchar2(255);
 v_item_id number;
 v_ver_nr number(4,2);
  cnt integer;
k integer;
  action t_actionRowset;
  i integer := 0;
  v_typ  varchar2(50);
  v_temp integer;
  is_valid boolean;
  v_item_typ_glb integer;
  v_pv  varchar2(255);
  v_vm_nm varchar2(255);
begin
    v_item_typ_glb := 53;
        row := t_row();        rows := t_rows();
        k := 1;


    v_typ := upper(ihook.getColumnValue(row_ori, 'VM_STR_TYP'));

    case
    when v_typ = 'CONCEPTS' then
        nci_dec_mgmt.createValAIWithConcept(row_ori , 1,v_item_typ_glb ,'C','DROP-DOWN',actions); -- Vm
         v_item_id := ihook.getColumnValue(row_ori,'ITEM_1_ID');
        v_ver_nr :=  ihook.getColumnValue(row_ori, 'ITEM_1_VER_NR');
     when v_typ = 'TEXT' then
        nci_dec_mgmt.createAIWithoutConcept(row_ori , 1, 53, ihook.getColumnValue(row_ori, 'CNCPT_CONCAT_STR_1'),nvl(ihook.getColumnValue(row_ori, 'ITEM_1_DEF'), ihook.getColumnValue(row_ori, 'CNCPT_CONCAT_STR_1')),'C',
        actions);
         v_item_id := ihook.getColumnValue(row_ori,'ITEM_1_ID');
        v_ver_nr :=  ihook.getColumnValue(row_ori, 'ITEM_1_VER_NR');
        ihook.setColumnValue(row_ori, 'GEN_STR', ihook.getColumnValue(row_ori, 'CNCPT_CONCAT_STR_1'));
     when v_typ = 'ID' then
        for cur in (select * from admin_item where item_id = ihook.getColumnValue(row_ori, 'CNCPT_CONCAT_STR_1') and currnt_ver_ind = 1 and admin_item_typ_id = v_item_typ_glb) loop
               v_item_id := cur.item_id;
        v_ver_nr :=  cur.ver_nr;
        end loop;
    end case;
      -- Create PV
       

        select count(*) into v_temp from CONC_DOM_VAL_MEAN where CONC_DOM_ITEM_ID = ihook.getColumnValue(row_ori, 'CONC_DOM_ITEM_ID') and
        CONC_DOM_VER_NR = ihook.getColumnValue(row_ori, 'CONC_DOM_VER_NR') and NCI_VAL_MEAN_ITEM_ID = v_item_id and NCI_VAL_MEAN_VER_NR = v_ver_nr;

--  If VM/CONC_DOM new
        if (v_temp = 0) then
        rows := t_rows();
        row := t_row();
        ihook.setColumnValue(row,'CONC_DOM_ITEM_ID', ihook.getColumnValue(row_ori, 'CONC_DOM_ITEM_ID'));
        ihook.setColumnValue(row,'CONC_DOM_VER_NR', ihook.getColumnValue(row_ori, 'CONC_DOM_VER_NR'));
        ihook.setColumnValue(row,'NCI_VAL_MEAN_ITEM_ID',  v_item_id);
        ihook.setColumnValue(row,'NCI_VAL_MEAN_VER_NR', v_ver_nr);

            rows.extend;
            rows(rows.last) := row;
          action := t_actionrowset(rows, 'Value Meanings', 2,10,'insert');
           actions.extend;
           actions(actions.last) := action;

      end if;
        rows := t_rows();
        row := t_row();
        ihook.setColumnValue(row,'PERM_VAL_NM', nvl(ihook.getColumnValue(row_ori, 'PERM_VAL_NM'),ihook.getColumnValue(row_ori, 'ITEM_1_NM')) );
        ihook.setColumnValue(row,'VAL_DOM_ITEM_ID', ihook.getColumnValue(row_ori, 'VAL_DOM_ITEM_ID'));
        ihook.setColumnValue(row,'VAL_DOM_VER_NR', ihook.getColumnValue(row_ori, 'VAL_DOM_VER_NR'));
        ihook.setColumnValue(row,'NCI_VAL_MEAN_ITEM_ID',  v_item_id);
        ihook.setColumnValue(row,'NCI_VAL_MEAN_VER_NR', v_ver_nr);

        ihook.setColumnValue(row,'VAL_ID',-1);
            rows.extend;
            rows(rows.last) := row;

          action := t_actionrowset(rows, 'Permissible Values (Edit AI)', 2,19,'insert');
           actions.extend;
           actions(actions.last) := action;


    -- VM Alternate Name
        if (ihook.getColumnValue(row_ori, 'VM_ALT_NM') is not null and ihook.getColumnValue(row_ori, 'VM_ALT_NM_TYP_ID') is not null) then
        rows := t_rows();
        row := t_row();
        ihook.setColumnValue(row,'ITEM_ID', v_item_id );
        ihook.setColumnValue(row,'VER_NR', 1);
        ihook.setColumnValue(row,'NM_TYP_ID', ihook.getColumnValue(row_ori, 'VM_ALT_NM_TYP_ID'));
        ihook.setColumnValue(row,'NM_DESC', ihook.getColumnValue(row_ori, 'VM_ALT_NM'));
        ihook.setColumnValue(row,'CNTXT_ITEM_ID',ihook.getColumnValue(row_ori, 'CNTXT_ITEM_ID') );
        ihook.setColumnValue(row,'CNTXT_VER_NR',ihook.getColumnValue(row_ori, 'CNTXT_VER_NR') );
        
        ihook.setColumnValue(row,'NM_ID',-1);
            rows.extend;
            rows(rows.last) := row;
          action := t_actionrowset(rows, 'Alternate Names', 2,23,'insert');
           actions.extend;
           actions(actions.last) := action;

        end if;
        
        ihook.setColumnValue(row_ori,'CTL_VAL_STUS',  'PROCESSED');
        ihook.setColumnValue(row_ori,'CTL_VAL_MSG', 'Value Meaning ID: ' || v_item_id);




END;

-- Only called from VM Edit  Inplace Edit
PROCEDURE       VMEditCore ( v_init in t_rowset,  hookInput in t_hookInput, hookOutput in out t_hookOutput)
AS
  rowform t_row;
  forms t_forms;
  form1 t_form;
    v_temp_id number;
    v_temp_ver number(4,2);
    idx integer;
  row t_row;
  rows  t_rows;
  row_ori t_row;
  rowset            t_rowset;
 v_str  varchar2(255);
 v_nm  varchar2(255);
 v_item_id number;
 v_ver_nr number(4,2);
  cnt integer;
j integer;
k integer;
z integer;
    actions t_actions := t_actions();
  action t_actionRowset;
  v_msg varchar2(1000);
  v_def varchar2(4000);
  v_temp integer;
  is_valid boolean;
  v_item_typ_glb integer;
  v_pv  varchar2(255);
  v_dup_item_id number;
  v_dup_ver_nr number(4,2);
  v_long_nm_suf varchar2(255);
  v_long_nm_suf_int varchar2(255);
  v_long_nm  varchar2(255);
  v_id number;
  v_err_str varchar2(255);
  v_cncpt_id number;
  v_cncpt_ver_nr number(4,2);
  is_dup boolean;
  v_op varchar2(50);
  rownmdef t_row;
begin
    v_item_typ_glb := 53;
    row_ori :=  hookInput.originalRowset.rowset(1);
 is_dup := false;
   if hookInput.invocationNumber = 0 then
        --  Get question. Either create or edit
          HOOKOUTPUT.QUESTION    := getVMEditQuestion(hookinput.originalrowset.tablename, false);

          hookOutput.forms :=getVMEditForm(v_init);

    else
        forms              := hookInput.forms;
        form1              := forms(1);
        rowform := form1.rowset.rowset(1);
        row := t_row();        rows := t_rows();
        is_valid := true;
        k := 1;
        idx := 1;
        j :=0;
         v_item_id := ihook.getColumnValue(rowform, 'ITEM_1_ID');
          v_ver_nr :=ihook.getColumnValue(rowform, 'ITEM_1_VER_NR');

  --      if (HOOKINPUT.ANSWERID  in ( 1 ,3)) then  -- Validate using drop-down
             --- Only update definition and long name. No name change
                if  (ihook.getColumnValue(rowform, 'CNCPT_1_ITEM_ID_1') is not null) then
                idx := 1;
                   for i in 1..10 loop
                        v_temp_id := ihook.getColumnValue(rowform, 'CNCPT_' || idx  ||'_ITEM_ID_' || i);
                        v_temp_ver := ihook.getColumnValue(rowform, 'CNCPT_' || idx || '_VER_NR_' || i);
                        if (v_temp_id is not null) then
                        for cur in(select item_id, item_nm , item_long_nm , item_desc from admin_item where admin_item_typ_id = 49 and item_id = v_temp_id and ver_nr = v_temp_ver) loop
                                v_def := substr( v_def || '_' ||cur.item_desc  ,1,4000);
                                if (cur.item_id = v_int_cncpt_id and trim(ihook.getColumnValue(rowform,'CNCPT_INT_' || idx || '_' || i)) is not null ) then --- integer concept
                                            v_long_nm_suf_int := trim(v_long_nm_suf_int || ':' || cur.item_long_nm) || '::' || trim(ihook.getColumnValue(rowform,'CNCPT_INT_' || idx || '_' || i));
                                            v_def := v_def || '::' ||  trim(ihook.getColumnValue(rowform,'CNCPT_INT_' || idx || '_' || i));
                                else
                                            v_long_nm_suf_int := trim(v_long_nm_suf_int || ':' || cur.item_long_nm);
                                end if;
                            v_long_nm_suf := trim(v_long_nm_suf || ':' || cur.item_long_nm);
                        end loop;
                        end if;
                end loop;
                end if;
                if  (ihook.getColumnValue(rowform, 'CNCPT_1_ITEM_ID_1') is null) then
                    for cur in(select item_id, item_nm , item_desc from admin_item where  item_id = v_item_id and ver_nr = v_ver_nr) loop
                         v_def := ':' || cur.item_desc;
                         v_long_nm_suf_int := ':' || cur.item_nm;
                         v_long_nm_suf := ':' || cur.item_nm;
                    end loop;
                end if;
              --  raise_application_error(-20000, v_long_nm_suf_int);
                z := 1;
                 for cur in (select ext.* from nci_admin_item_ext ext,admin_item a
                where nvl(a.fld_delete,0) = 0 and a.item_id = ext.item_id and a.ver_nr = ext.ver_nr and cncpt_concat_with_int =substr(v_long_nm_suf_int,2) and a.admin_item_typ_id = v_item_typ_glb
                and ext.item_id <> v_item_id ) loop
                        hookoutput.message :=  'WARNING: Duplicate found based on concepts. See Duplicates Section. ' ;
                 ihook.setColumnValue(rowform, 'CNCPT_2_ITEM_ID_' || z,cur.item_id);
                 ihook.setColumnValue(rowform, 'CNCPT_2_VER_NR_' || z,cur.ver_nr);
                        z := z+ 1;
                        v_dup_item_id := cur.item_id;
                        v_dup_ver_nr :=cur.ver_nr;
                        is_dup := true;
                end loop;
                ihook.setColumnValue(rowform, 'ITEM_1_DEF', substr(v_def,2));
               ihook.setColumnValue(rowform, 'ITEM_1_LONG_NM', substr(v_long_nm_suf,2));
               ihook.setColumnValue(rowform, 'ITEM_1_LONG_NM_INT', substr(v_long_nm_suf_int,2));
               rows := t_rows();  rows.extend;  rows(rows.last) := rowform;
               rowset := t_rowset(rows, 'VM Edit (Hook)', 1, 'NCI_STG_AI_CNCPT_CREAT');
              
  --      end if;
        v_err_str := '';
     --    nci_11179_2.stdCncptRowValidation(rowform, 1,is_valid, v_err_str );
        hookoutput.message := hookoutput.message || ' ' || v_err_str;

        if (is_valid = false or HOOKINPUT.ANSWERID = 1) then
        if (is_valid = true and is_dup = false) then
                          hookoutput.message := 'VALIDATED';
        end if;
        if (is_dup = true and hookinput.originalRowset.tablename <> 'Administered Item') then
                HOOKOUTPUT.QUESTION    := getVMEditQuestion(hookinput.originalrowset.tablename, true);
        else
                HOOKOUTPUT.QUESTION    := getVMEditQuestion(hookinput.originalrowset.tablename, false);
        end if;
          hookOutput.forms :=getVMEditForm(rowset);
          return;
    end if;

        if (HOOKINPUT.ANSWERID = 2 and is_Valid = true) then
          v_item_id := ihook.getColumnValue(rowform, 'ITEM_1_ID');
          v_ver_nr :=ihook.getColumnValue(rowform, 'ITEM_1_VER_NR');

        -- Delete purge existing relationship
            rows := t_rows();
            for cur in (select * from cncpt_admin_item where item_id = v_item_id and ver_nr = v_ver_nr) loop
                row := t_row();
                ihook.setColumnValue(row,'CNCPT_AI_ID', cur.CNCPT_AI_ID);
                rows.extend; rows(rows.last) := row;

            end loop;
            if (rows.count > 0) then
            action := t_actionrowset(rows, 'Items under Concept (Hook)', 2,1,'delete');
            actions.extend;
            actions(actions.last) := action;
            action := t_actionrowset(rows, 'Items under Concept (Hook)', 2,2,'purge');
            actions.extend;
            actions(actions.last) := action;
            end if;

        if (ihook.getColumnValue(rowform, 'CNCPT_1_ITEM_ID_1') is not null) then  --- If drop-down specified, manually entered text is overwritten.
            rows := t_rows();

            for i in reverse 0..10 loop
                    v_cncpt_id := ihook.getColumnValue(rowform, 'CNCPT_' || idx  ||'_ITEM_ID_' || i);
                    v_cncpt_ver_nr :=  ihook.getColumnValue(rowform, 'CNCPT_' || idx || '_VER_NR_' || i);
                    if( v_cncpt_id is not null) then
                        for cur in (select item_nm, item_long_nm, item_desc from admin_item where item_id = v_cncpt_id and ver_nr = v_cncpt_ver_nr) loop
                                row := t_row();
                                ihook.setColumnValue(row,'ITEM_ID', v_item_id);
                                ihook.setColumnValue(row,'VER_NR', v_ver_nr);
                                ihook.setColumnValue(row,'CNCPT_ITEM_ID',v_cncpt_id);
                                ihook.setColumnValue(row,'CNCPT_VER_NR', v_cncpt_ver_nr);
                                ihook.setColumnValue(row,'NCI_ORD', j);
                                ihook.setColumnValue(row,'CNCPT_AI_ID', -1);
     if (v_cncpt_id = v_int_cncpt_id and trim(ihook.getColumnValue(rowform,'CNCPT_INT_' || idx || '_' || i)) is not null) then
                            ihook.setColumnValue(row,'NCI_CNCPT_VAL',ihook.getColumnValue(rowform,'CNCPT_INT_' || idx || '_' || i));

                        end if;

                         --       v_temp := v_temp || i || ':' ||  v_cncpt_id;
                                if j = 0 then
                                    ihook.setColumnValue(row,'NCI_PRMRY_IND', 1);
                                else ihook.setColumnValue(row,'NCI_PRMRY_IND', 0);
                                end if;

                                rows.extend;
                                rows(rows.last) := row;
                                j := j+ 1;
                        end loop;
                    end if;
            end loop;
            action := t_actionrowset(rows, 'Items under Concept (Hook)', 2,6,'insert');
            actions.extend;
            actions(actions.last) := action;
        end if;
        rows := t_rows();
        row := t_row();

       nci_11179.spReturnAIRow (v_item_id, v_ver_nr, row);
       nci_11179.spReturnAIExtRow (v_item_id, v_ver_nr,  row);

       ihook.setColumnValue(row,'ITEM_NM', ihook.getColumnValue(rowform, 'ITEM_1_NM'));
       -- Setting the Vm short name to id + version as per tracker 882
        ihook.setColumnValue(row,'ITEM_LONG_NM', v_item_id ||  'v' || trim(to_char(v_ver_nr, '9999.99')));

      ihook.setColumnValue(row,'ITEM_DESC', ihook.getColumnValue(rowform, 'ITEM_1_DEF'));
        ihook.setColumnValue(row,'ADMIN_STUS_ID', ihook.getColumnValue(rowform, 'ADMIN_STUS_ID'));
        ihook.setColumnValue(row,'REGSTR_STUS_ID', ihook.getColumnValue(rowform, 'REGSTR_STUS_ID'));

       ihook.setColumnValue(row,'CNCPT_CONCAT_DEF', ihook.getColumnValue(rowform, 'ITEM_1_DEF'));
       ihook.setColumnValue(row,'CNCPT_CONCAT', ihook.getColumnValue(rowform, 'ITEM_1_LONG_NM'));
       ihook.setColumnValue(row,'CNCPT_CONCAT_NM', ihook.getColumnValue(rowform, 'ITEM_1_NM'));
       ihook.setColumnValue(row,'CNCPT_CONCAT_WITH_INT', ihook.getColumnValue(rowform, 'ITEM_1_LONG_NM_INT'));
       rows.extend;
       rows(rows.last) := row;

        action := t_actionrowset(rows, 'Administered Item (No Sequence)', 2,7,'update');
        actions.extend;
        actions(actions.last) := action;


        action := t_actionrowset(rows, 'NCI AI Extension (Hook)', 2,8,'update');
        actions.extend;
        actions(actions.last) := action;


        -- Manually Curated Alternate definition
        if (ihook.getColumnValue(rowform, 'CNCPT_CONCAT_STR_1') is not null) then
        -- Manually curated definition type id : 82
            select count(*) into v_temp from alt_def where item_id = v_item_id and ver_nr = v_ver_nr and nci_def_typ_id = 82;
            rownmdef := t_row();
            ihook.setColumnValue(rownmdef, 'ITEM_ID', v_item_id);
            ihook.setColumnValue(rownmdef, 'VER_NR', v_ver_nr);
            ihook.setColumnValue(rownmdef, 'CNTXT_ITEM_ID', ihook.getcolumnValue(row, 'CNTXT_ITEM_ID'));
            ihook.setColumnValue(rownmdef, 'CNTXT_VER_NR', ihook.getcolumnValue(row, 'CNTXT_VER_NR'));
            ihook.setColumnValue(rownmdef, 'NCI_DEF_TYP_ID', 82);
            ihook.setColumnValue(rownmdef, 'DEF_DESC', ihook.getColumnValue(rowform, 'CNCPT_CONCAT_STR_1'));

            if (v_temp = 0) then
                ihook.setColumnValue(rownmdef, 'DEF_ID', -1);
                v_op := 'insert';
            else -- record already exists
                select min(DEF_id) into v_temp from alt_def where item_id = v_item_id and ver_nr = v_ver_nr and nci_def_typ_id = 82;
                ihook.setColumnValue(rownmdef, 'DEF_ID', v_temp);
                v_op := 'update';
            end if;
             rows := t_rows(); rows.extend;       rows(rows.last) := rownmdef;
            action := t_actionrowset(rows, 'Alternate Definitions (All Types for Hook)', 2,8,v_op);
            actions.extend;
            actions(actions.last) := action;

        end if;
        -- Manually Curated Alternate name
        if (ihook.getColumnValue(rowform, 'CNCPT_CONCAT_STR_2') is not null) then
        -- Manually curated name type id : 83
            select count(*) into v_temp from alt_nms where item_id = v_item_id and ver_nr = v_ver_nr and nm_typ_id = 83;
            rownmdef := t_row();
            ihook.setColumnValue(rownmdef, 'ITEM_ID', v_item_id);
            ihook.setColumnValue(rownmdef, 'VER_NR', v_ver_nr);
            ihook.setColumnValue(rownmdef, 'CNTXT_ITEM_ID', ihook.getcolumnValue(row, 'CNTXT_ITEM_ID'));
            ihook.setColumnValue(rownmdef, 'CNTXT_VER_NR', ihook.getcolumnValue(row, 'CNTXT_VER_NR'));
            ihook.setColumnValue(rownmdef, 'NM_TYP_ID', 83);
            ihook.setColumnValue(rownmdef, 'NM_DESC', ihook.getColumnValue(rowform, 'CNCPT_CONCAT_STR_2'));

            if (v_temp = 0) then
                ihook.setColumnValue(rownmdef, 'NM_ID', -1);
                v_op := 'insert';
            else -- record already exists
                select min(nm_id) into v_temp from alt_nms where item_id = v_item_id and ver_nr = v_ver_nr and nm_typ_id = 83;
                ihook.setColumnValue(rownmdef, 'NM_ID', v_temp);
                v_op := 'update';
            end if;
             rows := t_rows(); rows.extend;       rows(rows.last) := rownmdef;
            action := t_actionrowset(rows, 'Alternate Names (All Types for Hook)', 2,8,v_op);
            actions.extend;
            actions(actions.last) := action;

        end if;
   -- end loop;


        end if;

    if (hookinput.answerid = 3 and is_dup = true) then
        rows := t_rows();
        row := row_ori;
        z := nvl(ihook.getColumnValue(rowform, 'NCI_DEC_PREC'),1);
            v_dup_item_id := ihook.getColumnValue(rowform ,'CNCPT_2_ITEM_ID_' || z);
            v_dup_ver_nr := ihook.getColumnValue(rowform ,'CNCPT_2_VER_NR_' || z);
        ihook.setColumnValue(row, 'NCI_VAL_MEAN_ITEM_ID', v_dup_item_id);
        ihook.setColumnValue(row, 'NCI_VAL_MEAN_VER_NR', v_dup_ver_nr);
       rows.extend;
       rows(rows.last) := row;

        action := t_actionrowset(rows, 'Permissible Values (Edit AI)', 2,1,'update');
        actions.extend;
        actions(actions.last) := action;
        hookoutput.message := 'Value Meaning assigned.' || v_dup_item_id;

    end if;

    if (actions.count > 0) then
        hookoutput.actions := actions;
        hookoutput.message := 'VM Updated successfully';
    end if;


end if;

END;


-- Only called from Change PV/VM Association
PROCEDURE       VMCreateEditCore ( v_init in t_rowset,  hookInput in t_hookInput, hookOutput in out t_hookOutput)
AS
  rowform t_row;
  forms t_forms;
  form1 t_form;

  row t_row;
  rows  t_rows;
  row_ori t_row;
  row_vm_cd t_row;
  rowset            t_rowset;
 v_str  varchar2(255);
 v_nm  varchar2(255);
 v_item_id number;
 v_ver_nr number(4,2);
  cnt integer;
k integer;
    actions t_actions := t_actions();
  action t_actionRowset;
  v_msg varchar2(1000);
  v_opt integer;
  v_dec_nm varchar2(255);
  v_cncpt_nm varchar2(255);
  v_long_nm varchar2(255);
  v_def varchar2(4000);
  v_temp integer;
  is_valid boolean;
  v_item_typ_glb integer;
  v_dup_nbr integer;
  v_pv  varchar2(255);
begin
    v_item_typ_glb := 53;
    row_ori :=  hookInput.originalRowset.rowset(1);

   if hookInput.invocationNumber = 0 then
        --  Get question. Either create or edit
          HOOKOUTPUT.QUESTION    := getVMCreateEditQuestion(hookinput.originalrowset.tablename);

          hookOutput.forms :=getVMCreateEditForm(v_init);

    else
        forms              := hookInput.forms;
        form1              := forms(1);
        rowform := form1.rowset.rowset(1);
        row := t_row();        rows := t_rows();
        is_valid := true;
        k := 1;
        v_opt := 0;

       -- raise_application_error(-20000,'First' || v_opt);

            if ( ihook.getColumnValue(rowform, 'ITEM_2_ID') is not null) then  -- Associate using specified but no value specified
                v_opt := 1;
                hookoutput.message := 'Specified VM will be used.';
            elsif (ihook.getColumnValue(rowform, 'ITEM_2_NM') is not null) then -- String
            --    v_opt := 2;
                ihook.setColumnValue(rowform, 'CTL_VAL_MSG', 'User specified VM String will be used.');
                    createVMWithoutConcept(rowform , 'V' ,ihook.getColumnValue(rowform, 'ITEM_2_NM') ,ihook.getColumnValue(rowform, 'ITEM_2_DEF') ,actions);
                    if (ihook.getColumnValue(rowform,'CNCPT_2_ITEM_ID_1') is not null and nvl(ihook.getColumnValue(rowform,'UOM_ID'),0) = 0 ) then -- duplicates found
                        v_opt := 3;
                        hookoutput.message := 'Duplcate(s) found. Please specific duplicate number. First duplicate found will be used by default.';
                    else
                        v_opt := 4;
                        hookoutput.message := 'New VM will be created from specified string.';
                    end if;
            elsif (ihook.getColumnValue(rowform, 'CNCPT_1_ITEM_ID_1') is not null) then
                  nci_dec_mgmt.createValAIWithConcept(rowform , k,v_item_typ_glb ,'V','DROP-DOWN',actions);
                    if (ihook.getColumnValue(rowform,'CNCPT_2_ITEM_ID_1') is not null and nvl(ihook.getColumnValue(rowform,'UOM_ID'),0) = 0) then -- duplicates found
                        v_opt := 3;
                        hookoutput.message := 'Duplcate(s) found. Please specific duplicate number. First duplicate found will be used by default.';
                    else
                        v_opt := 5;
                        hookoutput.message := 'New VM will be created from concepts.';
                    end if;
            else
                    hookoutput.message := 'Please select VM to use or specify atleast one concept.';
            end if;
      --  raise_application_error(-20000,'herer' || v_opt);
        end if;
        if (HOOKINPUT.ANSWERID = 1 or v_opt = 0) then
                ihook.setColumnValue(rowform, 'VAL_DOM_ITEM_ID', ihook.getColumnValue(row_ori, 'VAL_DOM_ITEM_ID'));
                  ihook.setColumnValue(rowform, 'VAL_DOM_VER_NR', ihook.getColumnValue(row_ori, 'VAL_DOM_VER_NR'));

               rows := t_rows();  rows.extend;  rows(rows.last) := rowform;
            rowset := t_rowset(rows, 'VM Create Edit (Hook)', 1, 'NCI_STG_AI_CNCPT_CREAT');
                HOOKOUTPUT.QUESTION    := getVMCreateEditQuestion(hookinput.originalrowset.tablename);

          hookOutput.forms :=getVMCreateEditForm(rowset);
          return;
        end if;

        if (HOOKINPUT.ANSWERID = 2 and v_opt > 0) then

           row_vm_cd := t_row();
           ihook.setColumnValue(row_vm_cd, 'CONC_DOM_ITEM_ID', ihook.getColumnValue(rowform, 'CONC_DOM_ITEM_ID'));
            ihook.setColumnValue(row_vm_cd, 'CONC_DOM_VER_NR', ihook.getColumnValue(rowform, 'CONC_DOM_VER_NR'));

            if (v_opt = 1 ) then -- use specified
            ihook.setColumnValue(row_ori, 'NCI_VAL_MEAN_ITEM_ID', ihook.getColumnValue(rowform, 'ITEM_2_ID'));
              ihook.setColumnValue(row_ori, 'NCI_VAL_MEAN_VER_NR', ihook.getColumnValue(rowform, 'ITEM_2_VER_NR'));
                  ihook.setColumnValue(row_vm_cd, 'NCI_VAL_MEAN_ITEM_ID', ihook.getColumnValue(rowform, 'ITEM_2_ID'));
                      ihook.setColumnValue(row_vm_cd, 'NCI_VAL_MEAN_VER_NR', ihook.getColumnValue(rowform, 'ITEM_2_VER_NR'));
                   end if;


            if (v_opt = 3 ) then -- duplicate found

            v_dup_nbr := nvl(ihook.getColumnValue(rowform, 'NCI_DEC_PREC'),1);
            ihook.setColumnValue(row_ori, 'NCI_VAL_MEAN_ITEM_ID', ihook.getColumnValue(rowform, 'CNCPT_2_ITEM_ID_' || v_dup_nbr));
              ihook.setColumnValue(row_ori, 'NCI_VAL_MEAN_VER_NR', ihook.getColumnValue(rowform, 'CNCPT_2_VER_NR_' || v_dup_nbr));
             ihook.setColumnValue(row_vm_cd, 'NCI_VAL_MEAN_ITEM_ID', ihook.getColumnValue(rowform, 'CNCPT_2_ITEM_ID_' || v_dup_nbr));
              ihook.setColumnValue(row_vm_cd, 'NCI_VAL_MEAN_VER_NR', ihook.getColumnValue(rowform, 'CNCPT_2_VER_NR_' || v_dup_nbr));

            end if;

            if (v_opt = 4) then -- new vm creation using string
              createVMWithoutConcept(rowform , 'C' ,ihook.getColumnValue(rowform, 'ITEM_2_NM') ,ihook.getColumnValue(rowform, 'ITEM_2_DEF') ,actions);
                      ihook.setColumnValue(row_ori, 'NCI_VAL_MEAN_ITEM_ID', ihook.getColumnValue(rowform, 'ITEM_2_ID'));
                      ihook.setColumnValue(row_ori, 'NCI_VAL_MEAN_VER_NR', ihook.getColumnValue(rowform, 'ITEM_2_VER_NR'));
                      ihook.setColumnValue(row_vm_cd, 'NCI_VAL_MEAN_ITEM_ID', ihook.getColumnValue(rowform, 'ITEM_2_ID'));
                      ihook.setColumnValue(row_vm_cd, 'NCI_VAL_MEAN_VER_NR', ihook.getColumnValue(rowform, 'ITEM_2_VER_NR'));


          end if;

            if (v_opt = 5) then -- new vm creation using drop-down
                  nci_dec_mgmt.createValAIWithConcept(rowform , k,v_item_typ_glb ,'O','DROP-DOWN',actions);
               --   raise_application_error(-20000, ihook.getColumnValue(rowform, 'ITEM_1_ID'));
                ihook.setColumnValue(row_ori, 'NCI_VAL_MEAN_ITEM_ID', ihook.getColumnValue(rowform, 'ITEM_1_ID'));
              ihook.setColumnValue(row_ori, 'NCI_VAL_MEAN_VER_NR', ihook.getColumnValue(rowform, 'ITEM_1_VER_NR'));
                ihook.setColumnValue(row_vm_cd, 'NCI_VAL_MEAN_ITEM_ID', ihook.getColumnValue(rowform, 'ITEM_1_ID'));
              ihook.setColumnValue(row_vm_cd, 'NCI_VAL_MEAN_VER_NR', ihook.getColumnValue(rowform, 'ITEM_1_VER_NR'));

              end if;

              rows := t_rows();
                   rows.extend;
            rows(rows.last) := row_ori;
          action := t_actionrowset(rows, 'Permissible Values (Edit AI)', 2,19,'update');
           actions.extend;
           actions(actions.last) := action;

--  VM-CD
    select count(*) into v_temp from conc_dom_val_mean where conc_dom_item_id = ihook.getColumnValue(row_vm_cd, 'CONC_DOM_ITEM_ID')
        and conc_dom_ver_nr = ihook.getColumnValue(row_vm_cd, 'CONC_DOM_VER_NR')
        and NCI_VAL_MEAN_ITEM_ID = ihook.getColumnValue(row_vm_cd, 'NCI_VAL_MEAN_ITEM_ID')
        and NCI_VAL_MEAN_VER_NR = ihook.getColumnValue(row_vm_cd, 'NCI_VAL_MEAN_VER_NR');

        if (v_temp = 0) then
              rows := t_rows();
                   rows.extend;
            rows(rows.last) := row_vm_cd;
          action := t_actionrowset(rows, 'Value Meanings', 2,20,'insert');
           actions.extend;
           actions(actions.last) := action;
        end if;
         --   end loop;

        end if;

    if (actions.count > 0) then
        hookoutput.actions := actions;
        hookoutput.message := 'PV/VM Association Successful.';
    end if;



END;


function getPVVMQuestion return t_question
is
  question t_question;
  answer t_answer;
  answers t_answers;
begin

ANSWERS                    := T_ANSWERS();
    ANSWER                     := T_ANSWER(1, 1, 'Validate');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
      ANSWER                     := T_ANSWER(2, 2, 'Create');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
/*
 ANSWERS                    := T_ANSWERS();
    ANSWER                     := T_ANSWER(1, 1, 'Validate Using String');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
  --  ANSWERS                    := T_ANSWERS();
    ANSWER                     := T_ANSWER(2, 2, 'Validate Using Drop-Down');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
    ANSWER                     := T_ANSWER(3, 3, 'Create Using String');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
    ANSWER                     := T_ANSWER(4, 4, 'Create Using Drop-Down');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
      ANSWER                     := T_ANSWER(5, 5, 'Create Using Specified');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
          ANSWER                     := T_ANSWER(6, 6, 'Create Using Existing VM');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER; */
    QUESTION               := T_QUESTION('Create PV/VM', ANSWERS);

return question;
end;



function getPVVMQuestionBulk return t_question
is
  question t_question;
  answer t_answer;
  answers t_answers;
begin

 ANSWERS                    := T_ANSWERS();
    ANSWER                     := T_ANSWER(1, 1, 'Create');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
  QUESTION               := T_QUESTION('Create Multiple PV with/without VM Using Single Concept', ANSWERS);

return question;
end;

function getVMEditQuestion (v_src_tbl_nm in varchar2, v_dup in boolean) return t_question is
  question t_question;
  answer t_answer;
  answers t_answers;
begin
--- If Edit DEC
 ANSWERS                    := T_ANSWERS();
    ANSWER                     := T_ANSWER(1, 1, 'Validate Using Drop-Down');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
    ANSWER                     := T_ANSWER(2, 2, 'Update VM');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
  /*  if (v_dup = true) then
    ANSWER                     := T_ANSWER(3, 3, 'Replace VM in PV');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
    end if;
*/
    QUESTION               := T_QUESTION('Edit VM', ANSWERS);

return question;
end;


function getVMCreateEditQuestion (v_src_tbl_nm in varchar2) return t_question is
  question t_question;
  answer t_answer;
  answers t_answers;
begin
--- If Edit DEC
 ANSWERS                    := T_ANSWERS();
    ANSWER                     := T_ANSWER(1, 1, 'Validate');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
    ANSWER                     := T_ANSWER(2, 2, 'Associate');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
  /*  ANSWER                     := T_ANSWER(3, 3, 'Associate Using Specified');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;  */
    QUESTION               := T_QUESTION('Change PV/VM Association', ANSWERS);

return question;
end;

-- Create form for Multi-concept VM
function getPVVMCreateForm (v_rowset in t_rowset) return t_forms is
  forms t_forms;
  form1 t_form;
begin
    forms                  := t_forms();
    form1                  := t_form('PV VM Creation (Hook)', 2,1);
    form1.rowset :=v_rowset;
    forms.extend;    forms(forms.last) := form1;
  return forms;
end;


-- Create form for Multi-concept VM
function getPVVMCreateForm2 (v_init_rows in t_rows) return t_forms is
  forms t_forms;
  form1 t_form;
  i integer;
  row t_row;
  rows t_rows;
  rowset t_rowset;
begin
    forms                  := t_forms();
   -- raise_application_error(-20000, 'Error' || v_init_rows.count);
    for i in 1..10 loop
      row := v_init_rows(i);
    rows := t_rows();    rows.extend;    rows(rows.last) := row;
    rowset := t_rowset(rows, 'AI Creation With Concepts', 1, 'NCI_STG_AI_CNCPT_CREAT'); -- Default values for form

    form1                  := t_form('PV VM Creation 5 (Hook)', 2,1);
    form1.rowset :=rowset;
    forms.extend;  forms(forms.last) := form1;
    end loop;
  return forms;
end;
function getVMEditForm (v_rowset in t_rowset) return t_forms is
  forms t_forms;
  form1 t_form;
begin
    forms                  := t_forms();
    form1                  := t_form('VM Edit (Hook)', 2,1);
    form1.rowset :=v_rowset;
    forms.extend;    forms(forms.last) := form1;
  return forms;
end;

function getVMCreateEditForm (v_rowset in t_rowset) return t_forms is
  forms t_forms;
  form1 t_form;
begin
    forms                  := t_forms();
    form1                  := t_form('VM Create Edit (Hook)', 2,1);
    form1.rowset :=v_rowset;
    forms.extend;    forms(forms.last) := form1;
  return forms;
end;

-- Create form for single concept VM
function getPVVMCreateFormBulk (v_rowset in t_rowset) return t_forms is
  forms t_forms;
  form1 t_form;
begin
    forms                  := t_forms();
    form1                  := t_form('PV VM Creation Single (Hook)', 2,1);
    form1.rowset :=v_rowset;
    forms.extend;    forms(forms.last) := form1;
  return forms;
end;


-- v_mode : V - Validate, C - Validation and Create;  v_cncpt_src:  STRING: String; DROP-DOWN: Drop-downs
procedure createVMConcept(rowform in out t_row, v_cncpt_src in varchar2, v_mode in varchar2,  actions in out t_actions) as
v_nm  varchar2(255);
v_long_nm varchar2(255);
v_def  varchar2(4000);
row t_row;
rows t_rows;
 action t_actionRowset;
 v_cncpt_id  number;
 v_cncpt_ver_nr number(4,2);
 v_temp_id  number;
 v_temp_ver number(4,2);
 v_item_id  number;
 v_ver_nr number(4,2);
 v_id integer;
 v_long_nm_suf  varchar2(255);
 j integer;
i integer;
cnt integer;
v_str varchar2(255);
v_obj_nm  varchar2(100);
v_temp varchar2(4000);
v_cncpt_nm varchar2(255);
idx integer;
v_item_typ_id integer;
begin

idx := 1;
v_item_typ_id := 53;

/*
3 possible scenarios

1. Clicked on update without changing anything. Do nothing.
2. Only updated specified name. No concepts. In this case, only update the name.
3.  Updated concepts. Delete existing concepts and add new concepts.

Only drop-downs allowed.

GEN_STR holds current VM name
ITEM_2_ID holds Item ID of VM and ITEM_2_VER_NR holds Version number
*/

-- Initialize variables if something has changed
        rows := t_rows();
        row := t_row();
        j := 0;
        v_item_id := ihook.getColumnValue(rowform, 'ITEM_2_ID');
        v_ver_nr := ihook.getColumnValue(rowform, 'ITEM_2_VER_NR');

-- If only name specified
            nci_11179.spReturnAIRow (v_item_id, v_ver_nr, row);
            nci_11179.spReturnAIExtRow (v_item_id, v_ver_nr,  row);
            ihook.setColumnValue(row,'ITEM_NM', ihook.getColumnValue(rowform, 'ITEM_2_NM'));
            ihook.setColumnValue(row,'ITEM_DESC', nvl(ihook.getColumnValue(rowform, 'ITEM_2_DEF'), ihook.getColumnValue(rowform, 'ITEM_2_NM')));
            ihook.setColumnValue(row,'CNCPT_CONCAT', ihook.getColumnValue(rowform, 'ITEM_2_NM'));
            ihook.setColumnValue(row,'CNCPT_CONCAT_NM', ihook.getColumnValue(rowform, 'ITEM_2_NM'));
            ihook.setColumnValue(row,'CNCPT_CONCAT_DEF', ihook.getColumnValue(row, 'ITEM_DESC'));

            rows.extend;     rows(rows.last) := row;

            action := t_actionrowset(rows, 'Administered Item (No Sequence)', 2,1,'update');
            actions.extend;
            actions(actions.last) := action;

            action := t_actionrowset(rows, 'NCI AI Extension (Hook)', 2,3,'update');
            actions.extend;
            actions(actions.last) := action;


-- Scenario 3 - first delete current concepts and then insert
        rows := t_rows();
        row := t_row();

        for cur in (select CNCPT_AI_ID from cncpt_admin_item where item_id = v_item_id and ver_nr = v_ver_nr) loop
                row := t_row();
                ihook.setColumnValue (row, 'CNCPT_AI_ID', cur.CNCPT_AI_ID);
                rows.extend;     rows(rows.last) := row;
        end loop;

        if rows.count > 0 then
            action := t_actionrowset(rows, 'Items under Concept (Hook)', 2,1,'delete');
            actions.extend;
            actions(actions.last) := action;

            action := t_actionrowset(rows, 'Items under Concept (Hook)', 2,2,'purge');
            actions.extend;
            actions(actions.last) := action;
        end if;

        rows := t_rows();

        if (ihook.getColumnValue(rowform, 'CNCPT_1_ITEM_ID_1') is not null) then  --- If drop-down specified, manually entered text is overwritten.
            for i in reverse 0..10 loop
                    v_cncpt_id := ihook.getColumnValue(rowform, 'CNCPT_' || idx  ||'_ITEM_ID_' || i);
                    v_cncpt_ver_nr :=  ihook.getColumnValue(rowform, 'CNCPT_' || idx || '_VER_NR_' || i);
                    if( v_cncpt_id is not null) then
                        for cur in (select item_nm, item_long_nm, item_desc from admin_item where item_id = v_cncpt_id and ver_nr = v_cncpt_ver_nr) loop
                                row := t_row();
                                ihook.setColumnValue(row,'ITEM_ID', v_item_id);
                                ihook.setColumnValue(row,'VER_NR', v_ver_nr);
                                ihook.setColumnValue(row,'CNCPT_ITEM_ID',v_cncpt_id);
                                ihook.setColumnValue(row,'CNCPT_VER_NR', v_cncpt_ver_nr);
                                ihook.setColumnValue(row,'NCI_ORD', j);
                                ihook.setColumnValue(row,'CNCPT_AI_ID', -1);

                                v_temp := v_temp || i || ':' ||  v_cncpt_id;
                                if j = 0 then
                                    ihook.setColumnValue(row,'NCI_PRMRY_IND', 1);
                                else ihook.setColumnValue(row,'NCI_PRMRY_IND', 0);
                                end if;
                                rows.extend;
                                rows(rows.last) := row;
                                j := j+ 1;
                        end loop;
                    end if;
            end loop;
            action := t_actionrowset(rows, 'Items under Concept (Hook)', 2,6,'insert');
            actions.extend;
            actions(actions.last) := action;
        end if;


end;



END;
/
