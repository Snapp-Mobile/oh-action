#!/usr/bin/env bash

# Enable strict error handling
set -e # Exit on error

# Start main log group for better visualization in GitHub Actions
echo "::group::Setting up OpenHarmony command-line tools for SDK 11"

# Validate required environment variables
# CMD_PATH: Directory where tools will be installed
# GITHUB_PATH: GitHub Actions path file for persistent PATH modifications
for var in CMD_PATH GITHUB_PATH GITHUB_ACTION_PATH; do
    if [ -z "${!var}" ]; then
        echo "::error::Required environment variable $var is not set"
        exit 1
    fi
done

# Get absolute path of the script's directory for reliable file operations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Output debug information for troubleshooting
echo "::debug::Script directory: $SCRIPT_DIR"
echo "::debug::CMD_PATH: $CMD_PATH"

# Install and configure OHPM (OpenHarmony Package Manager)
setup_ohpm() {
    echo "::group::Setting up OHPM..."
    # Create installation directory
    mkdir -p "$CMD_PATH/ohpm"

    # Extract OHPM package to installation directory
    if ! unzip -o "$SCRIPT_DIR/ohpm/ohpm.zip" -d "$CMD_PATH/ohpm"; then
        echo "::error::Failed to extract ohpm.zip"
        return 1
    fi
    echo "::endgroup::"
}

setup_hvigorw() {
    echo "::group::Setting up hvigorw..."
    
    # Validate PROJECT_PATH is set
    if [ -z "$PROJECT_PATH" ]; then
        echo "::error::PROJECT_PATH environment variable is not set"
        return 1
    fi

    # Check if hvigorw exists in the project
    if [ ! -f "$PROJECT_PATH/hvigorw" ]; then
        echo "::error::hvigorw file not found at: $PROJECT_PATH/hvigorw"
        return 1
    fi

    # Ensure bin directory exists
    mkdir -p "$CMD_PATH/bin"

    # Create the hvigorw script with the resolved PROJECT_PATH
    cat > "$CMD_PATH/bin/hvigorw" << EOF
#!/usr/bin/env bash

set -e
HVIGORW_PATH="$PROJECT_PATH/hvigorw"

# Preserve current directory
ORIGINAL_DIR="\$(pwd)"

# Change to the project directory, execute hvigorw, then return
(cd "$PROJECT_PATH" && exec bash "\$HVIGORW_PATH" "\$@")
RC=\$?

# Return to original directory (though not strictly necessary due to subshell)
cd "\$ORIGINAL_DIR"
exit \$RC
EOF

    # Verify the script was created
    if [ ! -f "$CMD_PATH/bin/hvigorw" ]; then
        echo "::error::Failed to create hvigorw script"
        return 1
    fi

    echo "::debug::hvigorw script created at: $CMD_PATH/bin/hvigorw"
    echo "::debug::Points to project hvigorw at: $PROJECT_PATH/hvigorw"
    echo "::endgroup::"
}

# Setup executable files in bin directory
setup_executables() {
    echo "::group::Setting up executables..."
    # Copy bin directory to installation path
    if ! cp -r "$SCRIPT_DIR/bin" "$CMD_PATH/"; then
        echo "::error::Failed to copy bin directory"
        return 1
    fi

    # Make all files in bin directory executable
    if ! chmod +x "$CMD_PATH/bin/"*; then
        echo "::error::Failed to set executable permissions"
        return 1
    fi
    echo "::endgroup::"
}

# Configure environment variables and verify installation
setup_environment() {
    echo "::group::Setting up environment..."

    # Add installation path to GitHub Actions PATH
    echo "$CMD_PATH/bin" >>"$GITHUB_PATH"
    # Add to current session PATH
    export PATH="$CMD_PATH/bin:$PATH"

    # Verify OHPM is accessible
    if ! command -v ohpm &>/dev/null; then
        echo "::error::ohpm not found in PATH"
        return 1
    fi

    # Display installation information
    echo "ohpm location: $(which ohpm)"
    ohpm -v
    echo "::endgroup::"
}

# Main installation sequence
main() {
    setup_ohpm || exit 1
    setup_hvigorw || exit 1
    setup_executables || exit 1
    setup_environment || exit 1
    echo "::notice::OpenHarmony tools installation completed successfully"
}

# Execute installation
main

# Close the main log group
echo "::endgroup::"
