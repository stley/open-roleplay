# Uso:
#   .\run-nightly.ps1                    â†’ usa "nightly-main" por defecto
#   .\run-nightly.ps1 -Nombre nightly-X  â†’ artefacto alternativo
# Requiere: $env:PAT o $env:GITHUB_TOKEN con alcance repo

param(
  [string]$Nombre = "nightly-main",
  [string]$Owner  = "stley",
  [string]$Repo   = "open-roleplay",
  [int]$PausaSeg  = 5            # segundos antes de lanzar el servidor
)
$env:PAT = ''
$ErrorActionPreference = 'Stop'
$Token = $env:GITHUB_TOKEN; if (-not $Token) { $Token = $env:PAT }
if (-not $Token) { throw "Defina PAT o GITHUB_TOKEN (alcance: repo)." }

$Raiz = Split-Path -Parent $PSCommandPath
Set-Location $Raiz
$Headers = @{ Authorization = "Bearer $Token"; "User-Agent"="gh-actions-fetch" }
$API = "https://api.github.com/repos/$Owner/$Repo/actions/artifacts?per_page=100"

# Obtener URL del artefacto nightly
$resp = Invoke-RestMethod -Headers $Headers -Uri $API
$Descarga = ($resp.artifacts |
  Where-Object { $_.name -eq $Nombre -and $_.expired -eq $false } |
  Sort-Object {[datetime]$_.created_at} -Descending |
  Select-Object -First 1).archive_download_url
if (-not $Descarga) { throw "Artefacto '$Nombre' no encontrado o expirado." }

# Descargar y descomprimir
$Tmp = New-Item -ItemType Directory -Path (Join-Path $env:TEMP ("amx_" + [guid]::NewGuid())) -Force
$Zip = Join-Path $Tmp "artifact.zip"
Invoke-WebRequest -Headers $Headers -Uri $Descarga -OutFile $Zip -UseBasicParsing
$Unz = Join-Path $Tmp "unz"
Expand-Archive -Path $Zip -DestinationPath $Unz -Force

# Localizar e instalar main.amx
$Amx = Get-ChildItem -Path $Unz -Recurse -File -Include main.amx | Select-Object -First 1
if (-not $Amx) { throw "main.amx no encontrado dentro del artefacto." }

$Gm = Join-Path $Raiz "gamemodes"
New-Item -ItemType Directory -Path $Gm -Force | Out-Null
Get-ChildItem $Gm -Filter *.amx -File | Remove-Item -Force -ErrorAction SilentlyContinue
Copy-Item $Amx.FullName (Join-Path $Gm "main.amx") -Force
Write-Host "Instalado gamemodes\main.amx desde '$Nombre'."

# $unz = path raíz del unzip; $Raiz = carpeta del server
if (Test-Path "$unz\dist\plugins") {
  robocopy "$unz\dist\plugins" "$Raiz\plugins" *.* /S > $null
}
if (Test-Path "$unz\dist\components") {
  robocopy "$unz\dist\components" "$Raiz\components" *.* /S > $null
}
Write-Host "Plugins y components instalados desde el artefacto (si existían)."

# Lanzar servidor tras breve pausa
$Exe = Join-Path $Raiz "omp-server.exe"
if (Test-Path $Exe) {
  # Asocia las DLL en libs\
  $env:PATH = "$Raiz\libs;$env:PATH"

  Write-Host "Lanzando servidor en $PausaSeg segundo(s)..."
  Start-Sleep -Seconds $PausaSeg
  & $Exe @args
} else {
  Write-Warning "omp-server.exe no encontrado en $Raiz. EjecuciÃ³n omitida."
}