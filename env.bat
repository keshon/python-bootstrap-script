@echo off
setlocal enabledelayedexpansion

set venv_folder=env
REM Update path to python script that will be executed with "run" command
set startup_file=src\main.py

REM Check if Python is installed
where python > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed on this system.
    exit /b
)

echo [INFO] Checking virtual environment...

REM Check if venv is installed
python -c "import venv" > nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Installing venv...
    python -m ensurepip --upgrade
    python -m pip install virtualenv
)

REM Check if the venv folder exists
if not exist %venv_folder% (
    echo [INFO] Creating virtual environment...
    python -m venv %venv_folder%
    echo [INFO] Virtual environment created successfully.
)

REM Activate the virtual environment
call %venv_folder%\Scripts\activate.bat

echo [INFO] Entered local environment instance. You can now install additional packages or run the project with 'run' command.

REM Start an infinite loop to accept commands
:command_loop
set /p command="> "
if "%command%"=="run" (
    echo [INFO] Running %startup_file%...
    python %startup_file%
) else (
    if "%command%"=="exit" (
        goto :exit_loop
    ) else (
        %command%
    )
)
goto :command_loop

REM Exit the loop and deactivate the virtual environment
:exit_loop
echo [INFO] Exited local environment instance.
deactivate

endlocal