@echo off
setlocal enabledelayedexpansion
chcp 65001

:: 設定 ffmpeg 路徑
set ffmpeg_path="%~dp0ffmpeg-6.1.1-full_build\bin\ffmpeg.exe"

:: 資料夾檢核
if not exist "%~dp0影片合檔Input\" (
    echo 錯誤：找不到資料夾 "影片合檔Input"
    pause
    exit
)
if not exist "%~dp0影片合檔Output\" (
    echo 錯誤：找不到資料夾 "影片合檔Output"
    pause
    exit
)

:: 請用戶確認合併檔按順序
echo 即將合併的文件：
(for /f "tokens=*" %%a in ('dir /b /on "%~dp0影片合檔Input\*.m2ts" ^| findstr /v /i /c:output.m2ts') do (
     echo %%a
))

set /p choice=是否繼續執行？ (Y/N):
if /i "%choice%"=="N" (
     echo 使用者選擇中斷執行。
     pause
     exit
)

:: 獲取當前日期和時間，格式為 YYYYMMDD-HHMMSS
for /f "tokens=2 delims==" %%A in ('"wmic os get localdatetime /value"') do set datetime=%%A
set timestamp=%datetime:~0,8%-%datetime:~8,6%

:: 輸出目錄
set output_file="%~dp0影片合檔Output\合檔%timestamp%.m2ts"


:: 合併影片
(for /f "tokens=*" %%a in ('dir /b /on "%~dp0影片合檔Input\*.m2ts" ^| findstr /v /i /c:output.m2ts') do (
     echo file '%~dp0影片合檔Input\%%a'
)) > "%~dp0m2ts_files.txt"
%ffmpeg_path% -safe 0 -ss 0 -f concat -i "%~dp0m2ts_files.txt" -fflags +genpts -vf yadif -c:v h264_nvenc -bf 0 -rc:v vbr -g 15 -b:v 13M -maxrate:v 13M -bufsize:v 13M  -c:a ac3 -b:a 256k -ac 2 -ar 48000 %output_file%

:: 清理暫存檔案
rem del /q "%~dp0m2ts_files.txt"

pause