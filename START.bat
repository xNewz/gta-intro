@ECHO OFF
TITLE samp-server Watchdog
:loop
cls
echo (%TIME%) Server Started.
samp-server.exe
echo (%TIME%) Server Crashed.
goto loop 