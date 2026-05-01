#!/data/data/com.termux/files/usr/bin/bash

# ==============================================================================
# Junie for Termux - System Readiness & Diagnostics
# ==============================================================================
# This script checks your Android and Termux environment before installation.
# ==============================================================================

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   🔍 JUNIE PRE-INSTALLATION READINESS CHECK${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# 1. Android System Data
echo -e "\n📱 [1/3] Gathering Android Information..."
MODEL=$(getprop ro.product.model)
MANUFACTURER=$(getprop ro.product.manufacturer)
ANDROID_VER=$(getprop ro.build.version.release)
ARCH=$(uname -m)

echo -e "  • Device: $MANUFACTURER $MODEL"
echo -e "  • Android Version: $ANDROID_VER"
echo -e "  • Architecture: $ARCH"

# 2. Termux Environment Check
echo -e "\n⚙️ [2/3] Checking Termux Environment..."

check_pkg() {
    if command -v "$1" &> /dev/null; then
        echo -e "  ${GREEN}✅${NC} $2 is installed"
        return 0
    else
        echo -e "  ${RED}❌${NC} $2 is NOT installed"
        return 1
    fi
}

# Check for essential tools
check_pkg "curl" "Curl (Download tool)"
check_pkg "unzip" "Unzip (Extraction tool)"
check_pkg "java" "Java 21 (OpenJDK)"

# Check Java Version specifically
if command -v java &> /dev/null; then
    JAVA_VER=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')
    if [[ "$JAVA_VER" == 21* ]]; then
        echo -e "  ${GREEN}✅${NC} Java Version: $JAVA_VER (Perfect!)"
    else
        echo -e "  ${RED}❌${NC} Java Version: $JAVA_VER (Recommended: 21)"
    fi
fi

# 3. Update Status & Storage
echo -e "\n📦 [3/3] Checking System Status..."

# Check storage
FREE_SPACE=$(df -h $HOME | awk 'NR==2 {print $4}')
echo -e "  • Available Storage: $FREE_SPACE"

# Check if pkg update was run recently (based on package index age)
INDEX_AGE=$(stat -c %Y /data/data/com.termux/files/usr/var/lib/apt/lists 2>/dev/null || echo 0)
CURRENT_TIME=$(date +%s)
AGE_MINUTES=$(( (CURRENT_TIME - INDEX_AGE) / 60 ))

if [ $AGE_MINUTES -lt 60 ]; then
    echo -e "  ${GREEN}✅${NC} Package index is fresh ($AGE_MINUTES mins old)"
else
    echo -e "  ${RED}❌${NC} Package index is STALE ($AGE_MINUTES mins old)"
    echo -e "     (Action: Run 'pkg upgrade -y' before installing!)"
fi

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ $AGE_MINUTES -lt 60 ] && command -v java &> /dev/null; then
    echo -e "  ${GREEN}READY!${NC} Your system is prepared for Junie."
else
    echo -e "  ${RED}NOT READY!${NC} Please follow the suggested actions above."
fi
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
