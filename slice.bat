@echo off
setlocal EnableDelayedExpansion

set "input=vid-template.mp4"
set count=0

REM Loop through each line in timestamps.txt
for /f "tokens=1,2 delims=," %%a in (timestamps.txt) do call :process "%%a" "%%b"
goto :eof

:process
set "start=%~1"
set "end=%~2"

REM Convert timestamps to seconds using PowerShell
for /f %%s in ('powershell -noprofile -command "(New-TimeSpan -Start '00:00:00' -End '%~1').TotalSeconds"') do set "start_sec=%%s"
for /f %%e in ('powershell -noprofile -command "(New-TimeSpan -Start '00:00:00' -End '%~2').TotalSeconds"') do set "end_sec=%%e"

set /a duration=%end_sec% - %start_sec%

echo Cutting clip !count!: %start% to %end% (Duration: !duration!s)

ffmpeg -ss %start% -i "%input%" -t !duration! -c copy "clip_!count!.mp4"

set /a count+=1
goto :eof

