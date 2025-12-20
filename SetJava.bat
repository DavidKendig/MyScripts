@echo off
REM Set Java JDK 25 as the active Java version
REM Run this script as Administrator to set system-wide variables

echo Setting JAVA_HOME to JDK 25...
setx JAVA_HOME "C:\Program Files\Java\jdk-25"

echo Adding Java to PATH...
setx PATH "%PATH%;%JAVA_HOME%\bin"

echo.
echo Java environment variables set successfully!
echo.
echo To verify, close this window and open a new command prompt, then run:
echo   java -version
echo   javac -version
echo.
pause
