@echo off
@mode con cp select=1251 > nul

call "init_config.bat"

set path_to_data="C:\Users\%username%\Desktop\SPOOL_ICS\TMP\UNIT\%schema_name%\%table_name%"

set logname=%date:~0,2%%date:~3,2%%date:~6,8%_%time:~0,2%%time:~3,2%%time:~6,2%
set logname=%logname: =%

for /f "delims=" %%j in ('dir %path_to_data%\*.txt /b/a-d') do (
echo INSERT: %%j >> C:\Users\%username%\Desktop\SPOOL_ICS\LOG\insert_%logname%.txt
"%pg_sql_path%" -h %pg_host% -d %pg_db_name% -U %pg_user_name% -p %pg_port% -f "%path_to_data%\%%j" >> C:\Users\%username%\Desktop\SPOOL_ICS\LOG\insert_%logname%.txt 2>>&1
)

