# Test build script for Windows
# This script tests the build commands that will be used in GitHub Actions
# Requires Zig 0.16.0 or higher

Write-Host "Testing Windows build process for zig-calc"
Write-Host "=========================================="

# Download SDL2
Write-Host "Downloading SDL2 for Windows (Mingw)..."
Invoke-WebRequest -Uri "https://github.com/libsdl-org/SDL/releases/download/release-2.32.8/SDL2-devel-2.32.8-mingw.zip" -OutFile "sdl2-mingw.zip"
Expand-Archive -Path "sdl2-mingw.zip" -DestinationPath "sdl2-temp" -Force

Write-Host "Downloading SDL2_ttf for Windows (Mingw)..."
Invoke-WebRequest -Uri "https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.24.0/SDL2_ttf-devel-2.24.0-mingw.zip" -OutFile "sdl2-ttf-mingw.zip"
Expand-Archive -Path "sdl2-ttf-mingw.zip" -DestinationPath "sdl2-ttf-temp" -Force

# Create SDL2 directory structure
New-Item -ItemType Directory -Path "SDL2" -Force
New-Item -ItemType Directory -Path "SDL2/bin" -Force
New-Item -ItemType Directory -Path "SDL2/include" -Force
New-Item -ItemType Directory -Path "SDL2/lib" -Force

# Copy SDL2 files
Copy-Item -Path "sdl2-temp/x86_64-w64-mingw32/bin/SDL2.dll" -Destination "SDL2/bin/" -Force
Copy-Item -Recurse -Path "sdl2-temp/x86_64-w64-mingw32/include/*" -Destination "SDL2/include/" -Force
Copy-Item -Recurse -Path "sdl2-temp/x86_64-w64-mingw32/lib/*" -Destination "SDL2/lib/" -Force

# Copy SDL2_ttf files
Copy-Item -Path "sdl2-ttf-temp/x86_64-w64-mingw32/bin/SDL2_ttf.dll" -Destination "SDL2/bin/" -Force
Copy-Item -Recurse -Path "sdl2-ttf-temp/x86_64-w64-mingw32/include/*" -Destination "SDL2/include/" -Force
Copy-Item -Recurse -Path "sdl2-ttf-temp/x86_64-w64-mingw32/lib/*" -Destination "SDL2/lib/" -Force

# Clean up
Remove-Item -Recurse -Force "sdl2-temp", "sdl2-ttf-temp" -ErrorAction SilentlyContinue
Remove-Item -Force "sdl2-mingw.zip", "sdl2-ttf-mingw.zip" -ErrorAction SilentlyContinue

Write-Host "SDL2 setup complete!"
Write-Host ""

# Test build
Write-Host "Building project..."
zig build -Doptimize=ReleaseSafe

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful!"

    # Check if executable exists
    if (Test-Path "zig-out\bin\zig_calc.exe") {
        Write-Host "Executable created: zig-out\bin\zig_calc.exe"

        # Check file size
        $fileSize = (Get-Item "zig-out\bin\zig_calc.exe").Length
        Write-Host "Executable size: $($fileSize / 1MB) MB"

        # Create test distribution
        Write-Host "Creating test distribution..."
        New-Item -ItemType Directory -Path "test-dist" -Force

        Copy-Item -Path "zig-out\bin\zig_calc.exe" -Destination "test-dist\zig-calc.exe" -Force
        Copy-Item -Path "SDL2\bin\SDL2.dll" -Destination "test-dist\" -Force
        Copy-Item -Path "SDL2\bin\SDL2_ttf.dll" -Destination "test-dist\" -Force
        Copy-Item -Path "src\fonts\CursedTimerUlil.ttf" -Destination "test-dist\src\fonts\CursedTimerUlil.ttf" -Force

        Write-Host "Test distribution created in test-dist folder"
        Get-ChildItem -Path "test-dist"
    } else {
        Write-Host "ERROR: Executable not found!"
    }
} else {
    Write-Host "ERROR: Build failed with exit code $LASTEXITCODE"
    exit 1
}