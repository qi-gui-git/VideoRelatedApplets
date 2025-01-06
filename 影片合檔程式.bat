@echo off
setlocal enabledelayedexpansion
chcp 65001

:: �]�w ffmpeg ���|
set ffmpeg_path="%~dp0ffmpeg-6.1.1-full_build\bin\ffmpeg.exe"

:: ��Ƨ��ˮ�
if not exist "%~dp0�v���X��Input\" (
    echo ���~�G�䤣���Ƨ� "�v���X��Input"
    pause
    exit
)
if not exist "%~dp0�v���X��Output\" (
    echo ���~�G�䤣���Ƨ� "�v���X��Output"
    pause
    exit
)

:: �ХΤ�T�{�X���ɫ�����
echo �Y�N�X�֪����G
(for /f "tokens=*" %%a in ('dir /b /on "%~dp0�v���X��Input\*.m2ts" ^| findstr /v /i /c:output.m2ts') do (
     echo %%a
))

set /p choice=�O�_�~�����H (Y/N):
if /i "%choice%"=="N" (
     echo �ϥΪ̿�ܤ��_����C
     pause
     exit
)

:: �����e����M�ɶ��A�榡�� YYYYMMDD-HHMMSS
for /f "tokens=2 delims==" %%A in ('"wmic os get localdatetime /value"') do set datetime=%%A
set timestamp=%datetime:~0,8%-%datetime:~8,6%

:: ��X�ؿ�
set output_file="%~dp0�v���X��Output\�X��%timestamp%.m2ts"


:: �X�ּv��
(for /f "tokens=*" %%a in ('dir /b /on "%~dp0�v���X��Input\*.m2ts" ^| findstr /v /i /c:output.m2ts') do (
     echo file '%~dp0�v���X��Input\%%a'
)) > "%~dp0m2ts_files.txt"
%ffmpeg_path% -safe 0 -ss 0 -f concat -i "%~dp0m2ts_files.txt" -fflags +genpts -vf yadif -c:v h264_nvenc -bf 0 -rc:v vbr -g 15 -b:v 13M -maxrate:v 13M -bufsize:v 13M  -c:a ac3 -b:a 256k -ac 2 -ar 48000 %output_file%

:: �M�z�Ȧs�ɮ�
rem del /q "%~dp0m2ts_files.txt"

pause