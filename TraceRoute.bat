@echo off
Title Website Trace Route
color 0a
:loop
echo Enter the website you would like to trace route
set input=
set /p input= Enter your Website here:
echo Processing Your request
echo -------------------------------------------------------------------------------------
tracert %input%
set input=
set /p input= Would you like to trace again y/n?:
if %input%==y goto loop
if %input%==Y goto loop
:exit
exit
