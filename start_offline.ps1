# OpenHands 오프라인 실행 스크립트 (Windows PowerShell)
# 사용법: PowerShell 에서 .\start_offline.ps1 실행
#
# 전제조건:
#   - Python 3.12 설치 (https://python.org)
#   - Poetry 설치 (https://python-poetry.org/docs/#installation)
#   - Node.js 22 설치 (https://nodejs.org)
#   - 최초 1회: poetry install, cd frontend && npm install && npm run build

# ── 설정 ─────────────────────────────────────────────────
# 아래 IP 와 PORT 를 실제 vLLM 서버 주소로 교체하세요
$VLLM_HOST = "WORKSTATION_IP"
$VLLM_PORT = "PORT"
# ─────────────────────────────────────────────────────────

# 환경변수 설정
$env:RUNTIME                = "local"
$env:GITHUB_APP_CLIENT_ID   = ""
$env:GITHUB_APP_CLIENT_SECRET = ""
$env:GITHUB_TOKEN           = ""
$env:TAVILY_API_KEY         = ""
$env:SEARCH_API_KEY         = ""
$env:DISABLE_ANALYTICS      = "true"
$env:LLM_BASE_URL           = "http://${VLLM_HOST}:${VLLM_PORT}/v1"
$env:OPENHANDS_CONFIG_PATH  = ".\config.offline.toml"

Write-Host "vLLM 연결 확인 중..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://${VLLM_HOST}:${VLLM_PORT}/v1/models" -TimeoutSec 5
    Write-Host "vLLM 연결 성공: $($response.data[0].id)" -ForegroundColor Green
} catch {
    Write-Host "경고: vLLM 서버 연결 실패. IP/PORT 를 확인하세요." -ForegroundColor Yellow
    Write-Host "  현재 설정: http://${VLLM_HOST}:${VLLM_PORT}/v1" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "OpenHands 시작 중..." -ForegroundColor Cyan
Write-Host "브라우저에서 접속: http://localhost:3000" -ForegroundColor Green
Write-Host ""

poetry run uvicorn openhands.app_server.app:app --host 0.0.0.0 --port 3000
