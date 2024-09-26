@echo off
setlocal enabledelayedexpansion

:compressLoop

echo HELP FOR COMPRESSION LEVEL
echo 0 (Store): No compression, just stores the files in the archive.
echo 1 (Fastest): Minimal compression; it's quick but results in larger files.
echo 2 (Fast): Balanced speed and compression; a bit more compression than level 1.
echo 3 (Normal): Default level; provides a good balance between speed and file size.
echo 4 (Good): More compression than normal, taking a bit longer.
echo 5 (Best): Maximum compression, resulting in smaller files but the slowest speed.
echo ==========================================================================================

set /p "compressionLevel=Enter compression level (0-5): "
if not "!compressionLevel!"=="0" if not "!compressionLevel!"=="1" if not "!compressionLevel!"=="2" if not "!compressionLevel!"=="3" if not "!compressionLevel!"=="4" if not "!compressionLevel!"=="5" (
    echo Invalid compression level. Please enter a number between 0 and 5.
    goto compressLoop
)


set /p "password=Enter password (leave blank for none): "


set /p "comment=Enter comment for the archive (leave blank for none): "


set /p "folderChoice=Create a new folder (C) or use an existing folder (E)?: "
if /i "!folderChoice!"=="C" (
    set /p "folderToCompress=Enter new folder name: "
    mkdir "!folderToCompress!"
) else if /i "!folderChoice!"=="E" (
    set /p "folderToCompress=Enter folder to compress: "
) else (
    echo Invalid choice. Please enter 'C' to create a new folder or 'E' to use an existing folder.
    goto compressLoop
)


if exist "!folderToCompress!" (
    echo Compressing folder "!folderToCompress!"...
    set "rarCommand=rar a -r -m!compressionLevel!"

    if defined password (
        set "rarCommand=!rarCommand! -p!password!"
    )

    if defined comment (
        echo !comment! > "!folderToCompress!\comment.txt"
        set "rarCommand=!rarCommand! -z!folderToCompress!\comment.txt"
    )

    !rarCommand! "!folderToCompress!.rar" "!folderToCompress!" && (
        echo Folder compressed to "!folderToCompress!.rar".
        set /p "deleteFolders=Do you want to delete the original folder? (Y/N): "
        if /i "!deleteFolders!"=="Y" (
            rmdir /s /q "!folderToCompress!" && echo Original folder deleted.
        ) else (
            echo Original folder not deleted.
        )
    ) || (
        echo Compression failed.
    )
) else (
    echo The specified folder does not exist.
    goto compressLoop
)

if exist "!folderToCompress!\comment.txt" del "!folderToCompress!\comment.txt"


set /p "compressAgain=Do you want to compress another folder? (Y to continue, Enter to exit): "
if /i "!compressAgain!"=="Y" goto compressLoop

echo Process completed.

powershell -c "[console]::beep(500,300)"  
pause
