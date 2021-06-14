create or replace PACKAGE            nci_vd AS
  function getVDCreateForm (v_rowset1 in t_rowset,v_rowset2 in t_rowset) return t_forms;
  function getVDcreateQuestion(v_first in Boolean,V_from in number) return t_question;
  procedure createVD(rowai in t_row, rowvd in t_row, actions in out t_actions, v_id out  number);
  procedure spVDCommon ( v_init_ai in t_rowset,v_init_vd in t_rowset,v_from in number,  v_op  in varchar2,  hookInput in t_hookInput, hookOutput in out t_hookOutput);
  PROCEDURE spVDCreateNew (v_data_in in clob, v_data_out out clob);
    procedure createValAIWithConcept(rowform in out t_row,   idx in integer,v_item_typ_id in integer, v_mode in varchar2,v_cncpt_src in varchar2,  actions in out t_actions);
  PROCEDURE spVDCreateFrom (v_data_in in clob, v_data_out out clob);
 PROCEDURE spVDEdit (v_data_in in clob, v_data_out out clob, v_usr_id in varchar2);
---  PROCEDURE spVDEdit (v_data_in in clob, v_data_out out clob, v_usr_id  IN varchar2);
 PROCEDURE spCreateRTSA (v_data_in in clob, v_data_out out clob, v_usr_id in varchar2);
 PROCEDURE spCreateVMSA (v_data_in in clob, v_data_out out clob, v_usr_id in varchar2);

procedure spVDValCreateImport ( rowform in out t_row , v_op  in varchar2, actions in out t_actions,  v_val_ind in out boolean);
  procedure createVDImport(rowform in out t_row, actions in out t_actions);

END;
/
create or replace PACKAGE BODY            nci_vd AS
c_long_nm_len  integer := 30;
c_nm_len integer := 255;
c_ver_suffix varchar2(5) := 'v1.00';
v_dflt_txt    varchar2(100) := 'Enter text or auto-generated.';

function getVDCreateForm (v_rowset1 in t_rowset,v_rowset2 in t_rowset) return t_forms is
  forms t_forms;
  form1 t_form;
begin
    forms                  := t_forms();
    form1                  := t_form('Administered Item (Data Element CO)', 2,1);
    form1.rowset :=v_rowset1;
    forms.extend;    forms(forms.last) := form1;

    form1                  := t_form('Rep Term (Hook Creation)', 2,1);
    form1.rowset :=v_rowset2;
    forms.extend;    forms(forms.last) := form1;

  return forms; 

end;

function getVDcreateQuestion(v_first in Boolean,V_from in number) return t_question is
  question t_question;
  answer t_answer;
  answers t_answers;
begin

 ANSWERS                    := T_ANSWERS();
    ANSWER                     := T_ANSWER(1, 1, 'Validate Using String');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
  --  ANSWERS                    := T_ANSWERS();
    ANSWER                     := T_ANSWER(2, 2, 'Validate Using Drop-Down');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
    IF v_first=false then
    ANSWER                     := T_ANSWER(3, 3, 'Create/Edit Using String');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
    ANSWER                     := T_ANSWER(4, 4, 'Create/Edit Using Drop-Down');
    ANSWERS.EXTEND;
    ANSWERS(ANSWERS.LAST) := ANSWER;
    end IF;
    If V_from=1 then
    QUESTION               := T_QUESTION('Create New VD', ANSWERS);
    elsif V_from=2 then
    QUESTION               := T_QUESTION('Create VD from Existing', ANSWERS);
    else
    QUESTION               := T_QUESTION('Edit VD', ANSWERS);
    end if;
return question;
end;

procedure createVD (rowai in t_row, rowvd in t_row, actions in out t_actions, v_id out  number) as
v_nm  varchar2(255);
v_long_nm varchar2(255);
v_def  varchar2(4000);
v_dtype_id integer;
row t_row;
rows t_rows;
 action t_actionRowset;
 --v_id number;
begin
   rows := t_rows();
   row := rowai;
     v_id := nci_11179.getItemId;
        ihook.setColumnValue(row,'ITEM_ID', v_id);
      --  raise_application_error (-20000, ihook.getColumnValue(rowform,'CONC_DOM_ITEM_ID')  || ihook.getColumnValue(rowform, 'ITEM_1_ID') || ihook.getColumnValue(rowform, 'ITEM_2_ID'));
      if (ihook.getColumnValue(rowai, 'ITEM_LONG_NM') = v_dflt_txt) then
         ihook.setColumnValue(row,'ITEM_LONG_NM', v_id || c_ver_suffix);
      end if;

      if (ihook.getColumnValue(rowai, 'ITEM_NM') = v_dflt_txt) then
         ihook.setColumnValue(row,'ITEM_NM',  ihook.getColumnValue(rowvd, 'ITEM_1_NM')  );
      end if;

      if (ihook.getColumnValue(rowai, 'ITEM_DESC') = v_dflt_txt) then
        ihook.setColumnValue(row,'ITEM_DESC',substr(ihook.getColumnValue(rowvd, 'ITEM_1_DEF')  ,1,4000));
     end if;

     ihook.setColumnValue(row, 'ADMIN_ITEM_TYP_ID', 3);

        rows.extend;
        rows(rows.last) := row;
--raise_application_error(-20000, 'Deep' || ihook.getColumnValue(row,'CNTXT_ITEM_ID') || 'ggg'|| ihook.getColumnValue(row,'ADMIN_STUS_ID') || 'GGGG' || ihook.getColumnValue(row,'ITEM_ID'));

        action := t_actionrowset(rows, 'Administered Item (No Sequence)', 2,7,'insert');
        actions.extend;
        actions(actions.last) := action;
--Rep Term (Hook Creation)
        rows := t_rows();
        row := rowvd;
        ihook.setColumnValue(row,'ITEM_ID', v_id);
        ihook.setColumnValue(row,'VER_NR', 1);
        ihook.setColumnValue(row,'REP_CLS_ITEM_ID',  ihook.getColumnValue(rowvd,'ITEM_1_ID'));
        ihook.setColumnValue(row,'REP_CLS_VER_NR',  ihook.getColumnValue(rowvd,'ITEM_1_VER_NR'));
         if (ihook.getColumnValue(row, 'DTTYPE_ID') is null and  ihook.getColumnValue(row,'NCI_STD_DTTYPE_ID') is not null) then --- Tracker 667
            select NCI_DFLT_LEGCY_ID into v_dtype_id from data_typ where DTTYPE_ID = ihook.getColumnValue(row,'NCI_STD_DTTYPE_ID');
            ihook.setColumnValue(row, 'DTTYPE_ID', v_dtype_id);
        end if;
        rows.extend;
        rows(rows.last) := row;
       action := t_actionrowset(rows, 'Value Domain', 2,8,'insert');        
       actions.extend;
       actions(actions.last) := action;


