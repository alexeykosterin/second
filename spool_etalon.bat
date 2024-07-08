@mode con cp select=1251
cd C:\Users\%username%\Desktop\SPOOL

echo prompt Start the unloading process... > idsoratest.sql
echo set colsep ';' >> idsoratest.sql
echo set echo off >> idsoratest.sql
echo set feedback off >> idsoratest.sql
echo set linesize 1000 >> idsoratest.sql
echo set pagesize 0 >> idsoratest.sql
echo set sqlprompt '' >> idsoratest.sql
echo set trimspool on >> idsoratest.sql
echo set headsep off >> idsoratest.sql
echo set serveroutput on >> idsoratest.sql

echo SPOOL C:\Users\%username%\Desktop\SPOOL\REP\temp.txt; >> idsoratest.sql
echo begin >> idsoratest.sql 
echo dbms_output.put_line(1); >> idsoratest.sql 
echo end; >> idsoratest.sql
echo / >> idsoratest.sql
echo spool off; >> idsoratest.sql
echo prompt Done >> idsoratest.sql
echo exit; >> idsoratest.sql


SQLPLUS "akosterin/Test123!@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=rswdapp55)(PORT=1561))(CONNECT_DATA=(SERVICE_NAME=idsoratest)))" @idsoratest.sql