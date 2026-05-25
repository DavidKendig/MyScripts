@echo off
title NVIDIA GPU Monitor
:loop
cls
nvidia-smi
timeout /t 1 /nobreak >nul
goto loop
