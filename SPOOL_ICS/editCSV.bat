@mode con cp select=1251
@echo off

for /f "delims=" %%j in ('dir C:\Users\%username%\Desktop\SPOOL_ICS\TMP\*.csv /b/a-d') do (
<C:\Users\%username%\Desktop\SPOOL_ICS\TMP\%%j>C:\Users\%username%\Desktop\SPOOL_ICS\CSV\%%j (for /f %%i in ('more') do @<nul set /p="%%i")
echo. >>C:\Users\%username%\Desktop\SPOOL_ICS\CSV\%%j
)