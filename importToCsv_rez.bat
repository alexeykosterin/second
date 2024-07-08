@mode con cp select=1251


echo prompt Start the unloading process... > TMP\importToCsv.sql
echo set colsep '`' >> TMP\importToCsv.sql
echo set echo off >> TMP\importToCsv.sql
echo set feedback off >> TMP\importToCsv.sql
echo set linesize 15000 >> TMP\importToCsv.sql
echo set pagesize 0 >> TMP\importToCsv.sql
echo set sqlprompt '' >> TMP\importToCsv.sql
echo set trimspool on >> TMP\importToCsv.sql
echo set headsep off >> TMP\importToCsv.sql

echo SPOOL C:\Users\%username%\Desktop\SPOOL\CSV\tmp_csv.txt; >> TMP\importToCsv.sql
::echo select LISTAGG(column_name, '^^^|^^^|''@''^^^|^^^|') WITHIN GROUP (order by column_id) as list from dba_tab_columns t where table_name = '%1' and owner = 'RUS_SERVICE' group by table_name; >> TMP\importToCsv.sql
echo select LISTAGG(CASE WHEN DATA_TYPE not in ('CLOB', 'VARCHAR2') THEN column_name ELSE 'regexp_replace(regexp_replace(regexp_replace('^|^|column_name^|^|',''(  *)'','' ''),chr(10),'' ''),chr(13),'' '')' END, '^^^|^^^|''`''^^^|^^^|') WITHIN GROUP (order by column_id) as list from dba_tab_columns t where table_name = '%1' and owner = 'RUS_SERVICE' group by table_name; >> TMP\importToCsv.sql

echo spool off; >> TMP\importToCsv.sql
echo prompt Done >> TMP\importToCsv.sql
echo exit; >> TMP\importToCsv.sql

SQLPLUS "akosterin/Test123!@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=rswdapp55)(PORT=1561))(CONNECT_DATA=(SERVICE_NAME=idsoratest)))" @TMP\importToCsv.sql


Set file=C:\Users\%username%\Desktop\SPOOL\CSV\tmp_csv.txt
For /F "usebackq tokens=* delims=" %%q In ("%file%") Do Set var=%%q
:: echo %var% > C:\Users\%username%\Desktop\SPOOL\CSV\%1.txt

echo prompt Start the unloading process... > TMP\%1.sql
echo set colsep '`' >> TMP\%1.sql
echo set echo off >> TMP\%1.sql
echo set feedback off >> TMP\%1.sql
echo set linesize 15000 >> TMP\%1.sql
echo set pagesize 0 >> TMP\%1.sql
echo set sqlprompt '' >> TMP\%1.sql
echo set trimspool on >> TMP\%1.sql
echo set headsep off >> TMP\%1.sql
echo set long 200000 >> TMP\%1.sql
echo set longchunksize 200000 >> TMP\%1.sql
echo set pages 0 >> TMP\%1.sql

echo alter session set nls_date_format="dd.mm.yyyy hh24:mi:ss"; >> TMP\%1.sql
echo alter session set nls_timestamp_format="dd.mm.yyyy hh24:mi:ss"; >> TMP\%1.sql
:: local C:\
echo SPOOL C:\CSV\%1.csv; >> TMP\%1.sql
echo select %var% from RUS_SERVICE.%1; >> TMP\%1.sql

echo spool off; >> TMP\%1.sql
echo prompt Done >> TMP\%1.sql
echo exit; >> TMP\%1.sql

SQLPLUS "akosterin/Test123!@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=rswdapp55)(PORT=1561))(CONNECT_DATA=(SERVICE_NAME=idsoratest)))" @TMP\%1.sql