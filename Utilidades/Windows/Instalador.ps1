# Bienvenida
Write-Host "Problemas? Help on Telegram @LevanterLyfe" -ForegroundColor Yellow -BackgroundColor Black

# Ubicacion del Bot
$botPath = "$HOME\levanter"
$configFile = Join-Path $botPath "config.env"

# Ejecutar el bot
function Ejecutar-Bot {
    Write-Host "######## Iniciando Bot..." -ForegroundColor Green
    Push-Location $botPath
    git pull
    npm start
    Pop-Location
    exit 0
}

# Al reabir comprobar que ya existe y saltarse
if (Test-Path $botPath) {
    Write-Host "Iniciando" -ForegroundColor Green
    Ejecutar-Bot
}

Write-Host "######## Verificando que Falta..." -ForegroundColor Cyan

# Comprobar que falta
$tools = @(
    @{ Name = "Git"; Command = "git"; InstallCommand = "choco install -y git" },
    @{ Name = "FFmpeg"; Command = "ffmpeg"; InstallCommand = "choco install -y ffmpeg-full" },
    @{ Name = "Node.js"; Command = "node"; InstallCommand = "choco install -y nodejs" },
    @{ Name = "Yarn"; Command = "yarn"; InstallCommand = "choco install -y yarn" }
)

foreach ($tool in $tools) {
    if (-not (Get-Command $tool.Command -ErrorAction SilentlyContinue)) {
        Write-Host "######## $($tool.Name) Instalando..." -ForegroundColor Yellow
        Invoke-Expression $tool.InstallCommand
    } else {
        Write-Host "######## $($tool.Name) Ya Instalado." -ForegroundColor Green
    }
}

# Comprobar Choco
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "######## Chocolatey no encontrado. Instalando..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression "& {[System.Net.ServicePointManager]::Expect100Continue = \$false; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))}"
} else {
    Write-Host "######## Chocolatey Presente" -ForegroundColor Green
}

# Actualizar variables de entorno
Write-Host "######## Actualizando Variables..." -ForegroundColor Cyan
Invoke-Expression "Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1; refreshenv"

# Clon Repo
Write-Host "######## Descargando Bot..." -ForegroundColor Cyan
if (-not (Test-Path $botPath)) {
    Start-Process -NoNewWindow -FilePath git -ArgumentList "clone https://github.com/lyfe00011/levanter.git $botPath" -Wait
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al Descargar ¿Repo Fail?"
        exit 1
    }
    
    # Descargar config.env #Podria ser una alternativa el dejar esto en example y cambiar el nombre al final.
    Write-Host "######## Descargando archivo config.env..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/config.env" -OutFile $configFile
    
    if (-not (Test-Path $configFile)) {
        Write-Error "Error al descargar config.env."
        exit 1
    }
    
    # Abrir config.env
    Write-Host "######## Configura el Bot Aqui. Abriendo config.env..." -ForegroundColor Yellow -BackgroundColor Black
    try {
        Start-Process -FilePath "notepad.exe" -ArgumentList $configFile -Wait
    } catch {
        Write-Host "######## No Notepad. Instalando Nano..." -ForegroundColor Yellow
        choco install -y nano
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Error al instalar Nano."
            exit 1
        }
        Start-Process -FilePath "nano.exe" -ArgumentList $configFile -Wait
    }
} else {
    Write-Host "######## Ya Existente" -ForegroundColor Red
}

# Instalar dependencias con Yarn/NPM
Write-Host "######## Instalando Bot..." -ForegroundColor Cyan
Push-Location $botPath
yarn install
if ($LASTEXITCODE -ne 0) {
    Write-Error "Error al Instalar con Yarn."
    exit 1
}
Pop-Location

# Esto Crea una tarea de Inicio Automatico al encender la PC. Esto evita las ventanas emergentes de ffmpeg.
$taskName = "levanterMOD"
$schtaskExists = schtasks /Query /TN $taskName 2>&1 | Select-String $taskName

if (-not $schtaskExists) {
    Write-Host "######## Creando tarea de inicio Automatico..." -ForegroundColor Cyan
    schtasks /Create /TN $taskName /TR "powershell -NoProfile -ExecutionPolicy Bypass -File $TEMP\Levanter.ps1" /SC ONSTART /RL HIGHEST /RU "SYSTEM" /F
} else {
    Write-Host "######## Tarea Existente." -ForegroundColor Green
}

# Ejecutar el bot
Ejecutar-Bot
