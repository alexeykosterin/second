@mode con cp select=1251 > nul

call "init_config.bat"

set "delimeter1="
set "delimeter2="

echo prompt Start the unloading process... > TMP\%2.sql
echo set colsep '' >> TMP\%2.sql
echo set echo off >> TMP\%2.sql
echo set feedback off >> TMP\%2.sql
echo set linesize 15000 >> TMP\%2.sql
echo set pagesize 0 >> TMP\%2.sql
echo set sqlprompt '' >> TMP\%2.sql
echo set trimspool on >> TMP\%2.sql
echo set headsep off >> TMP\%2.sql
echo set long 200000 >> TMP\%2.sql
echo set longchunksize 200000 >> TMP\%2.sql
echo set pages 0 >> TMP\%2.sql
echo set termout off  >> TMP\%2.sql
echo set wrap off  >> TMP\%2.sql
echo set serveroutput on >> TMP\%2.sql

echo alter session set nls_date_format="dd.mm.yyyy hh24:mi:ss"; >> TMP\%2.sql
echo alter session set nls_timestamp_format="dd.mm.yyyy hh24:mi:ss"; >> TMP\%2.sql
:: local C:\

echo SPOOL C:\Users\%username%\Desktop\SPOOL\STORED\TMP\%2.txt; >> TMP\%2.sql
echo BEGIN >> TMP\%2.sql
echo 	FOR rec IN (WITH table_1 AS ( >> TMP\%2.sql
echo SELECT owner, name, line,  >> TMP\%2.sql
echo regexp_replace(regexp_replace(regexp_replace(text,'(  *)',' '),chr(10),' '),chr(13),' ') AS text >> TMP\%2.sql
echo FROM all_source WHERE owner = '%1' AND name = '%2' >> TMP\%2.sql
echo ORDER BY line >> TMP\%2.sql
echo ) SELECT owner, name, line, >> TMP\%2.sql
echo regexp_replace( >> TMP\%2.sql
echo regexp_replace( >> TMP\%2.sql
echo regexp_replace( >> TMP\%2.sql
::echo regexp_replace( >> TMP\%2.sql
::echo regexp_replace( >> TMP\%2.sql
::echo regexp_replace( >> TMP\%2.sql
::echo regexp_replace( >> TMP\%2.sql
echo text,'(PROCEDURE^|FUNCTION^|TRIGGER^|procedure^|function^|trigger)(.^*)','CREATE OR REPLACE '^|^|text, 1,0,'c') >> TMP\%2.sql
echo ,' VARCHAR2', ' VARCHAR',1,0,'i'),' NUMBER', ' NUMERIC',1,0,'i') >> TMP\%2.sql
::echo ,'(FUNCTION)','CREATE OR REPLACE FUNCTION ', 1,0,'c') >> TMP\%2.sql
::echo ,'(TRIGGER)','CREATE OR REPLACE TRIGGER ', 1,0,'c') >> TMP\%2.sql
::echo ,'(:NEW)','NEW', 1,0,'i') >> TMP\%2.sql
::echo ,'(:OLD)','OLD', 1,0,'i') >> TMP\%2.sql
echo AS text FROM table_1 >> TMP\%2.sql
echo ) loop >> TMP\%2.sql
echo dbms_output.put_line( >> TMP\%2.sql
::echo select %var% from %1.%2 %~3 %nvar% %~4 %~5; >> TMP\%2.sql
echo rec.text >> TMP\%2.sql
echo ); END LOOP; >> TMP\%2.sql
echo dbms_output.put_line('$BODY$;'); >> TMP\%2.sql
echo END; >> TMP\%2.sql
echo / >> TMP\%2.sql

echo spool off; >> TMP\%2.sql
echo prompt Done >> TMP\%2.sql
echo exit; >> TMP\%2.sql

SQLPLUS "%login_ora%/%pass_ora%@%tns_connect_to_ora%" @TMP\%2.sql