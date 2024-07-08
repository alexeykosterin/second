@echo off
@mode con cp select=1251 > nul

setlocal EnableDelayedExpansion
set /A "interim=0"
set /A "nulPoint=0"
set /A "count=0"
for /f "delims=" %%j in ('dir C:\Users\%username%\Desktop\SPOOL_ICS\TMP\STORED_DOCUMENT\*.txt /b/a-d') do (
set /A "count=!count!+1"
if !count! LEQ 50 (
findstr "^" C:\Users\%username%\Desktop\SPOOL_ICS\TMP\STORED_DOCUMENT\%%j>>C:\Users\%username%\Desktop\SPOOL_ICS\TMP\TMP\STORED_DOCUMENT_!interim!.txt 2>&1 && echo ; >>C:\Users\%username%\Desktop\SPOOL_ICS\TMP\TMP\STORED_DOCUMENT_!interim!.txt 2>&1 || set /A "nulPoint=!nulPoint!+1"
) else (set /A "count=0
rem type C:\Users\%username%\Desktop\SPOOL_ICS\TMP\STORED_DOCUMENT\%%j>>C:\Users\%username%\Desktop\SPOOL_ICS\TMP\TMP\STORED_DOCUMENT_!interim!.txt 2>&1) else (set /A "count=0
set /A "interim=!interim!+1"
)
)
set /A "interim=0"
set /A "count=0"