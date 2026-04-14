# install-global.ps1
# Installs pestanacode.exe to %LOCALAPPDATA%\pestanacode\bin and adds it to the user PATH.
# Run from any directory — paths are resolved relative to this script.

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$exeSrc    = Join-Path $scriptDir "..\dist\opencode-windows-x64\bin\opencode.exe"
$exeSrc    = [System.IO.Path]::GetFullPath($exeSrc)

if (-not (Test-Path $exeSrc)) {
    Write-Error "Compiled exe not found at:`n  $exeSrc`n`nBuild it first:`n  bun run --cwd packages/opencode script/build-win.ts"
    exit 1
}

$installDir = "$env:LOCALAPPDATA\pestanacode\bin"
$dest       = "$installDir\pestanacode.exe"

New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Copy-Item $exeSrc $dest -Force

# Add to user PATH if not already present
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$installDir", "User")
    Write-Host "Added $installDir to your PATH."
    Write-Host "Restart your terminal for the change to take effect."
} else {
    Write-Host "PATH already contains $installDir"
}

Write-Host ""
Write-Host "Done! pestanacode installed to:"
Write-Host "  $dest"
Write-Host ""
Write-Host "After restarting your terminal, run:"
Write-Host "  pestanacode /init"
