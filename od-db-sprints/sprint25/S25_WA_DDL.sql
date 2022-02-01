CREATE OR REPLACE EDITIONABLE TRIGGER OD_TR_PV_VM_IMP BEFORE INSERT  on NCI_STG_PV_VM_IMPORT for each row
     BEGIN    IF (:NEW.STG_AI_ID = -1  or :NEW.STG_AI_ID is null)  THEN select od_seq_IMPORT.nextval
 into :new.STG_AI_ID  from  dual ;   END IF;
 END;
/

CREATE OR REPLACE EDITIONABLE TRIGGER TR_PV_VM_IMPORT_AUD_TS
  BEFORE UPDATE
  on NCI_STG_PV_VM_IMPORT
  for each row
BEGIN
  :new.LST_UPD_DT := SYSDATE;
END ;
/

