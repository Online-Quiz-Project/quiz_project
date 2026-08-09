#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$PROJECT_DIR/logs"
BACKEND_ENV="$PROJECT_DIR/backend/.env.properties"
AI_VENV="$PROJECT_DIR/ai-service/.venv"
PIDS=()
NAMES=()

mkdir -p "$LOG_DIR"

info() { printf '\033[1;34m[Quizly]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[Quizly]\033[0m %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"; }

cleanup() {
  local index pid
  trap - INT TERM EXIT
  info "Stopping Quizly services..."
  for ((index=${#PIDS[@]}-1; index>=0; index--)); do
    pid="${PIDS[$index]}"
    if kill -0 "$pid" 2>/dev/null; then
      pkill -TERM -P "$pid" 2>/dev/null || true
      kill -TERM "$pid" 2>/dev/null || true
    fi
  done
  wait 2>/dev/null || true
  info "Stopped. MySQL was left running."
}
trap cleanup INT TERM EXIT

start_process() {
  local name="$1" directory="$2" log_file="$3"
  shift 3
  info "Starting $name (log: logs/$log_file)"
  (
    cd "$directory"
    exec "$@"
  ) >"$LOG_DIR/$log_file" 2>&1 &
  PIDS+=("$!")
  NAMES+=("$name")
}

wait_url() {
  local name="$1" url="$2" attempts="${3:-60}" index
  for ((index=1; index<=attempts; index++)); do
    if curl -fsS --max-time 2 "$url" >/dev/null 2>&1; then
      info "$name is ready"
      return 0
    fi
    sleep 1
  done
  return 1
}

show_failed_log() {
  local name="$1" log_file="$2"
  printf '\nLast lines from %s:\n' "$name" >&2
  tail -n 30 "$LOG_DIR/$log_file" >&2 || true
}

need curl
need java
need dotnet
need npm

[[ -f "$BACKEND_ENV" ]] || fail "Create backend/.env.properties from backend/.env.properties.example first."

if command -v mysqladmin >/dev/null 2>&1 && ! mysqladmin ping --silent >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    info "Starting MySQL with Homebrew..."
    if ! brew services start mysql >/dev/null; then
      fail "Homebrew could not start MySQL. Run 'brew services start mysql' manually and check its output."
    fi
    for _ in {1..30}; do
      mysqladmin ping --silent >/dev/null 2>&1 && break
      sleep 1
    done
  fi
fi
if command -v mysqladmin >/dev/null 2>&1; then
  mysqladmin ping --silent >/dev/null 2>&1 || fail "MySQL is not running. Start it, then run this script again."
else
  info "mysqladmin was not found; Spring Boot will verify the database connection."
fi

if [[ ! -x "$AI_VENV/bin/python" ]]; then
  need python3
  info "Creating the Python environment..."
  python3 -m venv "$AI_VENV"
  "$AI_VENV/bin/python" -m pip install -r "$PROJECT_DIR/ai-service/requirements.txt"
fi

JWT_SECRET="$(sed -n 's/^[[:space:]]*JWT_SECRET[[:space:]]*=[[:space:]]*//p' "$BACKEND_ENV" | tail -n 1)"
[[ -n "$JWT_SECRET" ]] || fail "JWT_SECRET is missing from backend/.env.properties."

AI_ENV="$PROJECT_DIR/ai-service/.env"
GEMINI_API_KEY="${GEMINI_API_KEY:-}"
if [[ -z "$GEMINI_API_KEY" && -f "$AI_ENV" ]]; then
  GEMINI_API_KEY="$(sed -n 's/^[[:space:]]*GEMINI_API_KEY[[:space:]]*=[[:space:]]*//p' "$AI_ENV" | tail -n 1)"
fi
if [[ -z "$GEMINI_API_KEY" ]]; then
  GEMINI_API_KEY="$(sed -n 's/^[[:space:]]*GEMINI_API_KEY[[:space:]]*=[[:space:]]*//p' "$BACKEND_ENV" | tail -n 1)"
fi
if [[ -z "$GEMINI_API_KEY" ]]; then
  printf 'Paste your Gemini API key (input hidden): '
  read -rs GEMINI_API_KEY
  printf '\n'
  [[ -n "$GEMINI_API_KEY" ]] || fail "A Gemini API key is required."
  umask 077
  printf 'GEMINI_API_KEY=%s\nGEMINI_MODEL=gemini-3.1-flash-lite\n' "$GEMINI_API_KEY" >"$AI_ENV"
  info "Saved the key in ignored file ai-service/.env"
fi
GEMINI_MODEL="${GEMINI_MODEL:-$(sed -n 's/^[[:space:]]*GEMINI_MODEL[[:space:]]*=[[:space:]]*//p' "$BACKEND_ENV" | tail -n 1)}"
GEMINI_MODEL="${GEMINI_MODEL:-gemini-3.1-flash-lite}"

if curl -fsS --max-time 2 http://127.0.0.1:5050/health >/dev/null 2>&1; then
  info "Logging service is already running"
else
  start_process "logging service" "$PROJECT_DIR/logging-service" "logging-service.log" dotnet run
  wait_url "Logging service" "http://127.0.0.1:5050/health" 45 || {
    show_failed_log "logging service" "logging-service.log"
    fail "Logging service did not start."
  }
fi

AI_HEALTH="$(curl -fsS --max-time 2 http://127.0.0.1:8000/health 2>/dev/null || true)"
if [[ "$AI_HEALTH" == *'"provider":"gemini"'* || "$AI_HEALTH" == *'"provider": "gemini"'* ]]; then
  info "Gemini AI service is already running"
elif [[ -n "$AI_HEALTH" ]]; then
  fail "Port 8000 is occupied by the old AI service. Stop it, then run this script again."
else
  start_process "AI service" "$PROJECT_DIR/ai-service" "ai-service.log" \
    env JWT_SECRET="$JWT_SECRET" GEMINI_API_KEY="$GEMINI_API_KEY" \
    GEMINI_MODEL="$GEMINI_MODEL" \
    LOGGING_SERVICE_URL="http://127.0.0.1:5050" \
    "$AI_VENV/bin/uvicorn" main:app --host 127.0.0.1 --port 8000
  wait_url "AI service" "http://127.0.0.1:8000/health" 45 || {
    show_failed_log "AI service" "ai-service.log"
    fail "AI service did not start."
  }
fi

if curl -fsS --max-time 2 http://127.0.0.1:8080/v3/api-docs >/dev/null 2>&1; then
  info "Spring Boot backend is already running"
else
  start_process "Spring Boot backend" "$PROJECT_DIR/backend" "backend.log" ./mvnw spring-boot:run
  wait_url "Spring Boot backend" "http://127.0.0.1:8080/v3/api-docs" 90 || {
    show_failed_log "Spring Boot backend" "backend.log"
    fail "Spring Boot backend did not start. Check MySQL settings in backend/.env.properties."
  }
fi

if [[ ! -d "$PROJECT_DIR/frontend/node_modules" ]]; then
  info "Installing frontend packages..."
  (cd "$PROJECT_DIR/frontend" && npm install)
fi

if curl -fsS --max-time 2 http://localhost:5174 >/dev/null 2>&1; then
  info "React frontend is already running"
else
  start_process "React frontend" "$PROJECT_DIR/frontend" "frontend.log" npm run dev -- --host 127.0.0.1 --port 5174 --strictPort
  wait_url "React frontend" "http://localhost:5174" 45 || {
    show_failed_log "React frontend" "frontend.log"
    fail "React frontend did not start."
  }
fi

printf '\n\033[1;32mQuizly is ready!\033[0m\n'
printf '  App:       http://localhost:5174\n'
printf '  Backend:   http://localhost:8080/swagger-ui.html\n'
printf '  AI docs:   http://localhost:8000/docs\n'
printf '  Logs:      %s\n\n' "$LOG_DIR"
printf 'Press Ctrl+C to stop all services started by this script.\n'

while true; do
  for index in "${!PIDS[@]}"; do
    if ! kill -0 "${PIDS[$index]}" 2>/dev/null; then
      show_failed_log "${NAMES[$index]}" "$(case "${NAMES[$index]}" in
        "logging service") echo logging-service.log ;;
        "AI service") echo ai-service.log ;;
        "Spring Boot backend") echo backend.log ;;
        *) echo frontend.log ;;
      esac)"
      fail "${NAMES[$index]} stopped unexpectedly."
    fi
  done
  sleep 2
done
