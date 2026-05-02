#!/bin/bash

# Utility script to add/update files in a JAR archive.
# Usage: ./update_jar.sh <jar_path> <file_to_add> <path_in_jar>

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <jar_path> <file_to_add> <path_in_jar>"
    echo "Example: $0 app.jar config.xml resources/config.xml"
    exit 1
fi

JAR_PATH="$1"
FILE_TO_ADD="$2"
PATH_IN_JAR="$3"

if [ ! -f "$JAR_PATH" ]; then
    echo "Error: JAR file $JAR_PATH not found."
    exit 1
fi

if [ ! -f "$FILE_TO_ADD" ]; then
    echo "Error: File to add $FILE_TO_ADD not found."
    exit 1
fi

# Get the directory part of the path in JAR
DIR_IN_JAR=$(dirname "$PATH_IN_JAR")
BASE_FILE=$(basename "$PATH_IN_JAR")

# Create temporary directory structure
TEMP_DIR=$(mktemp -d)
mkdir -p "$TEMP_DIR/$DIR_IN_JAR"
cp "$FILE_TO_ADD" "$TEMP_DIR/$PATH_IN_JAR"

# Update JAR
echo "Updating $JAR_PATH with $PATH_IN_JAR..."
(cd "$TEMP_DIR" && zip -u "$(realpath "$JAR_PATH")" "$PATH_IN_JAR")

if [ $? -eq 0 ]; then
    echo "Successfully updated $JAR_PATH."
else
    echo "Failed to update $JAR_PATH."
    rm -rf "$TEMP_DIR"
    exit 1
fi

rm -rf "$TEMP_DIR"
