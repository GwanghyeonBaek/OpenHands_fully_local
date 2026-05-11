@echo off
chcp 65001 >nul
REM OpenHands offline startup script for Windows
REM Edit VLLM_HOST and VLLM_PORT before running

REM ── EDIT THESE VALUES ────────────────────────────────────
set VLLM_HOST=WORKSTATION_IP
set VLLM_PORT=PORT
REM ─────────────────────────────────────────────────────────

set RUNTIME=local
set GITHUB_APP_CLIENT_ID=
set GITHUB_APP_CLIENT_SECRET=
set GITHUB_TOKEN=
set TAVILY_API_KEY=
set SEARCH_API_KEY=
set DISABLE_ANALYTICS=true
set LLM_BASE_URL=http://%VLLM_HOST%:%VLLM_PORT%/v1
set OPENHANDS_CONFIG_PATH=.\config.offline.toml

echo.
echo [OpenHands] vLLM endpoint : http://%VLLM_HOST%:%VLLM_PORT%/v1
echo [OpenHands] Open browser  : http://localhost:3000
echo.

where poetry >nul 2>&1
if not errorlevel 1 goto run

if exist "%APPDATA%\pypoetry\venv\Scripts\poetry.exe" (
    set POETRY_EXE=%APPDATA%\pypoetry\venv\Scripts\poetry.exe
    goto run
)
if exist "%USERPROFILE%\.local\bin\poetry.exe" (
    set POETRY_EXE=%USERPROFILE%\.local\bin\poetry.exe
    goto run
)

echo [ERROR] poetry not found. Open a new terminal and retry.
pause
exit /b 1

:run
if not defined POETRY_EXE set POETRY_EXE=poetry
%POETRY_EXE% run uvicorn openhands.app_server.app:app --host 0.0.0.0 --port 3000
