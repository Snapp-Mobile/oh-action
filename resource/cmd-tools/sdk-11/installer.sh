#!/usr/bin/env bash

echo "Setting up OpenHarmony command-line tools for SDK 11"

# Create ohpm directory
mkdir -p $CMD_PATH/ohpm

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Extract ohpm
if ! unzip -o $SCRIPT_DIR/ohpm/ohpm.zip -d $CMD_PATH/ohpm; then
  echo "Error: Failed to extract ohpm.zip"
  exit 1
fi

# Copy the entire bin directory
if ! cp -r $SCRIPT_DIR/bin $CMD_PATH/; then
  echo "Error: Failed to copy bin directory"
  exit 1
fi

# Make all files in bin executable
chmod +x $CMD_PATH/bin/*

# Add to PATH
echo "$CMD_PATH/bin" >> $GITHUB_PATH
export PATH="$CMD_PATH/bin:$PATH"

# Verify installation
echo "ohpm installed successfully in: "
which ohpm
echo "ohpm version: "
ohpm -v
