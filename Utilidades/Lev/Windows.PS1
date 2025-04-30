# Config
$CONFIG = @{
    # Ruta
    BotPath = "$HOME\levanter"
    
    # URL
    RepoUrl = "https://github.com/lyfe00011/levanter.git"
    ConfigEnvUrl = "https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/config.env"
    
    # Dependencias 
    RequiredTools = @(
        @{ Name = "Git"; Command = "git"; InstallCommand = "winget install git -e --accept-source-agreements --accept-package-agreements -h" },
        @{ Name = "FFmpeg"; Command = "ffmpeg"; InstallCommand = "winget install ffmpeg -e --accept-source-agreements --accept-package-agreements -h" },
        @{ Name = "Node.js"; Command = "node"; InstallCommand = "winget install nodejs -e --accept-source-agreements --accept-package-agreements -h" }
    )
    
    # Comando Bot
    StartCommands = @(
        "git pull",
        "npm start"
    )
}

# Saludo Inicio
Write-Host "¿Problemas? Help on Telegram" -ForegroundColor Yellow -BackgroundColor Black

# Variables 
$configFile = Join-Path $CONFIG.BotPath "config.env"
$scriptPath = $PSScriptRoot

function Test-CommandExists {
    param([string]$Command)
    return [bool](Get-Command -Name $Command -ErrorAction SilentlyContinue)
}

function Show-Error {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Red
    Read-Host "Presione Enter para salir"
    exit 1
}

# Ejecutar bot
function Start-LevanterBot {
    try {
        Write-Host "######## Iniciando Bot..." -ForegroundColor Green
        Push-Location $CONFIG.BotPath
        
        # Ejecutar comandos configurados
        foreach ($cmd in $CONFIG.StartCommands) {
            Write-Host "Ejecutando: $cmd" -ForegroundColor Cyan
            Invoke-Expression $cmd
            
            if ($LASTEXITCODE -ne 0) {
                Show-Error "Error ejecutando '$cmd'. Codigo de salida: $LASTEXITCODE"
            }
        }
        
        Pop-Location
    }
    catch {
        Show-Error "Error al ejecutar Bot: $_"
    }
    exit 0
}

function Confirm-WingetAvailable {
    if (-not (Test-CommandExists "winget")) {
        Show-Error "######## Winget no encontrado. Requiere Instalacion Manual."
    }
    else {
        Write-Host "######## Winget disponible" -ForegroundColor Green
    }
}

# Instalar herramientas
function Install-RequiredTools {
    foreach ($tool in $CONFIG.RequiredTools) {
        if (-not (Test-CommandExists $tool.Command)) {
            Write-Host "######## $($tool.Name) - Instalando..." -ForegroundColor Yellow
            try {
                Invoke-Expression $tool.InstallCommand
                
                if ($LASTEXITCODE -ne 0) {
                    Show-Error "Error al instalar $($tool.Name): $LASTEXITCODE"
                }
                
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
            }
            catch {
                Show-Error "Error instalando $($tool.Name): $_"
            }
        }
        else {
            Write-Host "######## $($tool.Name) ya instalado." -ForegroundColor Green
        }
    }
    
    # Instalar Yarn 
    if (-not (Test-CommandExists "yarn")) {
        Write-Host "######## Instalando Yarn via npm..." -ForegroundColor Yellow
        try {
            npm install -g yarn
            
            if ($LASTEXITCODE -ne 0) {
                Show-Error "Error al instalar Yarn: $LASTEXITCODE"
            }
            
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        }
        catch {
            Show-Error "Error instalando Yarn: $_"
        }
    }
    else {
        Write-Host "######## Yarn ya instalado." -ForegroundColor Green
    }
}

# REPO
function Clone-Repository {
    if (-not (Test-Path $CONFIG.BotPath)) {
        try {
            Write-Host "######## Descargando Bot..." -ForegroundColor Cyan
            git clone $CONFIG.RepoUrl $CONFIG.BotPath
            
            if ($LASTEXITCODE -ne 0) {
                Show-Error "Error al descargar el repo: $LASTEXITCODE"
            }
        }
        catch {
            Show-Error "Error al clonar repositorio: $_"
        }
    }
    else {
        Write-Host "######## Carpeta del Bot ya existe, actualizando..." -ForegroundColor Yellow
        try {
            Push-Location $CONFIG.BotPath
            git pull $CONFIG.RepoUrl
            if ($LASTEXITCODE -ne 0) {
                Show-Error "Error al actualizar el repo: $LASTEXITCODE"
            }
            Pop-Location
        }
        catch {
            Show-Error "Error al actualizar repositorio: $_"
        }
    }
    
    # config.env 
    if (-not (Test-Path $configFile)) {
        Write-Host "######## config.env no encontrado. Descargando..." -ForegroundColor Cyan
        try {
            Invoke-WebRequest -Uri $CONFIG.ConfigEnvUrl -OutFile $configFile -UseBasicParsing
            
            if (-not (Test-Path $configFile)) {
                Show-Error "Error al descargar config.env."
            }
            
            Write-Host "######## Se ha creado el archivo config.env en: $configFile" -ForegroundColor Yellow -BackgroundColor Black
            Write-Host "######## Puedes editar este archivo manualmente antes de iniciar el bot" -ForegroundColor Yellow
        }
        catch {
            Show-Error "Error al descargar config.env: $_"
        }
    }
}

# Instalar dependencias
function Install-Dependencies {
    try {
        Write-Host "######## Instalando dependencias del Bot..." -ForegroundColor Cyan
        Push-Location $CONFIG.BotPath
        
        Write-Host "######## Ejecutando yarn install..." -ForegroundColor Yellow
        yarn install
        
        if ($LASTEXITCODE -ne 0) {
            Show-Error "Error al instalar dependencias con Yarn. Codigo de salida: $LASTEXITCODE"
        }
        
        Pop-Location
    }
    catch {
        Show-Error "Error en Install-Dependencies: $_"
    }
}

try {
    Write-Host "######## Iniciando instalacion ########" -ForegroundColor Cyan
    
    Confirm-WingetAvailable
    Install-RequiredTools
    Clone-Repository
    Install-Dependencies
    
    # Iniciar el bot 
    Write-Host "######## Instalacion completada. Iniciando Bot..." -ForegroundColor Green
    Start-LevanterBot
}
catch {
    Show-Error "Error inesperado: $_"
}
