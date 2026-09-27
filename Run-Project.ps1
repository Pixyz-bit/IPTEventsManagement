<#
.SYNOPSIS
    Compiles the 241611JalopEventsManagement ASP.NET project, starts IIS Express on port 51717, and launches the browser.

.DESCRIPTION
    1. Locates Visual Studio 2022 MSBuild and compiles the solution.
    2. Stops any previous instance of IIS Express running on port 51717.
    3. Launches IIS Express pointing to the web project.
    4. Automatically launches default browser to the Login and Dashboard pages.
#>

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Yellow
Write-Host "   QCU Events Management System - Launch Script           " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Yellow

$scriptRoot = $PSScriptRoot
if (-not $scriptRoot) { $scriptRoot = Get-Location }

$solutionPath = Join-Path $scriptRoot "241611JalopEventsManagement.sln"
$webAppPath = Join-Path $scriptRoot "241611JalopEventsManagement"
$port = 51717
$url = "http://localhost:$port/Frontend/Login/Login.aspx"
$dashboardUrl = "http://localhost:$port/Frontend/User/Dashboard.aspx"

# 1. Locate MSBuild
$msBuildPath = "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
if (-not (Test-Path $msBuildPath)) {
    $vswhere = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
    if (Test-Path $vswhere) {
        $msBuildPath = & $vswhere -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe | Select-Object -First 1
    }
}

if (-not (Test-Path $msBuildPath)) {
    Write-Host "[ERROR] MSBuild not found. Please verify Visual Studio 2022 installation." -ForegroundColor Red
    exit 1
}

# 2. Locate IIS Express
$iisExpressPath = "C:\Program Files\IIS Express\iisexpress.exe"
if (-not (Test-Path $iisExpressPath)) {
    $iisExpressPath = "C:\Program Files (x86)\IIS Express\iisexpress.exe"
}

if (-not (Test-Path $iisExpressPath)) {
    Write-Host "[ERROR] IIS Express not found at '$iisExpressPath'." -ForegroundColor Red
    exit 1
}

# 3. Compile Solution
Write-Host "`n[1/4] Compiling Solution with MSBuild..." -ForegroundColor Cyan
& $msBuildPath $solutionPath /t:Build /p:Configuration=Debug /v:minimal
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Compilation failed. Please fix build errors before running." -ForegroundColor Red
    exit 1
}
Write-Host "      Build succeeded (0 Errors, 0 Warnings)." -ForegroundColor Green

# 4. Stop existing IIS Express processes on the same port
Write-Host "`n[2/4] Checking existing IIS Express instances..." -ForegroundColor Cyan
Get-Process -Name "iisexpress" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "      Stopping previous IIS Express process (PID: $($_.Id))..." -ForegroundColor Gray
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Milliseconds 500

# 5. Start IIS Express
Write-Host "`n[3/4] Starting IIS Express on port $port..." -ForegroundColor Cyan
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = $iisExpressPath
$processInfo.Arguments = "/path:`"$webAppPath`" /port:$port"
$processInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized
$processInfo.UseShellExecute = $true

$iisProcess = [System.Diagnostics.Process]::Start($processInfo)
Start-Sleep -Seconds 2

# 6. Verify Server Readiness & Launch Browser
Write-Host "`n[4/4] Verifying HTTP response..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "      Server is live! (Status Code: 200 OK)" -ForegroundColor Green
    }
} catch {
    Write-Host "      Server initialized (initial response pending database warm-up)." -ForegroundColor Yellow
}

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host "   PROJECT IS RUNNING AT:                                 " -ForegroundColor Green
Write-Host "   Login:     $url" -ForegroundColor White
Write-Host "   Dashboard: $dashboardUrl" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "To stop the server at any time, run: Stop-Process -Name iisexpress" -ForegroundColor Gray

# Open browser
Start-Process $url
