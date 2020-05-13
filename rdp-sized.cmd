@echo off
setlocal

:: remove quotes
set _mypath=%~n1
call :dequote _mypath

if "%_mypath%"=="" (
    echo rdp-sized.cmd FILENAME
    echo.
    echo Runs mstsc.exe with FILENAME, with window geometry set according to the
    echo "--nnn" vertical height suffix in the filename.
    echo.
    pause
    goto :eof
)

:: check to see if "--" height exists
if "x%_mypath:--=%"=="x%_mypath%" (
    :: launch mstsc with no height and width switches
    start "" mstsc.exe %1
    goto :eof
)

:: change '--' to ','
set fname=%_mypath:--=,%
:: get last token
for %%x in (%fname%) do set height=%%x

:: set height
set width=1900
if "%height%"=="800" set width=1520
if "%height%"=="1000" set width=1900

:: launch mstsc
::echo Launching %1 with %width% x %height%
start "" mstsc.exe %1 /w:%width% /h:%height%

goto :eof

:dequote
for /f "delims=" %%A in ('echo %%%1%%') do set %1=%%~A
goto :eof
