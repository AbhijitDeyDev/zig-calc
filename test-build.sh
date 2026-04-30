#!/bin/bash

# Test build script for Linux/Mac
# This script tests the build commands that will be used in GitHub Actions
# Requires Zig 0.16.0 or higher

echo "Testing build process for zig-calc"
echo "=================================="

# Check if Zig is installed
if ! command -v zig &> /dev/null; then
    echo "ERROR: Zig is not installed!"
    exit 1
fi

echo "Zig version: $(zig version)"

# Check OS
OS_NAME=$(uname -s)
echo "Operating System: $OS_NAME"

if [ "$OS_NAME" = "Linux" ]; then
    echo "Detected Linux system"
    echo "Installing SDL2 dependencies..."

    # Check package manager
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y libsdl2-dev libsdl2-ttf-dev
    elif command -v yum &> /dev/null; then
        sudo yum install -y SDL2-devel SDL2_ttf-devel
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y SDL2-devel SDL2_ttf-devel
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm sdl2 sdl2_ttf
    else
        echo "WARNING: Unknown package manager. Please install SDL2 and SDL2_ttf manually."
    fi

    TARGET="x86_64-linux-gnu"
    OUTPUT_NAME="zig-calc-linux-x86_64"

elif [ "$OS_NAME" = "Darwin" ]; then
    echo "Detected macOS system"

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "ERROR: Homebrew is not installed. Please install it first."
        exit 1
    fi

    echo "Installing SDL2 dependencies..."
    brew install sdl2 sdl2_ttf

    TARGET="x86_64-macos"
    OUTPUT_NAME="zig-calc-macos-x86_64"

    # Check for Apple Silicon
    if [ "$(uname -m)" = "arm64" ]; then
        echo "Apple Silicon detected, also testing arm64 build"
        ARM64_TARGET="aarch64-macos"
        ARM64_OUTPUT_NAME="zig-calc-macos-arm64"
    fi
else
    echo "ERROR: Unsupported operating system: $OS_NAME"
    exit 1
fi

echo ""
echo "Building project for $TARGET..."
zig build -Dtarget=$TARGET -Doptimize=ReleaseSafe

if [ $? -eq 0 ]; then
    echo "Build successful!"

    # Check if executable exists
    if [ -f "zig-out/bin/zig_calc" ]; then
        echo "Executable created: zig-out/bin/zig_calc"

        # Check file size
        FILE_SIZE=$(stat -f%z "zig-out/bin/zig_calc" 2>/dev/null || stat -c%s "zig-out/bin/zig_calc")
        echo "Executable size: $((FILE_SIZE / 1024 / 1024)) MB"

        # Create test distribution
        echo "Creating test distribution..."
        mkdir -p test-dist

        cp zig-out/bin/zig_calc "test-dist/$OUTPUT_NAME"
        strip "test-dist/$OUTPUT_NAME"
        cp src/fonts/CursedTimerUlil.ttf test-dist/src/fonts/CursedTimerUlil.ttf

        echo "Test distribution created in test-dist folder"
        ls -la test-dist/

        # If macOS and Apple Silicon, also build for arm64
        if [ "$OS_NAME" = "Darwin" ] && [ -n "$ARM64_TARGET" ]; then
            echo ""
            echo "Building for Apple Silicon ($ARM64_TARGET)..."
            zig build -Dtarget=$ARM64_TARGET -Doptimize=ReleaseSafe

            if [ $? -eq 0 ] && [ -f "zig-out/bin/zig_calc" ]; then
                mkdir -p test-dist-arm64
                cp zig-out/bin/zig_calc "test-dist-arm64/$ARM64_OUTPUT_NAME"
                strip "test-dist-arm64/$ARM64_OUTPUT_NAME"
                cp src/fonts/CursedTimerUlil.ttf test-dist-arm64/src/fonts/CursedTimerUlil.ttf

                echo "Apple Silicon distribution created in test-dist-arm64 folder"
                ls -la test-dist-arm64/

                # Create universal binary
                echo "Creating universal binary..."
                mkdir -p test-dist-universal
                lipo -create -output "test-dist-universal/zig-calc-macos-universal" \
                    "test-dist/$OUTPUT_NAME" \
                    "test-dist-arm64/$ARM64_OUTPUT_NAME"
                cp src/fonts/CursedTimerUlil.ttf test-dist-universal/src/fonts/CursedTimerUlil.ttf

                echo "Universal binary created in test-dist-universal folder"
                file "test-dist-universal/zig-calc-macos-universal"
            fi
        fi
    else
        echo "ERROR: Executable not found!"
        exit 1
    fi
else
    echo "ERROR: Build failed with exit code $?"
    exit 1
fi

echo ""
echo "Test build completed successfully!"