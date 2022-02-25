@echo off
Title EvenniaCMDer
color 0a
:loop
echo Please select the command you would like to be performed
echo [1] Make Directory
echo [2] Change Directory
echo [0] Exit
set input=
set /p input= Please select Command:
if %input%==1 goto directory
if %input%==0 goto exit
exit
:directory
echo Making Directory
mkdir "C:/EvenniaWolds"
echo --------------------------------------------------------------------------------
goto loop
:exit
exit
