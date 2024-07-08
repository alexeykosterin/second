@echo off
setlocal EnableDelayedExpansion

rem TruncateFileDoc.bat: Create TruncateFile.exe auxiliary program and describe it
rem Antonio Perez Ayala

if not exist TruncateFile.exe (
   echo Extracting TruncateFile.exe
   call :ExtractBinaryFile TruncateFile.exe
   echo TruncateFile.exe file created
   echo/
)

echo Truncate the file of the given handle at the current file pointer position.
echo/
echo    TruncateFile.exe handle
echo/
echo The result is reported via ERRORLEVEL this way:
echo/
echo -2      No handle given or bad handle number.
echo -1      The handle number is not connected to any file.
echo  0      File truncated correctly.
echo  1      Error while trying to truncate the file.
echo/
echo To see an example, review the code of this program (%~NX0);
echo the following is the output example.
echo/
echo Original contents of the data file:
echo ===================================
type TruncateFile.txt
echo ===================================

< TruncateFile.txt (
   rem Locate the last permanent line in the file (from STDIN)
   call :LocateLastLine
   rem Get current FilePointer position
   FilePointer 0 0 /C
   set filePointer=!errorlevel!
)

(
   rem Set FilePointer position after last permanent line (to STDOUT)
   FilePointer 1 !filePointer!
   rem Truncate the file at this point
   TruncateFile.exe 1
) >> TruncateFile.txt


rem Add new lines at end of truncated data
echo This is new data added after the last permanent line in the file >> TruncateFile.txt

echo/
echo/
echo New contents of the data file:
echo ===================================
type TruncateFile.txt
echo ===================================

goto :EOF


:LocateLastLine
set /P line=
if "%line:~0,6%" neq "EOPD: " goto LocateLastLine
exit /B


rem Extract Binary File from hexadecimal digits placed in a "resource" in this .bat file

:ExtractBinaryFile filename.ext[.cab]
setlocal EnableDelayedExpansion
set "start="
set "end="
for /F "tokens=1,3 delims=:=>" %%a in ('findstr /N /B "</*resource" "%~F0"') do (
   if not defined start (
      if "%%~b" equ "%~1" set start=%%a
   ) else if not defined end set end=%%a
)
(for /F "skip=%start% tokens=1* delims=:" %%a in ('findstr /N "^" "%~F0"') do (
   if "%%a" == "%end%" goto decodeHexFile
   echo %%b
)) > "%~1.hex"
:decodeHexFile

rem Modified code based on :genchr subroutine
type nul > t.tmp
(for /F "usebackq" %%a in ("%~1.hex") do (
   set input=%%a
   set i=0
   for /L %%I in (0,2,120) do for %%i in (!i!) do if "!input:~%%i,1!" neq "" (
      set hex=!input:~%%i,2!
      set /A i+=2
      if "!hex:~0,1!" neq "[" (
         set /A chr=0x!hex!
         if not exist !chr!.chr call :genchr !chr!
         type !chr!.chr
      ) else (
         for /L %%J in (1,1,5) do for %%i in (!i!) do if "!input:~%%i,1!" neq "]" (
            set "hex=!hex!!input:~%%i,1!"
            set /A i+=1
         )
         if not exist 0.chr call :genchr 0
         for /L %%J in (1,1,!hex:~1!) do type 0.chr
         set /A i+=1
      )
   )
)) > "%~1"
del *.chr
del t.tmp temp.tmp
del "%~1.hex"

rem Expand created file if extension is .cab
set "filename=%~1"
if /I "%filename:~-4%" equ ".cab" (
   expand "%filename%" "%filename:~0,-4%" > NUL
   del "%filename%"
)

exit /B


:genchr
REM This code creates one single byte. Parameter: int
REM Teamwork of carlos, penpen, aGerman, dbenham
REM Tested under Win2000, XP, Win7, Win8
set "options=/d compress=off /d reserveperdatablocksize=26"
if %~1 neq 26 (
   makecab %options% /d reserveperfoldersize=%~1 t.tmp %~1.chr > nul
   type %~1.chr | ( (for /l %%N in (1,1,38) do pause)>nul & findstr "^" > temp.tmp )
   >nul copy /y temp.tmp /a %~1.chr /b
) else (
   copy /y nul + nul /a 26.chr /a >nul
)
exit /B


<resource id="TruncateFile.exe">
4d5a900003[3]04[3]ffff[2]b8[7]40[35]b0[3]0e1fba0e00b409cd21b8014ccd21546869732070726f6772616d2063616e6e6f74206265207275
6e20696e20444f53206d6f64652e0d0d0a24[7]551e49c1117f2792117f2792117f27929f603492167f2792ed5f3592137f279252696368117f2792
[8]5045[2]4c01020094146054[8]e0000f010b01050c0002[3]02[7]10[3]10[3]20[4]40[2]10[3]02[2]04[7]04[8]30[3]02[6]03[5]10[2]10
[4]10[2]10[6]10[11]1420[2]28[84]20[2]14[27]2e74657874[3]96[4]10[3]02[3]02[14]20[2]602e7264617461[2]9e[4]20[3]02[3]04[14]
40[2]40[8]e84b[3]e86a[3]33c048488a1e80fb30722980fb39772480e30fb8f6ffffff2ac350e85a[3]0bc07c1050e856[3]0bc0b8[4]75014050
e83a[3]cccccccccccccccccccccccce83b[3]8bf08a06463c2275098a06463c2275f9eb0c8a06463c20740484c075f54ec38a06463c2074f94ec3cc
ff250c204000ff2500204000ff2504204000ff25082040[363]5e20[2]6e20[2]7e20[2]5020[6]3c20[10]9020[3]20[22]5e20[2]6e20[2]7e20[2]
5020[6]9b004578697450726f63657373006a0147657453746448616e646c65[2]7c02536574456e644f6646696c65[2]e600476574436f6d6d616e64
4c696e6541006b65726e656c33322e646c6c[356]
</resource>