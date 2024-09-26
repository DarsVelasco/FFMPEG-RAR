@echo off
setlocal enabledelayedexpansion

set "script_dir=%~dp0"

:main_menu
cls
echo.
echo Select the action you want to perform:
echo 1. Cut the video
echo 2. Resize the video
echo 3. Join videos
echo 4. Convert MP4 to MP3
echo 5. Exit
set /p action_choice="Enter your choice (1/2/3/4/5): "

if "%action_choice%"=="1" goto cut_video
if "%action_choice%"=="2" goto resize_video
if "%action_choice%"=="3" goto join_videos
if "%action_choice%"=="4" goto convert_mp4_to_mp3
if "%action_choice%"=="5" goto exit_script

echo Invalid choice. Exiting.
exit /b

:cut_video
 
set /p input_file="Enter the name of the video file (with extension) in this directory: "
set "input_path=%script_dir%%input_file%"

 
set "output_file=output_cut.mp4"
set "output_path=%script_dir%%output_file%"

 
echo.
set /p start_time="Enter start time (in format HH:MM:SS, e.g., 00:00:10): "
set /p end_time="Enter end time (in format HH:MM:SS, e.g., 00:00:30): "

 
"C:\ffmpeg\bin\ffmpeg.exe" -i "!input_path!" -ss "!start_time!" -to "!end_time!" -c copy "!output_path!"
echo Video has been cut from !start_time! to !end_time! and saved as "!output_file!" in the same directory.
pause
goto main_menu

:resize_video
 
set /p input_file="Enter the name of the video file (with extension) in this directory: "
set "input_path=%script_dir%%input_file%"

 
set "output_file=output_resized.mp4"
set "output_path=%script_dir%%output_file%"

 
echo.
echo Select the quality to resize the video:
echo 1. High (1280x720)
echo 2. Medium (640x360)
echo 3. Low (320x180)
set /p quality_choice="Enter your choice (1/2/3): "

 
if "%quality_choice%"=="1" (
    set "scale_value=1280:720"
) else if "%quality_choice%"=="2" (
    set "scale_value=640:-1"
) else if "%quality_choice%"=="3" (
    set "scale_value=320:-1"
) else (
    echo Invalid choice. Exiting.
    exit /b
)

 
"C:\ffmpeg\bin\ffmpeg.exe" -i "!input_path!" -vf scale=!scale_value! "!output_path!"
echo Video has been resized to !scale_value! and saved as "!output_file!" in the same directory.
pause
goto main_menu

:join_videos
 
set "temp_file=%script_dir%file_list.txt"
if exist "!temp_file!" del "!temp_file!"

echo Please enter the names of the video files (with extensions) to join, one per line.
echo Type "done" when you are finished.

:input_loop
set /p input_file="Enter video file name (or type 'done' to finish): "
if /i "!input_file!"=="done" (
    goto join_videos_process
)
if not exist "%script_dir%!input_file!" (
    echo File does not exist. Please enter a valid file name.
    goto input_loop
)

echo file '!input_file!' >> "!temp_file!"
goto input_loop

:join_videos_process
if not exist "!temp_file!" (
    echo No video files to join. Exiting.
    exit /b
)

set "output_file=output_joined.mp4"
set "output_path=%script_dir%!output_file!"

 
"C:\ffmpeg\bin\ffmpeg.exe" -f concat -safe 0 -i "!temp_file!" -c copy "!output_path!"
echo Videos have been joined and saved as "!output_file!" in the same directory.

 
del "!temp_file!"

pause
goto main_menu

:convert_mp4_to_mp3
 
set /p input_file="Enter the name of the MP4 file (with extension) in this directory: "
set "input_path=!script_dir!!input_file!"

 
if not exist "!input_path!" (
    echo Error: File "!input_file!" does not exist in the directory. Exiting.
    pause
    exit /b
)

 
set "output_file=output.mp3"
set "output_path=!script_dir!!output_file!"

 
echo Running FFmpeg command...
"C:\ffmpeg\bin\ffmpeg.exe" -i "!input_path!" -q:a 0 "!output_path!"

 
if %ERRORLEVEL% NEQ 0 (
    echo Error: Conversion failed. Please check if FFmpeg is installed correctly.
    pause
    exit /b
)

echo Conversion complete! The MP3 file has been saved as "!output_file!" in the same directory.
pause
goto main_menu

:exit_script
echo Exiting. Goodbye!
exit /b
