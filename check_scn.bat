@echo off
@mode con cp select=1251 > nul

copy /v C:\Users\%username%\Desktop\SPOOL\APPEND\check_scn_new.txt C:\Users\%username%\Desktop\SPOOL\APPEND\check_scn_prev.txt
for %%i in ("findBigTables.bat") do call %%i

set /p=<nul > C:\Users\%username%\Desktop\SPOOL\APPEND\tables_scn.txt

for /F "delims=" %%i in (C:\Users\%username%\Desktop\SPOOL\APPEND\check_scn_new.txt) do (
for /F "delims=" %%a in ('type C:\Users\%username%\Desktop\SPOOL\APPEND\check_scn_prev.txt ^| findstr /x "%%i" ^| find /c /v ""') do (
if %%a==0 (echo %%i >> C:\Users\%username%\Desktop\SPOOL\APPEND\tables_scn.txt)
))

