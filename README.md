# Junie CLI for Android/Termux

This guide focuses on running Junie CLI natively on Android via Termux.

## Installation & Patching

To run Junie CLI on Termux, you must patch the JAR to remove incompatible native libraries.

### The 'zip -d' Patch
Termux uses Bionic libc, which is incompatible with the glibc-linked native libraries bundled in the Junie JAR. Run the following command to remove them and force Junie to use pure Java fallback:

```bash
JAR="$(ls -1 ~/.local/share/junie/lib/*.jar | head -1)"
zip -d "$JAR" "org/fusesource/jansi/internal/native/Linux/arm64/libjansi.so" \
             "org/jline/nativ/Linux/arm64/libjlinenative.so" || true
```

## Recommended LLMs

### 1. Google Gemini (Recommended)
Google Gemini (1.5 Pro/Flash) is the #1 recommended LLM for use with Junie on Android. It offers excellent performance and low latency.
To use Gemini, set your API key:
```bash
export GOOGLE_API_KEY="your_api_key_here"
```

## Tasker Automation
You can automate Junie tasks using the Termux:Tasker plugin.

### Example Tasker Integration
1. Create a script `~/tasker/junie_review.sh`:
```bash
#!/bin/bash
junie "Review the latest changes in this folder"
```
2. In Tasker, use the Termux:Tasker action to execute this script based on triggers (e.g., time, location, or file changes).
