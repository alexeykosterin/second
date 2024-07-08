@echo off
@mode con cp select=1251

::for PGDB
rem if defined PGPASSWORD (echo PGPASSWORD defined) else (set PGPASSWORD=ns6oZHWgA8qqPB74EQ8F)

if defined PGPASSFILE (echo PGPASSFILE defined) else (set PGPASSFILE=C:\Users\%username%\Desktop\SPOOL\CONF\pgpass.conf)
if defined pg_db_name (echo pg_db_name defined) else (set pg_db_name=postgres)
if defined pg_user_name (echo pg_user_name defined) else (set pg_user_name=postgres)
if defined pg_host (echo pg_host defined) else (set pg_host=localhost)
if defined pg_port (echo pg_port defined) else (set pg_port=5432)
if defined pg_sql_path (echo pg_sql_path defined) else (set "pg_sql_path=C:\Users\%username%\AppData\Local\Programs\pgAdmin 4\v6\runtime\psql.exe")

set logname=%date:~0,2%%date:~3,2%%date:~6,8%_%time:~0,2%%time:~3,2%%time:~6,2%
set logname=%logname: =%

:: CONSTRAINT ON EXCEPTION
for /f "delims=" %%i in ('dir C:\Users\%username%\Desktop\SPOOL\EXCEPTION_BEFORE_LOAD_CSV_IN_PG\LAST_UPDATE.txt /b/a-d') do (
"%pg_sql_path%" -h %pg_host% -d %pg_db_name% -U %pg_user_name% -p %pg_port% -f "C:\Users\%username%\Desktop\SPOOL\EXCEPTION_BEFORE_LOAD_CSV_IN_PG\%%i"
)