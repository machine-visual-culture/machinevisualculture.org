#!/bin/bash
set -e  # Exit on error
set -x  # Print commands for debugging

echo "=== Starting build ==="
echo "Timestamp: $(date)"

# Setup paths
REPO_DIR="$(pwd)"
RHEO_VERSION="v0.1.2"
RHEO_CACHE="$REPO_DIR/.rheo-binary"
RHEO_BIN="$RHEO_CACHE/rheo"

# Download rheo binary from GitHub release if not cached
if [ ! -f "$RHEO_BIN" ]; then
  echo "Downloading rheo ${RHEO_VERSION}..."
  mkdir -p "$RHEO_CACHE"
  curl -sL "https://github.com/freecomputinglab/rheo/releases/download/${RHEO_VERSION}/rheo-x86_64-unknown-linux-gnu.zip" -o /tmp/rheo.zip
  unzip -o /tmp/rheo.zip -d "$RHEO_CACHE"
  chmod +x "$RHEO_BIN"
  rm /tmp/rheo.zip
  echo "Rheo downloaded successfully"
else
  echo "Using cached rheo binary"
fi

# Add rheo to PATH
export PATH="$RHEO_CACHE:$PATH"

# Verify rheo is accessible
rheo --version || echo "Warning: rheo --version failed, but continuing..."

# Compile the vocabulary project
echo "Compiling with rheo..."
rheo compile . --html

# Copy over images
cp -r content/img build/html/img

# Verify output was generated
if [ ! -f "build/html/index.html" ]; then
  echo "Error: build/html/index.html not found after compilation"
  exit 1
fi

# Count generated HTML files
HTML_COUNT=$(find build/html -name "*.html" | wc -l)
echo "Successfully generated $HTML_COUNT HTML files"

echo "=== Build completed successfully ==="
echo "Timestamp: $(date)"