end;


procedure spVDValCreateImport ( rowform in out t_row , v_op  in varchar2, actions in out t_actions,  v_val_ind in out boolean)
AS

    row t_row;
    rows  t_rows;
    row_ori t_row;
    v_id number;
    v_ver_nr number(4,2);
    v_nm  varchar2(255);    
    action t_actionRowset;
    v_msg varchar2(1000);
    i integer := 0;
    v_item_nm varchar2(255);
    v_item_id number;
    v_rep_id number;
    v_rep_ver number(4,2);
    v_item_desc varchar2(4000);
    v_count number;
    v_valid boolean;
    v_temp varchar2(100);
    v_substr  varchar2(100);
    v_temp_id number;
    v_temp_ver number(4,2);
    rowsetvd t_rowset;
    rowsetai t_rowset;
    rowsetrp t_rowset;
    rowset            t_rowset;
     v_rep_nm varchar2(255);
    v_cncpt_nm varchar2(255);
    v_long_nm varchar2(255);
    v_def varchar2(4000);
    v_dtype_id integer;
 BEGIN

 if (ihook.getColumnValue(rowform, 'VAL_DOM_ITEM_ID') is null) then --- only if Value Domain not specified
        if (   ihook.getColumnValue(rowform, 'CNCPT_3_ITEM_ID_1') is null ) then
                  ihook.setColumnValue(rowform, 'CTL_VAL_MSG', ihook.getColumnValue(rowform, 'CTL_VAL_MSG') || 'Rep Term primary concept missing.' || chr(13));
                  v_val_ind  := false;
        end if;

        if (   ihook.getColumnValue(rowform, 'VAL_DOM_TYP_ID') is null ) then
                  ihook.setColumnValue(rowform, 'CTL_VAL_MSG', ihook.getColumnValue(rowform, 'CTL_VAL_MSG') || 'Value Domain Type is missing.' || chr(13));
                  v_val_ind  := false;
        end if;

        if (   ihook.getColumnValue(rowform, 'NCI_STD_DTTYPE_ID') is null ) then
                  ihook.setColumnValue(rowform, 'CTL_VAL_MSG', ihook.getColumnValue(rowform, 'CTL_VAL_MSG') || 'Standard Data Type is missing.' || chr(13));
                  v_val_ind  := false;
        end if;

          if (   ihook.getColumnValue(rowform, 'CONC_DOM_ITEM_ID') is null and ihook.getColumnValue(rowform, 'VD_CONC_DOM_ITEM_ID') is null) then
                  ihook.setColumnValue(rowform, 'CTL_VAL_MSG', ihook.getColumnValue(rowform, 'CTL_VAL_MSG') || 'VD Conceptual Domain is missing.' || chr(13));
                  v_val_ind  := false;
        end if;


      if (ihook.getColumnValue(rowform, 'DTTYPE_ID') is null and  ihook.getColumnValue(rowform,'NCI_STD_DTTYPE_ID') is not null) then --- Tracker 667
            select NCI_DFLT_LEGCY_ID into v_dtype_id from data_typ where DTTYPE_ID = ihook.getColumnValue(rowform,'NCI_STD_DTTYPE_ID');
            ihook.setColumnValue(rowform, 'DTTYPE_ID', v_dtype_id);
        end if;



    IF v_op  = 'C'  and v_val_ind = true THEN  -- Create

        createValAIWithConcept(rowform , 3,7,'C','DROP-DOWN',actions); -- Rep

                createVDImport(rowform, actions);

        end if;        

 else -- if VD specified
        for cur in (select item_nm from admin_item where item_id = ihook.getColumnValue(rowform, 'VAL_DOM_ITEM_ID') and ver_nr = ihook.getColumnValue(rowform, 'VAL_DOM_VER_NR')) loop
       ihook.setColumnValue(rowform, 'VAL_DOM_NM',cur.item_nm ) ;
        end loop;
end if;


--V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);


END;  


  procedure createVDImport(rowform in out t_row, actions in out t_actions)
   as
v_nm  varchar2(255);
v_long_nm varchar2(255);
v_def  varchar2(4000);
v_dtype_id integer;
row t_row;
rows t_rows;
 action t_actionRowset;
 v_id number;
begin
   rows := t_rows();
   row := rowform;
     v_id := nci_11179.getItemId;
        ihook.setColumnValue(row,'ITEM_ID', v_id);
        ihook.setColumnValue(rowform,'VAL_DOM_ITEM_ID_CREAT', v_id);

         ihook.setColumnValue(row,'ITEM_LONG_NM', v_id || c_ver_suffix);

         ihook.setColumnValue(row,'ITEM_NM',  nvl(ihook.getColumnValue(rowform, 'VAL_DOM_NM'),ihook.getColumnValue(rowform, 'ITEM_3_NM'))  );
        ihook.setColumnValue(row,'ITEM_DESC',substr(ihook.getColumnValue(rowform, 'ITEM_3_DEF')  ,1,4000));

     ihook.setColumnValue(row, 'ADMIN_ITEM_TYP_ID', 3);
        ihook.setColumnValue(row,'REP_CLS_ITEM_ID',  ihook.getColumnValue(rowform,'ITEM_3_ID'));
        ihook.setColumnValue(row,'REP_CLS_VER_NR',  ihook.getColumnValue(rowform,'ITEM_3_VER_NR'));
        ihook.setColumnValue(row,'CONC_DOM_ITEM_ID',  nvl(ihook.getColumnValue(rowform,'VD_CONC_DOM_ITEM_ID'),ihook.getColumnValue(rowform,'CONC_DOM_ITEM_ID')));
        ihook.setColumnValue(row,'CONC_DOM_VER_NR',  nvl(ihook.getColumnValue(rowform,'VD_CONC_DOM_VER_NR'),ihook.getColumnValue(rowform,'CONC_DOM_VER_NR')));
          nci_11179_2.setStdAttr(row);


        rows.extend;
        rows(rows.last) := row;
--raise_application_error(-20000, 'Deep' || ihook.getColumnValue(row,'CNTXT_ITEM_ID') || 'ggg'|| ihook.getColumnValue(row,'ADMIN_STUS_ID') || 'GGGG' || ihook.getColumnValue(row,'ITEM_ID'));

        action := t_actionrowset(rows, 'Administered Item (No Sequence)', 2,7,'insert');
        actions.extend;
        actions(actions.last) := action;

