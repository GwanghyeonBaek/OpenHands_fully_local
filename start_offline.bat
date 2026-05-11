@echo off
REM OpenHands 오프라인 실행 스크립트 (Windows 배치파일)
REM 사용법: 더블클릭 또는 CMD 에서 start_offline.bat
REM 배치파일은 PowerShell 실행 정책의 영향을 받지 않음

REM ── 설정 ─────────────────────────────────────────────────
REM 아래 IP 와 PORT 를 실제 vLLM 서버 주소로 교체하세요
set VLLM_HOST=WORKSTATION_IP
set VLLM_PORT=PORT
REM ─────────────────────────────────────────────────────────

REM 환경변수 설정
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
echo [OpenHands] vLLM 엔드포인트: http://%VLLM_HOST%:%VLLM_PORT%/v1
echo [OpenHands] 브라우저에서 접속: http://localhost:3000
echo.

REM Poetry PATH 자동 탐색 (설치 위치가 다를 수 있음)
set POETRY_EXE=poetry
where poetry >nul 2>&1
if errorlevel 1 (
    REM 일반적인 Poetry 설치 경로들 시도
    if exist "%APPDATA%\pypoetry\venv\Scripts\poetry.exe" (
        set POETRY_EXE=%APPDATA%\pypoetry\venv\Scripts\poetry.exe
    ) else if exist "%USERPROFILE%\.local\bin\poetry.exe" (
        set POETRY_EXE=%USERPROFILE%\.local\bin\poetry.exe
    ) else (
        echo [오류] Poetry 를 찾을 수 없습니다.
        echo 새 터미널을 열거나 PATH 에 Poetry 를 추가하세요.
        echo Poetry 설치 경로 확인: where /r %APPDATA% poetry.exe
        pause
        exit /b 1
    )
    echo [Poetry] 경로: %POETRY_EXE%
)

%POETRY_EXE% run uvicorn openhands.app_server.app:app --host 0.0.0.0 --port 3000
