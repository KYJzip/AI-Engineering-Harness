
$ErrorActionPreference = "Stop"

# 1. Define paths
$repoPath = "C:\dev\AI-Engineering-Harness"
$sourceFile = Join-Path $repoPath "global\copilot-instructions.md"
$targetDir = Join-Path $HOME ".copilot"
$targetFile = Join-Path $targetDir "copilot-instructions.md"

# 2. Update repository
Write-Host "[1/3] Updating GitHub repository..."

git -C $repoPath pull --ff-only origin main

if ($LASTEXITCODE -ne 0) {
    throw "Git pull failed. Synchronization stopped."
}

# 3. Copy instructions
Write-Host "[2/3] Installing Copilot instructions..."

if (-not (Test-Path $sourceFile)) {
    throw "Source instruction file not found."
}

New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

Copy-Item -Path $sourceFile -Destination $targetFile -Force

# 4. Verify integrity
Write-Host "[3/3] Verifying SHA256 hashes..."

$sourceHash = (Get-FileHash $sourceFile -Algorithm SHA256).Hash
$targetHash = (Get-FileHash $targetFile -Algorithm SHA256).Hash

if ($sourceHash -ne $targetHash) {
    throw "Hash mismatch. Synchronization failed."
}

Write-Host "SUCCESS: Copilot Global Instructions synchronized." -ForegroundColor Green