--Rep Term (Hook Creation)
        action := t_actionrowset(rows, 'Value Domain', 2,8,'insert');        
       actions.extend;
       actions(actions.last) := action;
   ihook.setColumnValue(rowform, 'CTL_VAL_MSG', ihook.getColumnValue(rowform, 'CTL_VAL_MSG') || 'VD Created Successfully with ID ' || v_id||c_ver_suffix || chr(13)) ;


end;




  PROCEDURE       spVDCommon ( v_init_ai in t_rowset,v_init_vd in t_rowset,v_from in number,  v_op  in varchar2,  hookInput in t_hookInput, hookOutput in out t_hookOutput)
AS

  showRowset t_showableRowset;
    rowform t_row;
    rowai t_row;
    rowvd t_row;
    forms t_forms;
    form1 t_form;   
    row t_row;
    rows  t_rows;
    row_ori t_row;
    v_id number;
    v_ver_nr number(4,2);
    v_nm  varchar2(255);    
    actions t_actions := t_actions();
    action t_actionRowset;
    v_msg varchar2(1000);
    i integer := 0;
    v_item_nm varchar2(255);
    v_item_id number;
    v_rep_id number;
    v_rep_ver number(4,2);
    v_item_desc varchar2(4000);
    v_count number;
    v_valid boolean;
    v_temp varchar2(100);
    v_substr  varchar2(100);
    v_temp_id number;
    v_temp_ver number(4,2);
    rowsetvd t_rowset;
    rowsetai t_rowset;
    rowsetrp t_rowset;
    rowvdold t_row;
    rowset            t_rowset;
     v_rep_nm varchar2(255);
    v_cncpt_nm varchar2(255);
    v_long_nm varchar2(255);
    v_def varchar2(4000);
    is_valid boolean;
    v_dtype_id integer;
 BEGIN


    if hookInput.invocationNumber = 0 then
        --  Get question. Either create or edit  
        hookOutput.question    := getVDCreateQuestion(true,v_from);

        -- Send initial rowset to create the form.
        hookOutput.forms := getVDCreateForm(v_init_ai,v_init_vd);

  ELSE
 --          raise_application_error(-20000, 'Here 1');
        forms              := hookInput.forms;
        form1              := forms(1);
        rowai := form1.rowset.rowset(1);
        form1              := forms(2);
        rowvd := form1.rowset.rowset(1);
        row := t_row();
        rows := t_rows();
        is_valid := true;

    IF HOOKINPUT.ANSWERID = 1 or Hookinput.answerid = 3 THEN  -- Validate using string

                for i in  2..10 loop
                        ihook.setColumnValue(rowvd, 'CNCPT_1_ITEM_ID_' || i,'');
                        ihook.setColumnValue(rowvd, 'CNCPT_1_VER_NR_' || i, '');
                end loop;
           --     raise_application_error(-20000, 'Here');   

               createValAIWithConcept(rowvd ,  1,7,'V','STRING',actions);

    end if;

    IF HOOKINPUT.ANSWERID = 2 or Hookinput.answerid = 4 THEN  -- Validate using drop-down       
               createValAIWithConcept(rowvd , 1,7,'V','DROP-DOWN',actions);          
    end if;

      --ihook.setColumnValue(rowform, 'GEN_STR',v_dec_nm ) ;
       ihook.setColumnValue(rowvd, 'GEN_STR',ihook.getColumnValue(rowvd,'ITEM_1_NM')  ) ;
       ihook.setColumnValue(rowvd, 'CTL_VAL_MSG', 'VALIDATED');  

      if (ihook.getColumnValue(rowvd, 'DTTYPE_ID') is null and  ihook.getColumnValue(rowvd,'NCI_STD_DTTYPE_ID') is not null) then --- Tracker 667
            select NCI_DFLT_LEGCY_ID into v_dtype_id from data_typ where DTTYPE_ID = ihook.getColumnValue(rowvd,'NCI_STD_DTTYPE_ID');
            ihook.setColumnValue(rowvd, 'DTTYPE_ID', v_dtype_id);
        --    raise_application_error(-20000, v_dtype_id);
        end if;


  /*     if (   ihook.getColumnValue(rowvd, 'ITEM_1_ID') is not null ) then
              for cur in (select VALUE_DOM.* from VALUE_DOM, admin_item ai where REP_CLS_ITEM_ID =  ihook.getColumnValue(rowvd, 'ITEM_1_ID') 
              and REP_CLS_VER_NR =  ihook.getColumnValue(rowvd, 'ITEM_1_VER_NR') and
                 VALUE_DOM.item_id = ai.item_id and VALUE_DOM.ver_nr = ai.ver_nr 
                 and ai.cntxt_item_id = ihook.getColumnValue(rowai, 'CNTXT_ITEM_ID')
              and ai.cntxt_ver_nr = ihook.getColumnValue(rowai, 'CNTXT_VER_NR'))
               loop
                    ihook.setColumnValue(rowvd, 'CTL_VAL_MSG', 'DUPLICATE VD');
                    is_valid := false;
              end loop;

        end if; 
    */ 
        if (   ihook.getColumnValue(rowvd, 'CNCPT_1_ITEM_ID_1') is null ) then
                  ihook.setColumnValue(rowvd, 'CTL_VAL_MSG', 'Rep Term missing.');
                  is_valid := false;
        end if;

        if (   ihook.getColumnValue(rowai, 'ADMIN_STUS_ID') = 75 and  ihook.getColumnValue(rowvd, 'VAL_DOM_TYP_ID') =  17
        and v_op = 'insert' and v_from <> 2) then -- Status cannot be released if VD is enumerated
                  ihook.setColumnValue(rowvd, 'CTL_VAL_MSG', 'An Enumerated VD WFS cannot be Released if there are no permissible values.');
                  is_valid := false;
        end if;

