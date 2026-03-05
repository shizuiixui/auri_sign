param(
  [string]$DeviceId = "",
  [int]$Port = 5173,
  [int]$WebStartupTimeoutSec = 120,
  [switch]$NoFlutter
)

$ErrorActionPreference = 'Stop'

$flutterRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$webClientPath = Resolve-Path (Join-Path $flutterRoot "..\AuriSign-Web\client")

function Get-NpmPath {
  $npmCommand = Get-Command npm -ErrorAction SilentlyContinue
  if ($npmCommand) {
    return $npmCommand.Source
  }

  throw "npm not found. Install Node.js LTS and ensure npm is in PATH."
}

function Get-AdbPath {
  $sdkAdb = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
  if (Test-Path $sdkAdb) {
    return $sdkAdb
  }

  $adbCommand = Get-Command adb -ErrorAction SilentlyContinue
  if ($adbCommand) {
    return $adbCommand.Source
  }

  throw "adb not found. Install Android platform-tools or add adb to PATH."
}

$adbPath = Get-AdbPath
Write-Host "Using adb: $adbPath"

function Test-WebClientReady {
  param(
    [string]$Port
  )

  try {
    $page = Invoke-WebRequest -Uri "http://localhost:$Port/gesture-recognition" -UseBasicParsing -TimeoutSec 2
    if ($page.StatusCode -ne 200) {
      return $false
    }

    $module = Invoke-WebRequest -Uri "http://localhost:$Port/src/pages/AiGesture/GestureRecognition.jsx" -UseBasicParsing -TimeoutSec 2
    if ($module.StatusCode -ne 200) {
      return $false
    }

    if (-not ($module.Content -match "AIGesturePage")) {
      return $false
    }

    return $true
  }
  catch {
    return $false
  }
}

& $adbPath start-server | Out-Null
$devicesOutput = & $adbPath devices
Write-Host $devicesOutput

if (-not [string]::IsNullOrWhiteSpace($DeviceId)) {
  $pattern = "^$([Regex]::Escape($DeviceId))\s+device$"
  if (-not ($devicesOutput | Select-String -Pattern $pattern)) {
    throw "Device '$DeviceId' not found. Check USB/debugging and run adb devices."
  }
}

& $adbPath reverse "tcp:$Port" "tcp:$Port" | Out-Null
Write-Host "adb reverse enabled: tcp:$Port -> tcp:$Port"
& $adbPath reverse "tcp:5000" "tcp:5000" | Out-Null
Write-Host "adb reverse enabled: tcp:5000 -> tcp:5000"

$webUrl = "http://localhost:$Port/gesture-recognition"

$portReady = Test-WebClientReady -Port $Port

if (-not $portReady) {
  Write-Host "Starting web client at $webClientPath"
  $npmPath = Get-NpmPath
  $nodeModulesPath = Join-Path $webClientPath "node_modules"

  if (-not (Test-Path $nodeModulesPath)) {
    Write-Host "Installing web dependencies (first run)..."
    Push-Location $webClientPath
    try {
      & $npmPath install --no-audit --no-fund
    }
    finally {
      Pop-Location
    }
  }

  $logDir = Join-Path $flutterRoot "build\logs"
  New-Item -ItemType Directory -Force -Path $logDir | Out-Null
  $stdoutLog = Join-Path $logDir "web_client_stdout.log"
  $stderrLog = Join-Path $logDir "web_client_stderr.log"

  $webProcess = Start-Process `
    -FilePath "cmd.exe" `
    -WorkingDirectory $webClientPath `
    -ArgumentList @("/c", "npm", "run", "dev") `
    -RedirectStandardOutput $stdoutLog `
    -RedirectStandardError $stderrLog `
    -PassThru

  $maxAttempts = [Math]::Max(10, $WebStartupTimeoutSec)
  for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
    Start-Sleep -Seconds 1
    if (Test-WebClientReady -Port $Port) {
      $portReady = $true
      break
    }
  }
}

if (-not $portReady) {
  $stderrPreview = ""
  if (Test-Path $stderrLog) {
    $stderrPreview = (Get-Content $stderrLog -Tail 25) -join [Environment]::NewLine
  }

  $stdoutPreview = ""
  if (Test-Path $stdoutLog) {
    $stdoutPreview = (Get-Content $stdoutLog -Tail 25) -join [Environment]::NewLine
  }

  throw "Web client did not become reachable at $webUrl within ${WebStartupTimeoutSec}s.`nSTDERR:`n$stderrPreview`nSTDOUT:`n$stdoutPreview`nLogs: $flutterRoot\\build\\logs"
}

Write-Host "Web client ready: $webUrl"

if ($NoFlutter) {
  Write-Host "Setup complete (NoFlutter mode)."
  exit 0
}

Push-Location $flutterRoot
try {
  $flutterArgs = @("run")
  if (-not [string]::IsNullOrWhiteSpace($DeviceId)) {
    $flutterArgs += @("-d", $DeviceId)
  }
  $flutterArgs += "--dart-define=WEB_VIEWER_URL=$webUrl"

  Write-Host "Running: flutter $($flutterArgs -join ' ')"
  flutter @flutterArgs
} finally {
  Pop-Location
}
