@echo off > nul
@mode con cp select=1251 > nul

if "%~2" neq "" goto begin
echo Split a large text file in parts of a given number of lines
echo/
echo SplitFile filename.ext numberOfLines
echo/
echo After the file was splitted, it can be recovered with this command:
echo     COPY filename_*.ext filename.ext /B
echo/
:rightNumber
echo The number of lines must have non-zero digits followed by zero digits,
echo like: 5000, 11000, 20000, etc.
echo/
echo/
echo ATTENTION!  This program is *destructive*: it will remove the original file!
echo ==========  You should copy the file before split it with this program.
goto :EOF

:begin
setlocal EnableDelayedExpansion
set pathToCSV=\\t2-ics-db01\CSV\SPLIT_FILE\
set oldpathToCSV=C:\CSV\

if exist C:\CSV\SPLIT_FILE goto endif
:: for tmp csv
md C:\CSV\SPLIT_FILE
:endif


if not exist %1 echo File not found & goto :EOF

rem Get from numOfLines: modBlock=digits != 0 at left, modLen=number of digits == 0 at right
set /A numOfLines=%2, modLen=0, continue=1
set "modBlock="
for /L %%i in (0,1,9) do if defined continue (
   set "digit=!numOfLines:~%%i,1!"
   if "!digit!" equ "" (
      set "continue="
   ) else if "!digit!" neq "0" (
      if !modLen! neq 0 goto badNumber
      set "modBlock=!modBlock!!digit!"
   ) else (
      set /A modLen+=1
   )
)
if "%modBlock%" equ "" goto badNumber
if %modLen% gtr 0 goto getModSize
:badNumber
echo Wrong number of lines
goto rightNumber
:getModSize
set "modSize=!numOfLines:~-%modLen%!"

rem Get the offsets of the lines placed at start of each part
set "start=%time%"
set /P "=Obtaining limits of all parts..." < NUL
set "lastOffset=1"
for /F "tokens=1,2 delims=:" %%a in ('findstr /N /O "^" %1 ^| findstr "%modSize%:"') do (
   set "lineNum=%%a"
   if "!lineNum:~-%modLen%!" equ "%modSize%" (
      set /A "mod=!lineNum:~0,-%modLen%! %% %modBlock%"
	  if !mod! equ 0 (
         set /A lastOffset+=1
         set "offset[!lastOffset!]=%%b"
      )
   )
)
echo   done.
set "split=%time%"

< %1 (

   rem Extract the parts in last-to-first order
   for /L %%i in (%lastOffset%,-1,2) do (

      rem Move Stdin file pointer to the start of this part
      FilePointer 0 !offset[%%i]!

      rem Copy from this point up to EOF to its own part file
      set "part=00%%i"
      set /P "=Creating part %pathToCSV%%~N1_!part:~-3!%~X1..." < NUL > CON
      findstr "^" > "%pathToCSV%%~N1_!part:~-3!%~X1"
      echo   done.> CON

      rem Move Stdout file pointer to the start of this part
      FilePointer 1 !offset[%%i]!

      rem Truncate the file at this point: make it the new EOF
      TruncateFile 1

   )

) >> %1

rem Open a code-block to process the file via redirected Stdin and Stdout

set /P "=Creating part %pathToCSV%%~N1_001%~X1..." < NUL
echo %~N1_001%~X1
echo "%pathToCSV%%~N1_001%~X1"
echo %1 "%pathToCSV%%~N1_001%~X1"
ren %1 "%~N1_001%~X1"
move "%oldpathToCSV%%~N1_001%~X1" "%pathToCSV%%~N1_001%~X1"

echo   done.

echo/
echo Start process   at: %start%
echo Start splitting at: %split%
echo End   splitting at: %time%