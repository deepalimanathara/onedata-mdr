alter table quest_attributes_ext drop constraint QAT_QC_FK;
drop index QAT_QC_VV_FK;
alter table quest_attributes_ext drop constraint QAT_QC_FK2;
alter table quest_vv_ext drop constraint QVT_QVT_FK;
