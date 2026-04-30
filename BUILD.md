# Building zig-calc

This document explains how to build zig-calc for different platforms.

## Prerequisites

- [Zig](https://ziglang.org/download/) 0.16.0 or higher
- SDL2 and SDL2_ttf libraries (installation instructions below)

## Quick Start

### Windows
```powershell
# Clone the repository
git clone https://github.com/AbhijitDeyDev/zig-calc.git
cd zig-calc

# Build and run
zig build run
```

### Linux
```bash
# Clone the repository
git clone https://github.com/AbhijitDeyDev/zig-calc.git
cd zig-calc

# Install SDL2 dependencies
sudo apt-get install libsdl2-dev libsdl2-ttf-dev  # Debian/Ubuntu
# OR
sudo dnf install SDL2-devel SDL2_ttf-devel        # Fedora/RHEL
# OR
sudo pacman -S sdl2 sdl2_ttf                      # Arch

# Build and run
zig build run
```

### macOS
```bash
# Clone the repository
git clone https://github.com/AbhijitDeyDev/zig-calc.git
cd zig-calc

# Install SDL2 dependencies
brew install sdl2 sdl2_ttf

# Build and run
zig build run
```

## Manual SDL2 Setup (Windows)

If you prefer to manually download SDL2 instead of letting the build script handle it:

1. Download the MinGW development packages:
   - [SDL2-devel-2.32.8-mingw.zip](https://github.com/libsdl-org/SDL/releases/download/release-2.32.8/SDL2-devel-2.32.8-mingw.zip)
   - [SDL2_ttf-devel-2.24.0-mingw.zip](https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.24.0/SDL2_ttf-devel-2.24.0-mingw.zip)

2. Extract both archives and copy the contents into a `SDL2` folder in the project root:
   - Copy `x86_64-w64-mingw32/bin/SDL2.dll` to `SDL2/bin/SDL2.dll`
   - Copy `x86_64-w64-mingw32/bin/SDL2_ttf.dll` to `SDL2/bin/SDL2_ttf.dll`
   - Copy `x86_64-w64-mingw32/include/*` to `SDL2/include/`
   - Copy `x86_64-w64-mingw32/lib/*` to `SDL2/lib/`

3. Run `zig build run`

## Build Options

### Release Builds
```bash
# Optimized for size
zig build -Doptimize=ReleaseSmall

# Optimized for speed
zig build -Doptimize=ReleaseFast

# Optimized for speed with safety checks
zig build -Doptimize=ReleaseSafe
```

### Cross-compilation
```bash
# Build for Windows from Linux/macOS
zig build -Dtarget=x86_64-windows-gnu

# Build for Linux from Windows/macOS
zig build -Dtarget=x86_64-linux-gnu

# Build for macOS from Linux/Windows
zig build -Dtarget=x86_64-macos      # Intel
zig build -Dtarget=aarch64-macos     # Apple Silicon
```

## CI/CD Builds

The project includes GitHub Actions workflows that automatically build and release executables for all platforms when you push a tag starting with 'v'.

To create a release:
```bash
# Create and push a tag
git tag v1.0.0
git push origin v1.0.0
```

This will trigger the build-and-release workflow which creates:
- Windows: `zig-calc-windows-x86_64.zip`
- Linux: `zig-calc-linux-x86_64.tar.gz`
- macOS: `zig-calc-macos-universal.tar.gz`

## Running Tests

```bash
zig build test
```

## Project Structure

- `src/main.zig` - Main application entry point
- `src/ui/` - User interface components
- `src/common/` - Common utilities and structures
- `SDL2/` - SDL2 libraries (Windows only, should not be committed)
- `build.zig` - Zig build configuration
- `build.zig.zon` - Zig package dependencies

## Troubleshooting

### Windows Build Issues
- Ensure you have the MinGW version of SDL2 libraries, not the VC version
- The DLLs must be in the same directory as the executable when running

### Linux/Mac Build Issues
- Make sure SDL2 and SDL2_ttf development packages are installed
- On some distributions, you might need `libsdl2-2.0-0` and `libsdl2-ttf-2.0-0` runtime packages

### Font Issues
- The font file `src/fonts/CursedTimerUlil.ttf` must be accessible at runtime
- In release builds, it's copied to the output directory automatically

### Zig Version Issues
- Ensure you have Zig 0.16.0 or higher
- Check with `zig version`

## License

This project is licensed under the MIT License - see the LICENSE file for details.