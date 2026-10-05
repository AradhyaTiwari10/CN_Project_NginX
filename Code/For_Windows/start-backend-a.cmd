@echo off
cd /d "%~dp0"
echo Starting Windows Backend A on port 3001. Keep this window open.
py -3 backend.py --name A --port 3001
pause
