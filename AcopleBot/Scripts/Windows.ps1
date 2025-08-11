$repo = "AcopleBot" # Cambiar Repo para quien Necesite usar en otro Bot. 






$Host.UI.RawUI.WindowTitle = "Instalador $repo"
$repoUrl = "https://github.com/weskerty/$repo"
$destinoRepo = "$env:USERPROFILE\$repo"
Write-Host "Comprobando..." -ForegroundColor Yellow

# Programas Necesarios para Ejecucion
$programas = @(
    "libwebp", # Para Stickers Webp
    "git", # Para Actualizacion del Bot
    "nodejs", # Ejecutor del Bot
	#"ffmpeg", # Para Multimedia General
    "python3" # Extra para Plugins Especificos
)





foreach ($prog in $programas) {
    Write-Host "Instalando $prog..." -ForegroundColor Cyan
    winget install $prog -e --scope machine --source winget --accept-source-agreements --accept-package-agreements
}

$env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + `
            [System.Environment]::GetEnvironmentVariable("Path", "User")

if (Test-Path $destinoRepo) {
    Write-Host "$destinoRepo OK" -ForegroundColor Yellow
} else {
    git clone $repoUrl $destinoRepo
}

cd $destinoRepo
npm install
npm start