--raise_application_error(-20000, ihook.getColumnValue(rowai,'ITEM_LONG_NM'));
-- Short name uniqueness
--raise_application_error(-20000, ihook.getColumnValue(rowai,'ITEM_LONG_NM'));
      for cur in (select ai.item_id item_id from admin_item ai
            where
            trim(ai.ITEM_LONG_NM)=trim(ihook.getColumnValue(rowai,'ITEM_LONG_NM'))
        --    and  ai.ver_nr =  ihook.getColumnValue(rowai, 'VER_NR') 
            and ai.cntxt_item_id = ihook.getColumnValue(rowai, 'CNTXT_ITEM_ID') 
            and  ai.cntxt_ver_nr = ihook.getColumnValue(rowai, 'CNTXT_VER_NR')
            and ai.item_id <>  nvl(ihook.getColumnValue(rowai, 'ITEM_ID'),0)) 
            loop
                is_valid := false;
                ihook.setColumnValue(rowvd, 'CTL_VAL_MSG', 'Duplicate VD found based on context/short name: ' || cur.item_id || chr(13));

            end loop;


         rows := t_rows();
             -- If any of the test fails or if the user has triggered validation, then go back to the screen.
        if is_valid=false or hookinput.answerid in (1, 2) then
                rows := t_rows();      
                rows.extend;        

            --- Add Concept to name if edit and concepts changed. Tracker 866
           if (v_op = 'update') then
                rowvdold := v_init_vd.rowset(1);
                v_nm := ihook.getColumnValue(rowai, 'ITEM_NM');
                v_def := ihook.getColumnValue(rowai, 'ITEM_DESC');

                for i in 1..10 loop
                    if (ihook.getColumnValue(rowvd, 'CNCPT_1_ITEM_ID_' || i) <> nvl(ihook.getColumnValue(rowvdold, 'CNCPT_1_ITEM_ID_' || i),0) ) then
                       for cur in (select item_nm, item_desc from admin_item  where item_id = ihook.getColumnValue(rowvd, 'CNCPT_1_ITEM_ID_' || i) and ver_nr = ihook.getColumnValue(rowvd, 'CNCPT_1_VER_NR_' || i)) loop
                        v_nm := v_nm || ' ' || cur.item_nm;
                        v_def := v_def || '_' || cur.item_desc;

                       end loop;
                    end if;
                end loop;
                ihook.setColumnValue (rowai, 'ITEM_NM', v_nm);
                ihook.setColumnValue (rowai, 'ITEM_DESC', v_def);
            end if; 

                ihook.setColumnValue(rowai,'ADMIN_ITEM_TYP_ID', 3);
                if (v_from = 2) then -- create from existing then update name and definition
                    ihook.setColumnValue(rowai,'ITEM_NM', ihook.getColumnValue(rowvd,'ITEM_1_NM' ));
                    ihook.setColumnValue(rowai,'ITEM_DESC', ihook.getColumnValue(rowvd,'ITEM_1_DEF'));
                
                end if;
                rows(rows.last) := rowai;
                rowsetai := t_rowset(rows, 'Administered Item (Hook Creation)', 1, 'ADMIN_ITEM'); 
                rows := t_rows();       
                rows.extend;
                rows(rows.last) := rowvd;
                rowset := t_rowset(rows, 'Rep Term (Hook Creation)', 1, 'NCI_STG_AI_CNCPT_CREAT');
                hookOutput.forms := getVDCreateForm(rowsetai,rowset);             
                HOOKOUTPUT.QUESTION    := getVDCreateQuestion(false,v_from);
        end if;


     -- If all the tests have passed and the user has asked for create, then create VD and Repp.     
    -- raise_application_error(-20000, 'Here2');    
    IF HOOKINPUT.ANSWERID in ( 3,4)  and is_valid = true THEN  -- Create
        ihook.setColumnValue(rowvd, 'CNTXT_ITEM_ID', ihook.getColumnValue(rowai,'CNTXT_ITEM_ID'));
        ihook.setColumnValue(rowvd, 'CNTXT_VER_NR', ihook.getColumnValue(rowai,'CNTXT_VER_NR'));

        createValAIWithConcept(rowvd , 1,7,'C','DROP-DOWN',actions); -- Rep

              if (v_op = 'insert') then
                createVD(rowai, rowvd, actions, v_item_id);
                hookoutput.message := 'VD Created Successfully with ID ' || v_item_id ;

              else  
                -- Update VD. Get the selected row, update name, definition, context.
                    row := t_row();
                    row_ori :=  hookInput.originalRowset.rowset(1);

                    v_item_id := ihook.getColumnValue(row_ori,'ITEM_ID');
                    v_ver_nr := ihook.getColumnValue(row_ori,'VER_NR');

                     --- Update name, definition, context
                    row := rowai;
                         ihook.setColumnValue(row, 'ADMIN_ITEM_TYP_ID', 3);
            rows := t_rows();    rows.extend;    rows(rows.last) := row;
                action := t_actionrowset(rows, 'Administered Item (No Sequence)', 2,10,'update');
                actions.extend;
                actions(actions.last) := action;
                row := rowvd;
           -- Get the Sub-type row. Update REP CD.

         --   nci_11179.spReturnSubtypeRow (v_item_id, v_ver_nr, 2, row );
            ihook.setColumnValue(row, 'REP_CLS_ITEM_ID', ihook.getColumnValue(rowvd,'ITEM_1_ID'));
            ihook.setColumnValue(row, 'REP_CLS_VER_NR', ihook.getColumnValue(rowvd,'ITEM_1_VER_NR'));
            ihook.setColumnValue(row, 'ITEM_ID', v_item_id);
            ihook.setColumnValue(row, 'VER_NR', v_ver_nr);


             rows := t_rows();    rows.extend;    rows(rows.last) := row;
             action := t_actionrowset(rows, 'Value Domain', 2,11,'update');
        actions.extend;
        actions(actions.last) := action;
        end if;

        if (v_from = 2 and v_op = 'insert') then --- create from existing and enumerated copy Perm Val
             rows := t_rows();
               row_ori := hookinput. originalrowset.rowset(1);
        
            nci_11179.CopyPermVal (actions, ihook.getColumnValue(row_ori,'ITEM_ID'), ihook.getColumnValue(row_ori,'VER_NR'), v_item_id, 1);

        end if;


--        rows := t_rows();        rows.extend;        rows(rows.last) := rowai;
--        action := t_actionrowset(rows, 'Administered Item (No Sequence)', 2,1,v_op);
--        actions(actions.last) := action;
--
--        ihook.setColumnValue(rowvd,'ITEM_ID',  ihook.getColumnValue(rowai,'ITEM_ID'));
--       ihook.setColumnValue(rowvd,'VER_NR', ihook.getColumnValue(rowai,'VER_NR'));
--       rows := t_rows();        rows.extend;        rows(rows.last) := rowvd;
--        action := t_actionrowset(rows, 'Value Domain', 2,2,v_op);
--        actions.extend;
--        actions(actions.last) := action;
--        --nci_chng_mgmt.createDEC(rowform, actions, v_item_id);
--        hookoutput.message := 'VD Created Successfully with ID ' || v_item_id ;
        hookoutput.actions := actions;

    end if;

end if;

--V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);


