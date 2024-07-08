@echo off
@mode con cp select=1251 > nul

set NLS_LANG=RUSSIAN_AMERICA.CL8MSWIN1251
:: path for tnsnames.ora
set TNS_ADMIN=C:\Users\%username%\Desktop\SPOOL\tns_admin
:: alias for tns_name
set tns_connect_to_ora=ics
set login_ora=ICS
set "pass_ora=0etlOnnE("
set lv_schema_name=ICS
::FOR PGDB
rem set "PGPASSWORD=PG21*0^^n^^8G8"
set PGPASSFILE=C:\Users\%username%\Desktop\SPOOL\CONF\pgpass.conf
set pg_db_name=ics
set pg_user_name=postgres
set pg_host=T1-ICS-DB01
set pg_port=5432
set "pg_sql_path=C:\Users\%username%\AppData\Local\Programs\pgAdmin 4\v6\runtime\psql.exe"
