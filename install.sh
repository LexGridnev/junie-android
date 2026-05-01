#!/data/data/com.termux/files/usr/bin/bash

# ==============================================================================
# JetBrains Junie for Termux - Optimized Installer (JAR Method)
# ==============================================================================
# This script installs Junie on Termux using the native OpenJDK 21.
# It avoids the heavy glibc dependencies and proot overhead.
# ==============================================================================

set -e

# Configuration
VERSION="1468.30"
INSTALL_DIR="$HOME/.local/share/junie"
BIN_DIR="$HOME/.local/bin"
LIB_DIR="$INSTALL_DIR/lib"
DOWNLOAD_URL="https://github.com/JetBrains/junie/releases/download/$VERSION/junie-release-$VERSION-linux-aarch64.zip"

echo "[*] Preparing installation of Junie v$VERSION..."

# 1. Dependency Check
echo "[*] Checking dependencies..."
for pkg in openjdk-21 curl unzip; do
    if ! command -v $pkg &> /dev/null; then
        echo "[!] $pkg not found. Installing..."
        pkg install -y $pkg
    fi
done

# 2. Directory Setup
mkdir -p "$LIB_DIR" "$BIN_DIR"

# 3. Download (with resume support)
echo "[*] Downloading Junie release package..."
TEMP_ZIP="$TMPDIR/junie-$VERSION.zip"
curl -fSL --progress-bar -C - -o "$TEMP_ZIP" "$DOWNLOAD_URL"

# 4. Extraction
echo "[*] Extracting application JAR..."
# We only need the JAR and the config file from the 'app' directory
# The 'runtime' (bundled JRE) and 'bin' (native glibc binary) are ignored.
unzip -j -o "$TEMP_ZIP" "junie-app/lib/app/*.jar" "junie-app/lib/app/junie.cfg" -d "$LIB_DIR"

# 5. Cleanup
rm -f "$TEMP_ZIP"

# 6. Create Wrapper Script
echo "[*] Creating native wrapper..."
cat > "$BIN_DIR/junie" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# Junie Termux Wrapper
# Disabling Jansi colors if needed, but modern Termux supports it.
export JAVA_TOOL_OPTIONS="-Dorg.fusesource.jansi.Ansi.disable=true -Djansi.passthrough=true"

# Find the JAR file dynamically to be version-agnostic
LIB_DIR="$HOME/.local/share/junie/lib"
JAR="$(ls -1 "$LIB_DIR"/*.jar 2>/dev/null | head -1)"

if [ -z "$JAR" ]; then
    echo "Error: Junie JAR not found in $LIB_DIR" >&2
    exit 1
fi

exec java -jar "$JAR" "$@"
EOF

chmod +x "$BIN_DIR/junie"

# 7. Final Instructions
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " [✓] Junie installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " To run Junie, ensure '$BIN_DIR' is in your PATH."
echo " If not already added, run:"
echo ""
echo "   echo 'export PATH=\"\$PATH:$BIN_DIR\"' >> ~/.bashrc"
echo "   source ~/.bashrc"
echo ""
echo " Then simply type: junie"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
