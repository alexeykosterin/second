@mode con cp select=1251 > nul
@echo off

call "init_config.bat"

set logname=%date:~0,2%%date:~3,2%%date:~6,8%_%time:~0,2%%time:~3,2%%time:~6,2%
set logname=%logname: =%

"%pg_sql_path%" -h %pg_host% -d %pg_db_name% -U %pg_user_name% -p %pg_port% -f "C:\Users\%username%\Desktop\SPOOL_ICS\addTable.txt" >> C:\Users\%username%\Desktop\SPOOL\LOG\update_pg_%logname%.txt 2>>&1

for %%i in ("start.bat", "insertInPg.bat", "last_update.bat") do call %%i



:: SQLPLUS "ics/0etlOnnE(@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=T2-ICS-DB01.sgi.rus.socgen)(PORT=1562))(CONNECT_DATA=(SERVICE_NAME=iia)))" @def.sql