END;  
--
PROCEDURE spVDCreateFrom ( v_data_in IN CLOB, v_data_out OUT CLOB) as
    hookInput t_hookInput;
    hookOutput t_hookOutput := t_hookOutput();
    row_ori  t_row;
    row  t_row;
    rows t_rows;
    v_item_id  number;
    v_rc_item_id number;
    v_rc_ver_nr number(4,2);
    v_ver_nr  number(4,2);
    v_ori_rep_cls number;
    v_item_type_id number;
    rowai t_row;
    rowvd t_row;
    rowset  t_rowset;
    rowsetst  t_rowset;
    rowsetai  t_rowset;
    rowsetrp  t_rowset;
begin
--    -- Standard header
    hookinput                    := Ihook.gethookinput (v_data_in);
    hookoutput.invocationnumber  := hookinput.invocationnumber;
    hookoutput.originalrowset    := hookinput.originalrowset;

    -- Get the selected row
    row_ori :=  hookInput.originalRowset.rowset(1);
    v_item_id := ihook.getColumnValue(row_ori, 'ITEM_ID');
    v_ver_nr := ihook.getColumnValue(row_ori, 'VER_NR');
    v_item_type_id := ihook.getColumnValue(row_ori, 'ADMIN_ITEM_TYP_ID');
--

    if (hookinput.invocationnumber = 0) then 
--    -- check that a selected AI is VD type
    if (v_item_type_id <> 3) then -- 3 - VALUE DOMAIN in table OBJ_KEY
        raise_application_error(-20000,'!!! This functionality is only applicable for VD !!!');
    end if;
--
--
    rowai := row_ori;
    rowvd := t_row();

select rep_cls_item_id, rep_cls_ver_nr into v_rc_item_id, v_rc_ver_nr
from value_dom where item_id = v_item_id and ver_nr = v_ver_nr;
--
    nci_11179.spReturnSubtypeRow (v_item_id, v_ver_nr, 3,  rowvd );

--     -- Copy subtype specific attributes
    nci_11179.spReturnRTConceptRow (v_rc_item_id, v_rc_ver_nr, 7, 1, rowvd );
--   
--    
    ihook.setColumnValue(rowai, 'ITEM_LONG_NM', v_dflt_txt);
    ihook.setColumnValue(rowai, 'ITEM_ID', -1);
    ihook.setColumnValue(rowvd, 'STG_AI_ID', 1);
      ihook.setColumnValue(rowai, 'ADMIN_STUS_ID', 66);
          ihook.setColumnValue(rowai, 'REGSTR_STUS_ID', 9);

     rows := t_rows();    rows.extend;    rows(rows.last) := rowai;
     rowsetai := t_rowset(rows, 'Administered Item', 1, 'ADMIN_ITEM');
--   
     rows := t_rows();    rows.extend;    rows(rows.last) := rowvd;

    rowsetst := t_rowset(rows, 'Rep Term (Hook Creation)', 1, 'NCI_STG_AI_CNCPT_CREAT');
--   
    end if;

   spVDCommon(rowsetai, rowsetst, 2, 'insert', hookinput, hookoutput);

--
    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);
     nci_util.debugHook('GENERAL',v_data_out);
end;
--

PROCEDURE spVDEdit ( v_data_in IN CLOB, v_data_out OUT CLOB, v_usr_id in varchar2) as
    hookInput t_hookInput;
    hookOutput t_hookOutput := t_hookOutput();
    row_ori  t_row;
    row  t_row;
    rows t_rows;
    v_item_id  number;
    v_rc_item_id number;
    v_rc_ver_nr number(4,2);
    v_ver_nr  number(4,2);
    v_ori_rep_cls number;
    v_item_type_id number;
    rowai t_row;
    rowvd t_row;
    rowset  t_rowset;
    rowsetst  t_rowset;
    rowsetai  t_rowset;
    rowsetrp  t_rowset;
begin
--    -- Standard header
    hookinput                    := Ihook.gethookinput (v_data_in);
    hookoutput.invocationnumber  := hookinput.invocationnumber;
    hookoutput.originalrowset    := hookinput.originalrowset;

    -- Get the selected row
    row_ori :=  hookInput.originalRowset.rowset(1);
    v_item_id := ihook.getColumnValue(row_ori, 'ITEM_ID');
    v_ver_nr := ihook.getColumnValue(row_ori, 'VER_NR');
    v_item_type_id := ihook.getColumnValue(row_ori, 'ADMIN_ITEM_TYP_ID');
--

 --   if (hookinput.invocationnumber = 0) then 
--    -- check that a selected AI is VD type
    if (v_item_type_id <> 3) then -- 3 - VALUE DOMAIN in table OBJ_KEY
        raise_application_error(-20000,'!!! This functionality is only applicable for VD !!!');
    end if;
--
--  user authorization
   if (nci_11179_2.isUserAuth(v_item_id, v_ver_nr, v_usr_id) = false) then
        raise_application_error(-20000, 'You are not authorized to insert/update or delete in this context. ');
        return;
    end if;

    rowai := row_ori;
    rowvd := t_row();

select rep_cls_item_id, rep_cls_ver_nr into v_rc_item_id, v_rc_ver_nr
from value_dom where item_id = v_item_id and ver_nr = v_ver_nr;
--
    nci_11179.spReturnSubtypeRow (v_item_id, v_ver_nr, 3,  rowvd );

--     -- Copy subtype specific attributes
    nci_11179.spReturnRTConceptRow (v_rc_item_id, v_rc_ver_nr, 7, 1, rowvd );
--   
--    
    ihook.setColumnValue(rowvd, 'STG_AI_ID', 1);

     rows := t_rows();    rows.extend;    rows(rows.last) := rowai;
     rowsetai := t_rowset(rows, 'Administered Item', 1, 'ADMIN_ITEM');
--   
     rows := t_rows();    rows.extend;    rows(rows.last) := rowvd;

    rowsetst := t_rowset(rows, 'Rep Term (Hook Creation)', 1, 'NCI_STG_AI_CNCPT_CREAT');
--   
 --   end if;

   spVDCommon(rowsetai, rowsetst, 3, 'update', hookinput, hookoutput);

--
    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);
 --nci_util.debugHook('GENERAL',v_data_out);

end;

--
PROCEDURE spVDCreateNew ( v_data_in IN CLOB, v_data_out OUT CLOB)
as
  hookInput t_hookInput;
    hookOutput t_hookOutput := t_hookOutput();
    row_ori  t_row;
    row  t_row;
    rows t_rows;
    v_dflt_txt    varchar2(100) := 'Enter text or auto-generated.';
    rowsetai  t_rowset;
    rowsetst  t_rowset;
