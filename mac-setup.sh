#!/bin/bash

# ============================================================
#  맥북 AI 개발 환경 통합 세팅 스크립트 (v2.0)
#  BSD 바이브코딩 교육센터 | 유저: Parkkyuhyi
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_step() { echo -e "\n${BLUE}${BOLD}▶ $1${NC}"; }
print_ok()   { echo -e "  ${GREEN}✓ $1${NC}"; }
print_info() { echo -e "  ${CYAN}ℹ $1${NC}"; }
print_warn() { echo -e "  ${YELLOW}⚠ $1${NC}"; }

clear
echo -e "${BOLD}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   맥북 AI 개발 환경 통합 자동화 세팅     ║"
echo "  ║         BSD 바이브코딩 교육센터           ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "  아래 항목들이 설치/설정됩니다:\n"
echo -e "  ${GREEN}[런타임]${NC} Node.js · Python 3 · Homebrew"
echo -e "  ${CYAN}[에디터]${NC} Chocolat · Antigravity IDE"
echo -e "  ${YELLOW}[AI에이전트]${NC} Claude Code · Codex · Gemini · OpenClaw"
echo -e "  ${BLUE}[유틸리티]${NC} tmuxp · Telegram · Rectangle · Maccy\n"
echo -e "  계속하려면 Enter를 누르세요 (중단: Ctrl+C)"
read -r

# 1. Homebrew 및 필수 런타임
print_step "Homebrew 및 핵심 런타임 확인 중..."
if ! command -v brew &>/dev/null; then
  print_info "Homebrew를 설치합니다..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  print_ok "Homebrew 이미 설치됨"
  brew update --quiet
fi

brew install node python tmuxp
print_ok "Node.js, Python, tmuxp 설치 완료"

# 2. GUI 앱 설치 (Casks)
print_step "GUI 앱 및 AI IDE 설치 중..."
APPS=(
  "rectangle:Rectangle:창 관리"
  "maccy:Maccy:클립보드"
  "appcleaner:AppCleaner:앱 삭제"
  "monitorcontrol:MonitorControl:모니터 제어"
  "stats:Stats:시스템 모니터"
  "chocolat:Chocolat:텍스트 에디터"
  "telegram:Telegram:메신저"
  "antigravity:Antigravity:Google AI IDE"
  "codex:Codex:OpenAI 코딩 에이전트"
)

for item in "${APPS[@]}"; do
  IFS=':' read -r cask name desc <<< "$item"
  if brew list --cask "$cask" &>/dev/null; then
    print_info "$name: 이미 설치됨"
  else
    echo -ne "  ${CYAN}→ $name ($desc) 설치 중...${NC}"
    if brew install --cask "$cask" --quiet 2>/dev/null; then
      echo -e "\r  ${GREEN}✓ $name — 설치 완료${NC}          "
    else
      echo -e "\r  ${YELLOW}⚠ $name — 설치 실패${NC}"
    fi
  fi
done

# 3. AI 코딩 에이전트 (CLI)
print_step "AI CLI 도구 설치 중..."

# Claude Code
if ! command -v claude &>/dev/null; then
  npm install -g @anthropic-ai/claude-code
  print_ok "Claude Code 설치 완료"
else
  print_info "Claude Code 이미 설치됨"
fi

# Gemini CLI
if ! command -v gemini &>/dev/null; then
  npm install -g gemini-cli
  print_ok "Gemini CLI 설치 완료"
fi

# OpenClaw
print_step "OpenClaw 설치 중..."
curl -fsSL https://openclaw.ai/install.sh | bash
print_ok "OpenClaw 설치 프로세스 완료"

# 4. 시스템 최적화 설정
print_step "macOS 시스템 최적화 적용 중..."

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false

# 트랙패드
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

# 스크린샷 폴더
SCREENSHOT_DIR="$HOME/Desktop/스크린샷"
mkdir -p "$SCREENSHOT_DIR"
defaults write com.apple.screencapture location "$SCREENSHOT_DIR"

killall Dock Finder 2>/dev/null
print_ok "시스템 설정 및 폴더 최적화 완료"

# 5. 완료 알림
echo ""
echo -e "${GREEN}${BOLD}  ╔══════════════════════════════════════════╗"
echo "  ║        🚀 모든 통합 세팅 완료!           ║"
echo "  ╚══════════════════════════════════════════╝${NC}"
echo -e "\n  ${BOLD}주요 실행 명령어:${NC}"
echo -e "  • ${YELLOW}agy${NC}        : Antigravity IDE 실행"
echo -e "  • ${YELLOW}claude${NC}     : Claude Code 실행"
echo -e "  • ${YELLOW}codex${NC}      : Codex 실행"
echo -e "  • ${YELLOW}tmuxp load${NC} : tmux 세션 관리\n"
echo -e "  ${YELLOW}⚠ 전체 설정을 위해 맥북을 재시작해 주세요!${NC}\n"