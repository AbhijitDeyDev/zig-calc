# GitHub Actions Workflow for zig-calc

This project uses GitHub Actions to automatically build and release cross-platform executables for Windows, Linux, and macOS.

## Workflow File

The main workflow file is located at `.github/workflows/build-and-release.yml`. This workflow is triggered on:

1. **Tag pushes** (starting with 'v'): Creates a GitHub release with artifacts
2. **Pull requests to main**: Runs builds to verify they pass
3. **Manual trigger**: Can be manually triggered from the Actions tab

## Build Platforms

The workflow builds for three platforms:

### Windows (x86_64)
- Uses Windows runner with `windows-latest`
- Downloads SDL2 and SDL2_ttf MinGW development packages (SDL2 v2.32.8, SDL2_ttf v2.24.0)
- Builds with Zig v0.16.0 targeting `x86_64-windows-gnu`
- Packages executable with required DLLs and font file

### Linux (x86_64)
- Uses Ubuntu runner with `ubuntu-latest`
- Installs SDL2 and SDL2_ttf via apt package manager
- Builds with Zig v0.16.0 targeting `x86_64-linux-gnu`
- Strips debug symbols for smaller binary size

### macOS (Universal Binary)
- Uses macOS runner with `macos-latest`
- Installs SDL2 and SDL2_ttf via Homebrew
- Builds with Zig v0.16.0
- Builds separate binaries for x86_64 and arm64 (Apple Silicon)
- Creates a universal binary using `lipo` that runs on both architectures

## Artifacts

The workflow produces three artifacts:

1. **Windows**: `zig-calc-windows-x86_64.zip` containing:
   - `zig-calc.exe` (renamed from `zig_calc.exe`)
   - `SDL2.dll`
   - `SDL2_ttf.dll`
   - `CursedTimerUlil.ttf` (font file)

2. **Linux**: `zig-calc-linux-x86_64.tar.gz` containing:
   - `zig-calc-linux-x86_64` (stripped executable)
   - `CursedTimerUlil.ttf` (font file)

3. **macOS**: `zig-calc-macos-universal.tar.gz` containing:
   - `zig-calc-macos-universal` (universal binary for Intel and Apple Silicon)
   - `CursedTimerUlil.ttf` (font file)

## Release Creation

When a tag starting with 'v' is pushed (e.g., `v1.0.0`), the workflow:
1. Builds for all three platforms
2. Packages the artifacts
3. Creates a GitHub release with all three packages attached
4. Automatically generates release notes

## Manual Testing

You can test the build process locally using the provided scripts:

### Windows
```powershell
powershell -ExecutionPolicy Bypass -File test-build.ps1
```

### Linux/macOS
```bash
chmod +x test-build.sh
./test-build.sh
```

## Requirements

- Zig 0.16.0 or higher
- SDL2 and SDL2_ttf libraries (handled automatically in CI)

## Notes

- The font file `CursedTimerUlil.ttf` is included in all distributions as it's required for the application to run correctly
- On Windows, the SDL2 DLLs must be in the same directory as the executable
- On Linux/macOS, SDL2 libraries are installed system-wide via package manager