begin
    -- Standard header
    hookinput                    := Ihook.gethookinput (v_data_in);
    hookoutput.invocationnumber  := hookinput.invocationnumber;
    hookoutput.originalrowset    := hookinput.originalrowset;


    -- Default for new row. Dummy Identifier has to be set else error.
    row := t_row();
    ihook.setColumnValue(row, 'STG_AI_ID', 1);
        ihook.setColumnValue(row, 'CURRNT_VER_IND', 1);
          ihook.setColumnValue(row, 'VER_NR', 1.0);
          ihook.setColumnValue(row, 'ADMIN_STUS_ID', 66);
          ihook.setColumnValue(row, 'REGSTR_STUS_ID', 9);
          ihook.setColumnValue(row, 'ADMIN_ITEM_TYP_ID', 3);
          ihook.setColumnValue(row, 'ITEM_NM', v_dflt_txt);
          ihook.setColumnValue(row, 'ITEM_DESC', v_dflt_txt);
          ihook.setColumnValue(row, 'ITEM_LONG_NM', v_dflt_txt);

    rows := t_rows(); rows.extend;    rows(rows.last) := row;
    rowsetai := t_rowset(rows, 'Administered Item', 1, 'ADMIN_ITEM'); -- Default values for AI form
    rowsetst := t_rowset(rows, 'Value Domain', 1, 'VALUE_DOM'); -- Default values for VD form

    spVDCommon(rowsetai,rowsetst,1, 'insert', hookinput, hookoutput);

    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);
   --  nci_util.debugHook('GENERAL',v_data_out);
end;



PROCEDURE spCreateVMSA ( v_data_in IN CLOB, v_data_out OUT CLOB, v_usr_id in varchar2)
as
  hookInput t_hookInput;
    hookOutput t_hookOutput := t_hookOutput();
    row_ori  t_row;
    row  t_row;
    rows t_rows;
    v_dflt_txt    varchar2(100) := 'Enter text or auto-generated.';
    rowsetai  t_rowset;
    rowsetst  t_rowset;
begin
    -- Standard header
    hookinput                    := Ihook.gethookinput (v_data_in);
    hookoutput.invocationnumber  := hookinput.invocationnumber;
    hookoutput.originalrowset    := hookinput.originalrowset;


    -- Default for new row. Dummy Identifier has to be set else error.
    row := t_row();
    ihook.setColumnValue(row, 'STG_AI_ID', 1);
        ihook.setColumnValue(row, 'CURRNT_VER_IND', 1);
          ihook.setColumnValue(row, 'VER_NR', 1.0);
          ihook.setColumnValue(row, 'ADMIN_STUS_ID', 66);
          ihook.setColumnValue(row, 'REGSTR_STUS_ID', 9);
          ihook.setColumnValue(row, 'ADMIN_ITEM_TYP_ID', 3);
          ihook.setColumnValue(row, 'ITEM_NM', v_dflt_txt);
          ihook.setColumnValue(row, 'ITEM_DESC', v_dflt_txt);
          ihook.setColumnValue(row, 'ITEM_LONG_NM', v_dflt_txt);

    rows := t_rows(); rows.extend;    rows(rows.last) := row;
    rowsetai := t_rowset(rows, 'Administered Item', 1, 'ADMIN_ITEM'); -- Default values for AI form
    rowsetst := t_rowset(rows, 'Value Domain', 1, 'VALUE_DOM'); -- Default values for VD form

    spVDCommon(rowsetai,rowsetst,1, 'insert', hookinput, hookoutput);

    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);
   --  nci_util.debugHook('GENERAL',v_data_out);
end;


PROCEDURE spCreateRTSA ( v_data_in IN CLOB, v_data_out OUT CLOB,  v_usr_id in varchar2)
as
  hookInput t_hookInput;
    hookOutput t_hookOutput := t_hookOutput();
    row_ori  t_row;
    row  t_row;
    rows t_rows;
    v_dflt_txt    varchar2(100) := 'Enter text or auto-generated.';
    rowsetai  t_rowset;
    rowsetst  t_rowset;
begin
    -- Standard header
    hookinput                    := Ihook.gethookinput (v_data_in);
    hookoutput.invocationnumber  := hookinput.invocationnumber;
    hookoutput.originalrowset    := hookinput.originalrowset;


    -- Default for new row. Dummy Identifier has to be set else error.
    row := t_row();
    ihook.setColumnValue(row, 'STG_AI_ID', 1);
        ihook.setColumnValue(row, 'CURRNT_VER_IND', 1);
          ihook.setColumnValue(row, 'VER_NR', 1.0);
          ihook.setColumnValue(row, 'ADMIN_STUS_ID', 66);
          ihook.setColumnValue(row, 'REGSTR_STUS_ID', 9);
          ihook.setColumnValue(row, 'ADMIN_ITEM_TYP_ID', 3);
          ihook.setColumnValue(row, 'ITEM_NM', v_dflt_txt);
          ihook.setColumnValue(row, 'ITEM_DESC', v_dflt_txt);
          ihook.setColumnValue(row, 'ITEM_LONG_NM', v_dflt_txt);

    rows := t_rows(); rows.extend;    rows(rows.last) := row;
    rowsetai := t_rowset(rows, 'Administered Item', 1, 'ADMIN_ITEM'); -- Default values for AI form
    rowsetst := t_rowset(rows, 'Value Domain', 1, 'VALUE_DOM'); -- Default values for VD form

    spVDCommon(rowsetai,rowsetst,1, 'insert', hookinput, hookoutput);

    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);
   --  nci_util.debugHook('GENERAL',v_data_out);
