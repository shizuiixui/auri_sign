param(
  [string]$DeviceId = "",
  [int]$Port = 5173,
  [switch]$NoFlutter
)

$ErrorActionPreference = 'Stop'

$flutterRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$webClientPath = Resolve-Path (Join-Path $flutterRoot "..\AuriSign-Web\client")

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

$webUrl = "http://localhost:$Port/gesture-recognition"

$portReady = Test-WebClientReady -Port $Port

if (-not $portReady) {
  Write-Host "Starting web client at $webClientPath"
  $webCommand = "Set-Location '$webClientPath'; npm run dev:mobile"
  Start-Process powershell -ArgumentList "-NoExit", "-Command", $webCommand | Out-Null

  $maxAttempts = 30
  for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
    Start-Sleep -Seconds 1
    if (Test-WebClientReady -Port $Port) {
      $portReady = $true
      break
    }
  }
}

if (-not $portReady) {
  throw "Web client did not become reachable at $webUrl"
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
