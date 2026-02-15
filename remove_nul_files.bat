@echo off
echo Removing NUL files from current directory...

for %%f in (*.nul) do (
    echo Deleting: %%f
    del /f /q "%%f"
)

REM Also handle files literally named "NUL" with no extension
if exist "\\?\%CD%\NUL" (
    echo Deleting reserved name: NUL
    del /f /q "\\?\%CD%\NUL"
)

echo Done.
pause