end;
--
--PROCEDURE spVDEdit ( v_data_in IN CLOB, v_data_out OUT CLOB, v_usr_id  IN varchar2)
--as
--    hookInput t_hookInput;
--    hookOutput t_hookOutput := t_hookOutput();
--    row_ori  t_row;
--    row  t_row;
--    rows t_rows;
--    v_item_id  number;
--    v_ver_nr  number(4,2);
--    v_ori_rep_cls number;
--    v_item_type_id number;
--    v_oc_item_id number;
--    v_prop_item_id number;
--    v_oc_ver_nr number(4,2);
--    v_prop_ver_nr number(4,2);
--      v_conc_dom_item_id number;
--    v_conc_dom_ver_nr number(4,2);
--    rowsetrp  t_rowset;
--    rowsetai  t_rowset;
--    rowsetst  t_rowset;
--    rowset  t_rowset;
--
--begin
--    -- Standard header
--    hookInput                    := Ihook.gethookinput (v_data_in);
--    hookOutput.invocationnumber  := hookInput.invocationnumber;
--    hookOutput.originalrowset    := hookInput.originalrowset;
--
--    -- Get the selected row
--    row_ori :=  hookInput.originalRowset.rowset(1);
--    v_item_id := ihook.getColumnValue(row_ori, 'ITEM_ID');
--    v_ver_nr := ihook.getColumnValue(row_ori, 'VER_NR');
--    v_item_type_id := ihook.getColumnValue(row_ori, 'ADMIN_ITEM_TYP_ID');
--
--
--    -- Check if user is authorized to edit
--    if (nci_11179_2.isUserAuth(v_item_id, v_ver_nr, v_usr_id) = false) then
--        raise_application_error(-20000, 'You are not authorized to insert/update or delete in this context. ');
--        return;
--    end if;
--
--    -- check that a selected AI is VD type
--    if (v_item_type_id <> 3) then -- 3 - VALUE DOMAIN in table OBJ_KEY
--        raise_application_error(-20000,'!!! This functionality is only applicable for VD !!!');
--    end if;
--
--
--    row := row_ori;
-- 
--select obj_cls_item_id, obj_cls_ver_nr, prop_item_id, prop_ver_nr, conc_dom_item_id, conc_dom_ver_nr into v_oc_item_id, v_oc_ver_nr, v_prop_item_id, v_prop_ver_nr ,
--v_conc_dom_item_id, v_conc_dom_ver_nr
--from de_conc where item_id = v_item_id and ver_nr = v_ver_nr;
--
--     -- Copy subtype specific attributes
--    nci_11179.spReturnConceptRow (v_oc_item_id, v_oc_ver_nr, 7, 1, row );
--    
--    ihook.setColumnValue(row, 'STG_AI_ID', 1);
--     ihook.setColumnValue(row, 'CONC_DOM_ITEM_ID', v_conc_dom_item_id);
--    ihook.setColumnValue(row, 'CONC_DOM_VER_NR', v_conc_dom_ver_nr);
--   
--    
--rows := t_rows();    rows.extend;    rows(rows.last) := row;
--     rowset := t_rowset(rows, 'AI Creation With Concepts', 1, 'NCI_STG_AI_CNCPT_CREAT');
--     
--    --spVDCommon(rowset, 'update', hookinput, hookoutput);
--spVDCommon(rowsetai, rowsetst, rowsetrp, 2, 'update', hookinput, hookoutput);
--
--    V_DATA_OUT := IHOOK.GETHOOKOUTPUT (HOOKOUTPUT);
--
--end;
--
--
--
-- v_mode : V - Validate, C - Validation and Create;  v_cncpt_src:  STRING: String; DROP-DOWN: Drop-downs
procedure createValAIWithConcept(rowform in out t_row,  idx in integer,v_item_typ_id in integer,v_mode in varchar2, v_cncpt_src in varchar2, actions in out t_actions) as
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
begin

if (v_cncpt_src ='STRING') then
      if (ihook.getColumnValue(rowform, 'CNCPT_CONCAT_STR_' || idx) is not null) then
                v_str := trim(ihook.getColumnValue(rowform, 'CNCPT_CONCAT_STR_'|| idx));
                cnt := nci_11179.getwordcount(v_str);
                v_nm := '';
                v_long_nm := '';
                v_def := '';
                for i in  1..cnt loop
                        j := i+1;
                        v_cncpt_nm := nci_11179.getWord(v_str, i, cnt);
                        ihook.setColumnValue(rowform, 'CNCPT_' || idx  ||'_ITEM_ID_' || j,'');
                        ihook.setColumnValue(rowform, 'CNCPT_' || idx || '_VER_NR_' || j, '');
                        for cur in(select item_id, item_nm , item_long_nm, item_desc from admin_item where admin_item_typ_id = 49 and upper(item_long_nm) = upper(trim(v_cncpt_nm))) loop
                                ihook.setColumnValue(rowform, 'CNCPT_' || idx  ||'_ITEM_ID_' || j,cur.item_id);
                                ihook.setColumnValue(rowform, 'CNCPT_' || idx || '_VER_NR_' || j, 1);
                               -- v_dec_nm := trim(v_dec_nm || ' ' || cur.item_nm) ;
                                v_long_nm_suf := trim(v_long_nm_suf || ':' || cur.item_long_nm);
                                v_nm := trim(v_nm || ' ' || cur.item_nm);
                              v_def := substr( v_def || '_' ||cur.item_desc  ,1,4000);
      
                        end loop;
                end loop;
                for i in  cnt+2..10 loop
                        ihook.setColumnValue(rowform, 'CNCPT_' || idx  ||'_ITEM_ID_' || i,'');
                        ihook.setColumnValue(rowform, 'CNCPT_' || idx || '_VER_NR_' || i, '');
                end loop;
    --            ihook.setColumnValue(rowform, 'ITEM_' || idx || '_NM', v_nm);
  --
            end if;

end if;

if (v_cncpt_src ='DROP-DOWN') then
        v_nm := '';
        v_long_nm_suf :='';
        v_def := '';
                for i in 2..10 loop
                        v_temp_id := ihook.getColumnValue(rowform, 'CNCPT_' || idx  ||'_ITEM_ID_' || i);
                        v_temp_ver := ihook.getColumnValue(rowform, 'CNCPT_' || idx || '_VER_NR_' || i);
                        if (v_temp_id is not null) then
                        for cur in(select item_id, item_nm , item_long_nm, item_desc from admin_item where admin_item_typ_id = 49 and item_id = v_temp_id and ver_nr = v_temp_ver) loop
                          --       v_dec_nm := trim(v_dec_nm || ' ' || cur.item_nm) ;
                              v_long_nm_suf := trim(v_long_nm_suf || ':' || cur.item_long_nm);
                                v_nm := trim(v_nm || ' ' || cur.item_nm);
                            v_def := substr( v_def || '_' ||cur.item_desc  ,1,4000);
                         end loop;
                        end if;
                end loop;

  end if;
        --- Primary Concept
             for cur in (select item_id, item_nm , item_long_nm from admin_item where admin_item_typ_id = 49 and item_id = ihook.getColumnValue(rowform, 'CNCPT_' || idx || '_ITEM_ID_1')
             and ver_nr  = ihook.getColumnValue(rowform, 'CNCPT_' || idx || '_VER_NR_1')) loop
                          --       v_dec_nm := trim(v_dec_nm || ' ' || cur.item_nm) ;
                              v_long_nm_suf := trim(v_long_nm_suf || ':' || cur.item_long_nm);
                                v_nm := trim(v_nm || ' ' || cur.item_nm);
                                --raise_application_error(-20000, 'In HEre' || cur.item_long_nm);
             end loop;
            v_long_nm_suf := substr(v_long_nm_suf,2);

     --  raise_application_error(-20000, v_long_nm_suf || '  Long name: ' || v_nm);
                ihook.setColumnValue(rowform,'ITEM_' || idx || '_LONG_NM', v_long_nm_suf);
                ihook.setColumnValue(rowform,'ITEM_' || idx || '_NM', v_nm);
               ihook.setColumnValue(rowform,'ITEM_' || idx || '_DEF', substr(v_def,2));

            nci_DEC_MGMT.CncptCombExistsNew (rowform , v_long_nm_suf, v_item_typ_id, idx , v_item_id, v_ver_nr);
      --      raise_application_error(-20000, 'HErer ' || v_item_id);

