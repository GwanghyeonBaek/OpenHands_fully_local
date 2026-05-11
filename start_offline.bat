@echo off
REM OpenHands offline startup script for Windows
REM ── EDIT THESE TWO LINES BEFORE RUNNING ──────────────────
set VLLM_HOST=WORKSTATION_IP
set VLLM_PORT=PORT
REM ─────────────────────────────────────────────────────────

REM Validate that VLLM_HOST and VLLM_PORT have been set
if "%VLLM_HOST%"=="WORKSTATION_IP" (
    echo [ERROR] Please edit start_offline.bat and set VLLM_HOST to the actual IP address.
    pause
    exit /b 1
)
if "%VLLM_PORT%"=="PORT" (
    echo [ERROR] Please edit start_offline.bat and set VLLM_PORT to the actual port number.
    pause
    exit /b 1
)

REM Environment variables
set RUNTIME=local
set GITHUB_APP_CLIENT_ID=
set GITHUB_APP_CLIENT_SECRET=
set GITHUB_TOKEN=
set TAVILY_API_KEY=
set SEARCH_API_KEY=
set DISABLE_ANALYTICS=true
set LLM_BASE_URL=http://%VLLM_HOST%:%VLLM_PORT%/v1
set OPENHANDS_CONFIG_PATH=.\config.offline.toml

echo [OpenHands] vLLM endpoint : http://%VLLM_HOST%:%VLLM_PORT%/v1
echo [OpenHands] Open browser  : http://localhost:3000

REM Find poetry executable
set POETRY_EXE=poetry
where poetry >nul 2>&1
if errorlevel 1 (
    if exist "%APPDATA%\pypoetry\venv\Scripts\poetry.exe" (
        set POETRY_EXE=%APPDATA%\pypoetry\venv\Scripts\poetry.exe
    ) else (
        echo [ERROR] poetry not found. Open a new terminal after installing poetry and retry.
        pause
        exit /b 1
    )
)

REM Check if dependencies are installed by testing sqlalchemy import
%POETRY_EXE% run python -c "import sqlalchemy" >nul 2>&1
if errorlevel 1 (
    echo [SETUP] Running poetry install - this may take several minutes on first run...
    %POETRY_EXE% env use py -3.13 2>nul || %POETRY_EXE% env use py -3.12 2>nul
    %POETRY_EXE% install
    if errorlevel 1 (
        echo [ERROR] poetry install failed. Check the output above.
        pause
        exit /b 1
    )
    echo [SETUP] Installation complete.
)

echo [OpenHands] Starting server...
%POETRY_EXE% run uvicorn openhands.app_server.app:app --host 0.0.0.0 --port 3000
