#!/usr/bin/env bash
set -e  # Exit on error
set -x  # Print commands for debugging

echo "=== Starting build ==="
echo "Timestamp: $(date)"

# Setup paths
REPO_DIR="$(pwd)"
TYPST_VERSION="0.12.0"
TYPST_CACHE="$REPO_DIR/.typst-binary"
TYPST_BIN="$TYPST_CACHE/typst"

# Use rheo from cargo
RHEO_BIN="/home/lox/.cargo/bin/rheo"

# Download typst binary from GitHub release if not cached
if [ ! -f "$TYPST_BIN" ]; then
  echo "Downloading typst ${TYPST_VERSION}..."
  mkdir -p "$TYPST_CACHE"
  curl -sL "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz" -o /tmp/typst.tar.xz
  tar -xf /tmp/typst.tar.xz -C "$TYPST_CACHE" --strip-components=1
  chmod +x "$TYPST_BIN"
  rm /tmp/typst.tar.xz
  echo "Typst downloaded successfully"
else
  echo "Using cached typst binary"
fi

# Add typst to PATH
export PATH="$TYPST_CACHE:$PATH"

# Find Python (for NixOS compatibility)
PYTHON=""
for cmd in nvim-python3 python3 python python3.12 python3.11 python3.10; do
  if command -v $cmd &> /dev/null; then
    PYTHON=$(command -v $cmd)
    break
  fi
done

# If not in PATH, check nix store
if [ -z "$PYTHON" ]; then
  PYTHON=$(find /nix/store -maxdepth 3 -name "python3" -type f -executable 2>/dev/null | head -1)
fi

if [ -z "$PYTHON" ]; then
  echo "Error: Python not found"
  exit 1
fi

echo "Using Python: $PYTHON"

# Compile the vocabulary project
echo "Compiling with rheo..."
rheo compile . --html

# Copy over images
cp -r content/img build/html/img

# Generate RSS feed
$PYTHON generate-feed.py

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
