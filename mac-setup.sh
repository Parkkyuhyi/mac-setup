#!/bin/bash

# ============================================================
#  맥북 초기 세팅 자동화 스크립트
#  BSD 바이브코딩 교육센터 | 퍼널띵
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
echo "  ║   맥북 에어 M4 초기 세팅 자동화 스크립트  ║"
echo "  ║         BSD 바이브코딩 교육센터           ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "  아래 항목들이 자동으로 설치/설정됩니다:\n"
echo -e "  ${GREEN}[앱]${NC} Rectangle · Maccy · AppCleaner · MonitorControl · Stats"
echo -e "  ${CYAN}[설정]${NC} Dock 자동숨기기 · 핫코너 · 트랙패드 · Finder · 스크린샷\n"
echo -e "  ${YELLOW}계속하려면 Enter를 누르세요 (중단: Ctrl+C)${NC}"
read -r

# ============================================================
# 1. Xcode Command Line Tools
# ============================================================
print_step "Xcode Command Line Tools 확인 중..."
if ! xcode-select -p &>/dev/null; then
  print_info "설치를 시작합니다 (팝업창에서 '설치' 클릭해주세요)"
  xcode-select --install
  echo -e "  ${YELLOW}설치 완료 후 Enter를 눌러 계속하세요${NC}"
  read -r
else
  print_ok "이미 설치되어 있어요"
fi

