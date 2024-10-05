@echo off
echo Bienvenido. Si Tienes Problemas Contacta con Nosotros en bit.ly/MSOS
timeout /t 7
if exist "%USERPROFILE%\mystic\" (
    goto ejecutar
)

echo ########Analizando Paquetes Requeridos...
where git >nul 2>nul
if %errorlevel% neq 0 (
    set git_missing=1
)

where node >nul 2>nul
if %errorlevel% neq 0 (
    set nodejs_missing=1
)

where pip >nul 2>nul
if %errorlevel% neq 0 (
    set python_pip_missing=1
)

where choco >nul 2>nul
if %errorlevel% neq 0 (
    echo ########Instalando Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "& { [System.Net.ServicePointManager]::Expect100Continue = $false; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) }" -NoNewWindow -Wait
)

if defined git_missing (
    echo ########Instalando GIT...
    choco install -y git
)

if defined nodejs_missing (
    echo ########Instalando Node.js...
    choco install -y nodejs
)

if defined python_pip_missing (
    echo ########Instalando Python...
    choco install -y python312 --override --install-arguments '/quiet InstallAllUsers=1 PrependPath=1 TargetDir=C:\Python3'
)

echo ########Descargando Bot...
powershell -NoProfile -ExecutionPolicy Bypass -Command "git clone 'https://github.com/BrunoSobrino/TheMystic-Bot-MD.git' '%USERPROFILE%\mystic\'"
powershell -NoProfile -ExecutionPolicy Bypass -Command "cd '%USERPROFILE%\mystic' ; npm install"

:ejecutar
cd "%USERPROFILE%\mystic\"
echo ########Actualizando
git pull >nul 2>nul
echo ########Iniciando
npm start qr
pause