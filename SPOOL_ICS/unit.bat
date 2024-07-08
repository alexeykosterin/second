@echo off
@mode con cp select=1251 > nul


setlocal EnableDelayedExpansion
set /A "interim=0"
set /A "nulPoint=0"
set /A "count=0"

if exist C:\Users\%username%\Desktop\SPOOL_ICS\TMP\UNIT goto endif1
md C:\Users\%username%\Desktop\SPOOL_ICS\TMP\UNIT
:endif1

if exist C:\Users\%username%\Desktop\SPOOL_ICS\TMP\UNIT\%schema_name% goto endif2
md C:\Users\%username%\Desktop\SPOOL_ICS\TMP\UNIT\%schema_name%
:endif2

if exist C:\Users\%username%\Desktop\SPOOL_ICS\TMP\UNIT\%schema_name%\%table_name% goto endif3
md C:\Users\%username%\Desktop\SPOOL_ICS\TMP\UNIT\%schema_name%\%table_name%
:endif3

for /f "delims=" %%j in ('dir C:\Users\%username%\Desktop\SPOOL_ICS\TMP\%table_name%\*.txt /b/a-d') do (
set /A "count=!count!+1"
findstr "^" C:\Users\%username%\Desktop\SPOOL_ICS\TMP\%table_name%\%%j>>C:\Users\%username%\Desktop\SPOOL_ICS\TMP\UNIT\%schema_name%\%table_name%\%table_name%_!interim!.txt 2>&1 && echo ; >>C:\Users\%username%\Desktop\SPOOL_ICS\TMP\UNIT\%schema_name%\%table_name%\%table_name%_!interim!.txt 2>&1 || set /A "nulPoint=!nulPoint!+1"
for %%a in (C:\Users\%username%\Desktop\SPOOL_ICS\TMP\UNIT\%schema_name%\%table_name%\%table_name%_!interim!.txt) do (
if %%~za GTR 550000000 (set /A "count=0
set /A "interim=!interim!+1"
)
)
if !count! GTR 300 (set /A "count=0
set /A "interim=!interim!+1"
)
del C:\Users\%username%\Desktop\SPOOL_ICS\TMP\%table_name%\%%j
)
set /A "interim=0"
set /A "count=0"

rem findstr "insert" "C:\Users\%username%\Desktop\SPOOL_ICS\TMP\STORED_DOCUMENT\*.txt" | find /c /v ""