# ============================================================
# 2. Homebrew
# ============================================================
print_step "Homebrew 설치 중..."
if ! command -v brew &>/dev/null; then
  print_info "Homebrew를 설치합니다 (관리자 비밀번호 필요할 수 있어요)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # M1/M2/M3/M4 경로 설정
  if [[ -f /opt/homebrew/bin/brew ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  print_ok "Homebrew 설치 완료"
else
  print_ok "Homebrew 이미 설치되어 있어요"
  brew update --quiet
  print_ok "Homebrew 업데이트 완료"
fi

# ============================================================
# 3. 앱 설치
# ============================================================
print_step "앱 설치 중... (시간이 조금 걸려요 ☕)"

APPS=(
  "rectangle:Rectangle:창 분할 관리"
  "maccy:Maccy:클립보드 히스토리"
  "appcleaner:AppCleaner:앱 완전 삭제"
  "monitorcontrol:MonitorControl:외부모니터 밝기 제어"
  "stats:Stats:시스템 리소스 모니터"
)

for item in "${APPS[@]}"; do
  IFS=':' read -r cask name desc <<< "$item"
  echo -ne "  ${CYAN}→ $name ($desc) 설치 중...${NC}"
  if brew list --cask "$cask" &>/dev/null; then
    echo -e "\r  ${GREEN}✓ $name — 이미 설치됨${NC}          "
  else
    if brew install --cask "$cask" --quiet 2>/dev/null; then
      echo -e "\r  ${GREEN}✓ $name — 설치 완료${NC}          "
    else
      echo -e "\r  ${YELLOW}⚠ $name — 설치 실패 (수동 설치 필요)${NC}"
    fi
  fi
done

# ============================================================
# 4. Dock 설정
# ============================================================
print_step "Dock 설정 적용 중..."

# 자동 숨기기
defaults write com.apple.dock autohide -bool true
# 숨기기 딜레이 없애기
defaults write com.apple.dock autohide-delay -float 0
# 숨기기/나타나기 애니메이션 빠르게
defaults write com.apple.dock autohide-time-modifier -float 0.3
# 숨겨진 앱 아이콘 흐리게 표시
defaults write com.apple.dock showhidden -bool true
# 최근 앱 섹션 숨기기
defaults write com.apple.dock show-recents -bool false
# Dock 크기 줄이기
defaults write com.apple.dock tilesize -int 48

print_ok "Dock 자동 숨기기, 딜레이 제거, 크기 최적화 완료"

# ============================================================
# 5. 핫 코너 설정
# ============================================================
print_step "핫 코너 설정 적용 중..."

# 좌상단: Mission Control (2)
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0

# 우상단: 알림 센터 (12)
defaults write com.apple.dock wvous-tr-corner -int 12
defaults write com.apple.dock wvous-tr-modifier -int 0

# 좌하단: 데스크탑 보기 (4)
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0

# 우하단: Launchpad (11)
defaults write com.apple.dock wvous-br-corner -int 11
defaults write com.apple.dock wvous-br-modifier -int 0

print_ok "핫 코너 설정 완료"
print_info "좌상단: Mission Control | 우상단: 알림센터"
print_info "좌하단: 데스크탑 | 우하단: Launchpad"

# ============================================================
# 6. 트랙패드 설정
# ============================================================
print_step "트랙패드 설정 적용 중..."

# 탭으로 클릭 활성화
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# 트랙패드 속도 높이기 (0~3, 기본 1)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5

# 자연스러운 스크롤 유지 (기본값)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

print_ok "탭으로 클릭 활성화, 트랙패드 속도 최적화 완료"

# ============================================================
# 7. Finder 설정
# ============================================================
print_step "Finder 설정 적용 중..."

# 파일 확장자 항상 표시
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# 숨김 파일 표시 (개발자용)
defaults write com.apple.finder AppleShowAllFiles -bool true
# 경로 막대 표시
defaults write com.apple.finder ShowPathbar -bool true
# 상태 막대 표시
defaults write com.apple.finder ShowStatusBar -bool true
# 기본 폴더: 홈 폴더
defaults write com.apple.finder NewWindowTarget -string "PfHm"
# 검색 범위: 현재 폴더
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# DS_Store 파일 USB/네트워크에 생성 안 함
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

print_ok "Finder 최적화 완료 (확장자 표시, 경로 막대, 숨김파일 표시)"

# ============================================================
# 8. 스크린샷 설정
# ============================================================
print_step "스크린샷 설정 적용 중..."

# 스크린샷 저장 폴더 생성 (바탕화면 대신 별도 폴더)
SCREENSHOT_DIR="$HOME/Desktop/스크린샷"
mkdir -p "$SCREENSHOT_DIR"
defaults write com.apple.screencapture location "$SCREENSHOT_DIR"

# 스크린샷 그림자 제거
defaults write com.apple.screencapture disable-shadow -bool true
# 스크린샷 형식 PNG 유지
defaults write com.apple.screencapture type -string "png"

print_ok "스크린샷 → ~/Desktop/스크린샷 폴더에 저장, 그림자 제거"

# ============================================================
# 9. 기타 시스템 설정
# ============================================================
print_step "기타 시스템 설정 적용 중..."

# 키 반복 속도 빠르게 (타이핑 최적화)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# 저장 다이얼로그 기본: 확장 보기
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# 앱 종료 시 문서 자동 저장 여부 확인 안 함
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool false

# 배터리 퍼센트 표시 (메뉴바)
defaults write com.apple.menuextra.battery ShowPercent -bool true

print_ok "키 반복 속도, 저장 다이얼로그, 배터리 퍼센트 표시 완료"

# ============================================================
# 10. 변경 사항 적용 (Dock + Finder 재시작)
# ============================================================
print_step "변경 사항 적용 중..."
killall Dock 2>/dev/null
killall Finder 2>/dev/null
killall SystemUIServer 2>/dev/null

# ============================================================
# 완료
# ============================================================
echo ""
echo -e "${GREEN}${BOLD}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║           🎉 모든 설정 완료!             ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "  ${BOLD}설치된 앱:${NC}"
echo -e "  • Rectangle   → 앱 실행 후 접근성 권한 허용해주세요"
echo -e "  • Maccy       → 메뉴바 아이콘에서 클립보드 권한 허용"
echo -e "  • AppCleaner  → 앱 드래그해서 사용"
echo -e "  • MonitorControl → 외부 모니터 연결 시 자동 동작"
echo -e "  • Stats       → 메뉴바에서 표시 항목 커스텀 가능\n"
echo -e "  ${BOLD}핫 코너 설정:${NC}"
echo -e "  • 좌상단 → Mission Control (모든 창 보기)"
echo -e "  • 우상단 → 알림 센터"
echo -e "  • 좌하단 → 데스크탑 보기"
echo -e "  • 우하단 → Launchpad\n"
echo -e "  ${YELLOW}⚠ 맥북을 재시작하면 모든 설정이 완전히 적용돼요!${NC}\n"