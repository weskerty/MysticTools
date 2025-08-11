$programas = @(
    "libwebp",
    "jq",
    "git",
    "nodejs",
    "Microsoft.Edit",
    "python3"
)

$repoUrl = "https://github.com/weskerty/AcopleBot.git"
$destinoRepo = "$env:USERPROFILE\AcopleBot"

foreach ($prog in $programas) {
    $estado = winget list --id $prog -e
    if (-not $estado) {
        Write-Host "Instalando $prog..." -ForegroundColor Cyan
        winget install $prog -e --scope machine --source winget --accept-source-agreements --accept-package-agreements
    } else {
        Write-Host "$prog ya instalado." -ForegroundColor Green
    }
}

$env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + `
            [System.Environment]::GetEnvironmentVariable("Path", "User")

if (Test-Path $destinoRepo) {
    Write-Host "Ya Clonado $destinoRepo" -ForegroundColor Yellow
} else {
    git clone $repoUrl $destinoRepo
}

cd $destinoRepo
npm install
npm start
