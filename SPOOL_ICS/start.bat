@mode con cp select=1251
@echo off
if defined tns_connect_to_ora (echo tns_connect_to_ora defined) else (set tns_connect_to_ora=^(DESCRIPTION=^(ADDRESS=^(PROTOCOL=TCP^)^(HOST=T2-ICS-DB01.sgi.rus.socgen^)^(PORT=1562^)^)^(CONNECT_DATA=^(SERVICE_NAME=iia^)^)^))
if defined login_ora (echo login_ora defined) else (set login_ora=ics)
if defined pass_ora (echo pass_ora defined) else (set "pass_ora=0etlOnnE(")

echo prompt Start the unloading process... > getIdentifier.sql
echo set colsep '`' >> getIdentifier.sql
echo set echo off >> getIdentifier.sql
echo set feedback off >> getIdentifier.sql
echo set pagesize 0 >> getIdentifier.sql
echo set sqlprompt '' >> getIdentifier.sql
echo set trimspool on >> getIdentifier.sql
echo set termout off >> getIdentifier.sql
echo set headsep off >> getIdentifier.sql
echo set linesize 1000 >> getIdentifier.sql
echo set pages 0 >> getIdentifier.sql
echo set wrap off >> getIdentifier.sql
echo alter session set nls_date_format="dd.mm.yyyy hh24:mi:ss"; >> getIdentifier.sql
echo alter session set nls_timestamp_format="dd.mm.yyyy hh24:mi:ss"; >> getIdentifier.sql
echo SPOOL C:\Users\%username%\Desktop\SPOOL_ICS\identifierList.txt; >> getIdentifier.sql
echo select %table_id%^|^|'' from %schema_name%.%table_name% where %table_id% ^> 12854; >> getIdentifier.sql
echo spool off; >> getIdentifier.sql
echo prompt Done >> getIdentifier.sql
echo exit; >> getIdentifier.sql

SQLPLUS "%login_ora%/%pass_ora%@%tns_connect_to_ora%" @getIdentifier.sql

for /F "tokens=1 delims=" %%i in (C:\Users\%username%\Desktop\SPOOL_ICS\identifierList.txt) do (first_step.bat %%i)