if (v_mode = 'C') AND V_ITEM_ID  is null then --- Create


        v_id := nci_11179.getItemId;

       rows := t_rows();
   --     raise_application_error(-20000,'OC');
          j := 1;
      v_nm := '';
       v_long_nm := '';
       v_def := '';
          for i in reverse 2..10 loop

          v_cncpt_id := ihook.getColumnValue(rowform, 'CNCPT_' || idx  ||'_ITEM_ID_' || i);
             v_cncpt_ver_nr :=  ihook.getColumnValue(rowform, 'CNCPT_' || idx || '_VER_NR_' || i);
          if( v_cncpt_id is not null) then
    --   raise_application_error(-20000, 'Test'  || i || v_cncpt_id);
           for cur in (select item_nm, item_long_nm, item_desc from admin_item where item_id = v_cncpt_id and ver_nr = v_cncpt_ver_nr) loop
            row := t_row();
            ihook.setColumnValue(row,'ITEM_ID', v_id);
            ihook.setColumnValue(row,'VER_NR', 1);
            ihook.setColumnValue(row,'CNCPT_ITEM_ID',v_cncpt_id);
            ihook.setColumnValue(row,'CNCPT_VER_NR', v_cncpt_ver_nr);
            ihook.setColumnValue(row,'NCI_ORD', j);
            v_temp := v_temp || i || ':' ||  v_cncpt_id;
            rows.extend;
            rows(rows.last) := row;
            v_nm := trim(cur.item_nm) || ' ' || v_nm ;
            v_long_nm := cur.item_long_nm || ':' || v_long_nm   ;
            v_def := substr( cur.item_desc || '_' || v_def,1,4000);
            j := j+ 1;
        end loop;
        end if;
        end loop;


          v_cncpt_id := ihook.getColumnValue(rowform, 'CNCPT_' || idx  ||'_ITEM_ID_1' );
             v_cncpt_ver_nr :=  ihook.getColumnValue(rowform, 'CNCPT_' || idx || '_VER_NR_1' );
           for cur in (select item_nm, item_long_nm, item_desc from admin_item where item_id = v_cncpt_id and ver_nr = v_cncpt_ver_nr) loop
            row := t_row();
            ihook.setColumnValue(row,'ITEM_ID', v_id);
            ihook.setColumnValue(row,'VER_NR', 1);
            ihook.setColumnValue(row,'CNCPT_ITEM_ID',v_cncpt_id);
            ihook.setColumnValue(row,'CNCPT_VER_NR', v_cncpt_ver_nr);
            ihook.setColumnValue(row,'NCI_ORD', 0);
            ihook.setColumnValue(row,'NCI_PRMRY_IND', 1);
            v_temp := v_temp || i || ':' ||  v_cncpt_id;
            rows.extend;
            rows(rows.last) := row;
            v_nm :=  trim(v_nm) || ' ' ||  trim(cur.item_nm);
            v_long_nm := v_long_nm  || cur.item_long_nm    ;
            v_def := substr( v_def  || cur.item_desc,1,4000 ) ;
        end loop;


       action := t_actionrowset(rows, 'Items under Concept', 2,6,'insert');
        actions.extend;
        actions(actions.last) := action;

        rows := t_rows();
        row := t_row();
        v_long_nm := substr(v_long_nm,1, length(v_long_nm)-1);
        v_nm := substr(trim(v_nm),1, c_nm_len);
        -- if lenght of short name is greater than 30, then use IDv1.00
        if (length(v_long_nm) > 30) then
            v_long_nm := v_id || c_ver_suffix;
        end if;

    -- raise_application_error (-20000, v_nm || '$$$' || v_long_nm);
        ihook.setColumnValue(row,'ITEM_ID', v_id);
        ihook.setColumnValue(row,'VER_NR', 1);
        ihook.setColumnValue(row,'CURRNT_VER_IND', 1);
        ihook.setColumnValue(row,'ADMIN_ITEM_TYP_ID', v_item_typ_id);
        ihook.setColumnValue(row,'ADMIN_STUS_ID',66 );
               ihook.setColumnValue(row,'REGSTR_STUS_ID',9 );

        ihook.setColumnValue(row,'ITEM_LONG_NM', v_long_nm);
        ihook.setColumnValue(row,'ITEM_DESC', substr(v_def, 1, length(v_def)-1));
        ihook.setColumnValue(row,'ITEM_NM', v_nm);
        ihook.setColumnValue(row,'CNTXT_ITEM_ID', 20000000024);
        ihook.setColumnValue(row,'CNTXT_VER_NR', 1);
        ihook.setColumnValue(row,'CNCPT_CONCAT', v_long_nm_suf);
        ihook.setColumnValue(row,'CNCPT_CONCAT_DEF', substr(v_def, 1, length(v_def)-1));
        ihook.setColumnValue(row,'CNCPT_CONCAT_NM', v_nm);

        rows.extend;
        rows(rows.last) := row;
    -- raise_application_error(-20000, 'HEre ' || v_nm || v_long_nm || v_def);
        ihook.setColumnValue(rowform,'ITEM_' || idx || '_LONG_NM', v_long_nm);
        ihook.setColumnValue(rowform,'ITEM_' || idx || '_DEF', substr(v_def, 1, length(v_def)-1));
        ihook.setColumnValue(rowform,'ITEM_' || idx || '_NM', v_nm);
        ihook.setColumnValue(rowform, 'ITEM_' || idx || '_ID', v_id);
         ihook.setColumnValue(rowform, 'ITEM_' || idx || '_VER_NR', 1);

        action := t_actionrowset(rows, 'Administered Item (No Sequence)', 2,1,'insert');
        actions.extend;
        actions(actions.last) := action;


        action := t_actionrowset(rows, 'NCI AI Extension (Hook)', 2,3,'insert');
        actions.extend;
        actions(actions.last) := action;

       case v_item_typ_id
       when 5 then v_obj_nm := 'Object Class';
       when 6 then v_obj_nm := 'Property';
	   when 7 then v_obj_nm := 'Representation Class';

        end case;
        action := t_actionrowset(rows, v_obj_nm, 2,2,'insert');
        actions.extend;
        actions(actions.last) := action;
end if;

end;

END;
/
