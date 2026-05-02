---
name: jar-patcher
description: Instructions and tools for patching JAR files (removing, adding, or replacing files).
---

# JAR Patcher Skill

Use this skill when you need to modify the contents of a JAR file without recompiling it from source. This is useful for removing problematic native libraries, updating configurations, or patching classes.

## Key Principles
- **Backup first**: Always make a backup of the JAR file before patching.
- **Verification**: Use `unzip -l` to verify changes after each operation.
- **Path preservation**: Ensure paths are preserved when adding files back to the JAR.

## Common Operations

### 1. Removing files from a JAR
Use `zip -d` to delete files from the archive.
```bash
zip -d path/to/your.jar "path/to/file/to/remove"
```
*Note: You can use wildcards, e.g., `"*.so"` to remove all shared objects.*

### 2. Adding or updating files in a JAR
Use `zip -u` to update or add files. The file to be added must be in a directory structure that matches its path inside the JAR.
```bash
# Example: updating log4j2.xml
mkdir -p resources
cp new_log4j2.xml resources/log4j2.xml
zip -u path/to/your.jar resources/log4j2.xml
```

### 3. Extracting files for inspection
Use `unzip` to extract specific files.
```bash
unzip path/to/your.jar "path/to/file" -d ./extracted/
```

### 4. Listing JAR contents
```bash
unzip -l path/to/your.jar
```

## Using the `jar` utility
Alternatively, you can use the `jar` command which is specifically designed for JAR files.
```bash
# Remove (not directly supported by old jar, but you can extract and recreate)
# Update
jar uf path/to/your.jar -C directory/ file
```

## Helper Scripts
The skill includes helper scripts to simplify common tasks:
- `scripts/remove_from_jar.sh`: Removes a file or pattern from a JAR.
- `scripts/update_jar.sh`: Adds or updates a file in a JAR at a specific path.

### Example usage of scripts:
```bash
# Remove a library
.junie/skills/jar-patcher/scripts/remove_from_jar.sh my-app.jar "lib/old-lib.jar"

# Update a config file
.junie/skills/jar-patcher/scripts/update_jar.sh my-app.jar local_config.xml resources/config.xml
```

## Troubleshooting
- **Permission denied**: Ensure you have write permissions to the JAR file and the directory it's in.
- **File not found in archive**: Double check the path using `unzip -l`. Paths are usually case-sensitive.
- **Corrupted JAR**: If the JAR becomes corrupted, restore from backup.
