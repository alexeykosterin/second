@mode con cp select=1251
@echo off

if defined tns_connect_to_ora (echo tns_connect_to_ora defined) else (set tns_connect_to_ora=^(DESCRIPTION=^(ADDRESS=^(PROTOCOL=TCP^)^(HOST=T2-ICS-DB01.sgi.rus.socgen^)^(PORT=1562^)^)^(CONNECT_DATA=^(SERVICE_NAME=iia^)^)^))
if defined login_ora (echo login_ora defined) else (set login_ora=ics)
if defined pass_ora (echo pass_ora defined) else (set "pass_ora=0etlOnnE(")
if defined table_name (echo table_name defined) else (set table_name=STORED_DOCUMENT)
if defined table_id (echo table_id defined) else (set table_id=identifier)
if defined hex_field (echo hex_field defined) else (set hex_field=document)

if exist C:\Users\%username%\Desktop\SPOOL_ICS\TMP\%table_name% goto endif
md C:\Users\%username%\Desktop\SPOOL_ICS\TMP\%table_name%
:endif

echo prompt Start the unloading process... > TMP\def.sql
echo set colsep '`' >> TMP\def.sql
echo set echo off >> TMP\def.sql
echo set feedback off >> TMP\def.sql
echo set pagesize 0 >> TMP\def.sql
echo set sqlprompt '' >> TMP\def.sql
echo set trimspool on >> TMP\def.sql
echo set termout off >> TMP\def.sql
echo set headsep off >> TMP\def.sql
echo set serveroutput on >> TMP\def.sql
echo set linesize 32767 >> TMP\def.sql
echo set long 20000000 >> TMP\def.sql
echo set longchunksize 200000000 >> TMP\def.sql
echo set pages 0 >> TMP\def.sql
echo set wrap off >> TMP\def.sql
echo alter session set nls_date_format="dd.mm.yyyy hh24:mi:ss"; >> TMP\def.sql
echo alter session set nls_timestamp_format="dd.mm.yyyy hh24:mi:ss"; >> TMP\def.sql

echo SPOOL C:\Users\%username%\Desktop\SPOOL_ICS\TMP\%table_name%\%1.txt; >> TMP\def.sql
echo DECLARE >> TMP\def.sql
echo l_off pls_integer := 1; >> TMP\def.sql
echo l_length_document pls_integer; >> TMP\def.sql
echo lv_length_document pls_integer; >> TMP\def.sql
echo BEGIN >> TMP\def.sql
echo dbms_output.enable(buffer_size =^> NULL); >> TMP\def.sql
echo 	FOR rec IN (select %table_id%, %hex_field% from %schema_name%.%table_name% WHERE %table_id% = %1) LOOP >> TMP\def.sql
echo 		l_length_document := LENGTH(rec.%hex_field%)-2000;  >> TMP\def.sql
echo 		lv_length_document := LENGTH(rec.%hex_field%);  >> TMP\def.sql
echo 		dbms_output.put_line('insert into ics.interim_table (table_name, identifier, hex_field, length_n, md5_sum_first, md5_sum_last) select ''%table_name%'','^|^|rec.%table_id%^|^|', decode('''); >> TMP\def.sql
echo 	while true loop	>> TMP\def.sql
echo 	EXIT WHEN l_off ^> dbms_lob.getlength(rec.%hex_field%); >> TMP\def.sql
echo 			dbms_output.put_line(dbms_lob.substr(rec.%hex_field%, 1000, l_off)); >> TMP\def.sql
echo 			l_off := l_off + 1000; >> TMP\def.sql
echo 	END LOOP; >> TMP\def.sql
echo 	l_off := 1; >> TMP\def.sql
echo 		dbms_output.put_line(''',''hex''),'^|^|LENGTH(rec.%hex_field%)); >> TMP\def.sql
echo 		dbms_output.put_line(','''^|^|dbms_obfuscation_toolkit.md5(INPUT =^> DBMS_LOB.SUBSTR(rec.%hex_field%, 2000))^|^|''''); >> TMP\def.sql
echo IF lv_length_document ^> 2001 THEN >> TMP\def.sql
echo		dbms_output.put_line(','''^|^|dbms_obfuscation_toolkit.md5(INPUT =^> DBMS_LOB.SUBSTR(rec.%hex_field%, 2001, l_length_document))^|^|'''');  >> TMP\def.sql
echo ELSE >> TMP\def.sql
echo		dbms_output.put_line(','''^|^|dbms_obfuscation_toolkit.md5(INPUT =^> rec.%hex_field%)^|^|'''');  >> TMP\def.sql
echo END IF; >> TMP\def.sql
echo 	END LOOP; >> TMP\def.sql
echo END; >> TMP\def.sql

echo / >> TMP\def.sql
echo spool off; >> TMP\def.sql
echo prompt Done >> TMP\def.sql
echo exit; >> TMP\def.sql


SQLPLUS "%login_ora%/%pass_ora%@%tns_connect_to_ora%" @TMP\def.sql