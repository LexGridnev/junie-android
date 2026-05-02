#!/bin/bash

# Utility script to remove files from a JAR archive.
# Usage: ./remove_from_jar.sh <jar_path> <pattern>

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <jar_path> <pattern>"
    echo "Example: $0 app.jar \"lib/libjansi.so\""
    exit 1
fi

JAR_PATH="$1"
PATTERN="$2"

if [ ! -f "$JAR_PATH" ]; then
    echo "Error: File $JAR_PATH not found."
    exit 1
fi

echo "Removing $PATTERN from $JAR_PATH..."
zip -d "$JAR_PATH" "$PATTERN"

if [ $? -eq 0 ]; then
    echo "Successfully removed $PATTERN from $JAR_PATH."
else
    echo "Failed to remove $PATTERN from $JAR_PATH."
    exit 1
fi
