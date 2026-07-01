param(
  [int]$Port = 8080
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$NginxDir = Join-Path $ProjectRoot ".local-server\nginx-1.30.3"
$NginxExe = Join-Path $NginxDir "nginx.exe"
$CloudflaredDir = Join-Path $ProjectRoot ".local-server\cloudflared"
$CloudflaredExe = Join-Path $CloudflaredDir "cloudflared.exe"
$TunnelOut = Join-Path $CloudflaredDir "tunnel.stdout.current.log"
$TunnelErr = Join-Path $CloudflaredDir "tunnel.stderr.current.log"

if (-not (Test-Path (Join-Path $ProjectRoot "build\web\index.html"))) {
  Write-Host "build\web not found. Run: flutter build web --release" -ForegroundColor Yellow
  exit 1
}

if (-not (Test-Path $NginxExe)) {
  Write-Host "nginx.exe not found at $NginxExe" -ForegroundColor Red
  exit 1
}

if (-not (Test-Path $CloudflaredExe)) {
  Write-Host "cloudflared.exe not found at $CloudflaredExe" -ForegroundColor Red
  exit 1
}

$nginx = Get-Process nginx -ErrorAction SilentlyContinue
if (-not $nginx) {
  Start-Process -FilePath $NginxExe -WorkingDirectory $NginxDir -WindowStyle Hidden
  Start-Sleep -Seconds 1
}

try {
  $response = Invoke-WebRequest -Uri "http://127.0.0.1:$Port" -UseBasicParsing -TimeoutSec 5
  Write-Host "Local web server: http://127.0.0.1:$Port ($($response.StatusCode))" -ForegroundColor Green
} catch {
  Write-Host "Local web server did not respond on port $Port" -ForegroundColor Red
  Write-Host $_.Exception.Message
  exit 1
}

$cloudflared = Get-Process cloudflared -ErrorAction SilentlyContinue
if (-not $cloudflared) {
  if (Test-Path $TunnelOut) { Remove-Item $TunnelOut -Force }
  if (Test-Path $TunnelErr) { Remove-Item $TunnelErr -Force }

  Start-Process `
    -FilePath $CloudflaredExe `
    -ArgumentList "tunnel --url http://127.0.0.1:$Port --no-autoupdate --protocol quic" `
    -WorkingDirectory $CloudflaredDir `
    -RedirectStandardOutput $TunnelOut `
    -RedirectStandardError $TunnelErr `
    -WindowStyle Hidden
}

$url = $null
foreach ($i in 1..30) {
  if (Test-Path $TunnelErr) {
    $match = Select-String -Path $TunnelErr -Pattern "https://[a-z0-9-]+\.trycloudflare\.com" | Select-Object -Last 1
    if ($match) {
      $url = $match.Matches[0].Value
      break
    }
  }
  Start-Sleep -Seconds 1
}

if ($url) {
  Write-Host "Public URL: $url" -ForegroundColor Green
} else {
  Write-Host "Tunnel started, but URL was not found yet. Check: $TunnelErr" -ForegroundColor Yellow
}

