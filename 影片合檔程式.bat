@echo off
setlocal enabledelayedexpansion
chcp 65001

@echo off
set ffmpeg_path="%~dp0ffmpeg-6.1.1-full_build\bin\ffmpeg.exe"

echo 即將合併的文件：
(for /f "tokens=*" %%a in ('dir /b /on *.m2ts ^| findstr /v /i /c:output.m2ts') do (
     echo %%a
))

set /p choice=是否繼續執行？ (Y/N):
if /i "%choice%"=="N" (
     echo 使用者選擇中斷執行。
     pause
     exit
)

(for /f "tokens=*" %%a in ('dir /b /on *.m2ts ^| findstr /v /i /c:output.m2ts') do (
     echo file '%%a'
)) > m2ts_files.txt

%ffmpeg_path% -safe 0 -ss 0 -f concat -i "%~dp0m2ts_files.txt" -fflags +genpts -vf yadif -c:v h264_nvenc -bf 0 -rc:v vbr -g 15 -b:v 8M -maxrate:v 8M -bufsize:v 8M  -c:a ac3 -b:a 256k -ac 2 -ar 48000 output.m2ts

rem del /q m2ts_files.txt

pause