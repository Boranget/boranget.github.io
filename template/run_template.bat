@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "template.ps1"
pause