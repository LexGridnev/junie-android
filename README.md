# 📱 JetBrains Junie for Android

[![GitHub License](https://img.shields.io/github/license/LexGridnev/junie-android)](LICENSE)
[![Termux Compatibility](https://img.shields.io/badge/Termux-aarch64-green)](https://termux.dev/)

An optimized, professional installer for the **JetBrains Junie CLI** AI agent on Android via Termux. This project enables a full-featured AI coding agent to run natively on your mobile device with minimal overhead and maximum performance.

---

## 🏗️ Technical Architecture: The "JAR Method"

Official JetBrains binaries for Linux/aarch64 are linked against `glibc`, which is incompatible with Android's `Bionic libc`. While most solutions rely on heavy `proot` containers (e.g., Ubuntu), this installer uses the **JAR Method**:

1.  **Native JVM:** Leverages Termux's native `openjdk-21` package.
2.  **Lean Artifacts:** Extracts only the application JAR from the official release, skipping the ~100MB bundled JRE and incompatible native binaries.
3.  **Dynamic Wrapper:** Uses a smart shell wrapper to launch Junie via `java -jar`, ensuring resilience against version updates and path changes.

**Benefits:** ~50% reduction in storage (340MB vs 700MB+), faster startup, and significantly lower battery consumption.

---

## 🛠️ Prerequisites: Termux Setup

Junie runs within the **Termux** environment. If you don't have it installed:

1.  **Download:** Obtain Termux from [F-Droid](https://f-droid.org/en/packages/com.termux/) (recommended for updates) or [GitHub](https://github.com/termux/termux-app).
2.  **Permissions:** Run `termux-setup-storage` to allow Junie to access your project files if they are on shared storage.

---

## ⚡ Installation

### 1. Readiness Check
Verify your environment is prepared for Junie:
```bash
curl -fSL https://raw.githubusercontent.com/LexGridnev/junie-android/main/diagnostics.sh | bash
```

### 2. Run Installer
Once diagnostics pass, execute the optimized installer:
```bash
pkg upgrade -y && pkg install curl -y && \
curl -fSL https://raw.githubusercontent.com/LexGridnev/junie-android/main/install.sh | bash
```

*Note: Access to the Junie service requires a [JetBrains AI subscription](https://www.jetbrains.com/ai/).*

---

## 🧠 Supported AI Models

Junie is model-agnostic and supports top-tier LLMs from multiple providers. You can specify a model using the `--model <ID>` flag.

| Provider | Model Aliases |
|---|---|
| **Anthropic** | `sonnet` (Claude 3.5 Sonnet), `opus` |
| **OpenAI** | `gpt` (GPT-4o/latest), `gpt-codex` |
| **Google** | `gemini-pro`, `gemini-flash` |
| **xAI** | `grok` |

Refer to the [Official Model Selection Guide](https://junie.jetbrains.com/docs/junie-cli-model-selection.html) for detailed configuration.

---

## 🚀 Quick Start

After installation, you can interact with Junie using these common patterns:

- **Interactive Mode:** `junie` (Start a conversation in your current directory)
- **One-off Prompt:** `junie "Fix the typos in README.md"`
- **Plan Mode:** `junie --plan "Refactor the authentication logic"`
- **Specific Model:** `junie --model sonnet "Explain this code"`

---

## 📜 Credits & Legal

- **Research:** Built on the technical investigation of Lex Gridnev.
- **Disclaimer:** This is a community-maintained installation script.
- **Trademarks:** JetBrains and Junie are trademarks of JetBrains s.r.o.

---
[Official Junie Documentation](https://junie.jetbrains.com/docs/) | [GitHub Repository](https://github.com/JetBrains/junie)
