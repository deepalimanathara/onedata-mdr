OPTIONS ( ERRORS= 10000, SKIP=1)
LOAD DATA
INFILE 'C:\meta\JIRA-DSRMWS-701\QA_VIEW_TEMP.csv' "str '\r'" 
BADFILE 'C:\meta\JIRA-DSRMWS-701\QA_VIEW_TEMP.bad'
DISCARDFILE 'C:\meta\JIRA-DSRMWS-701\QA_VIEW_TEMP' 
INTO TABLE "ONEDATA_WA"."QA_VIEW_TEMP"
INSERT
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS                 
   (owner , 
   view_name, 
   definition CHAR(4000) )
  