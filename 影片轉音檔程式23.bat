@echo off

chcp 65001

@echo off
set ffmpeg_path="%~dp0ffmpeg-6.1.1-full_build\bin\ffmpeg.exe"

:softshare
if "%~1"=="" goto:eof
%ffmpeg_path% -i "%~1" -c:a pcm_s16le "%~dpn1.wav"
shift&goto:softshare