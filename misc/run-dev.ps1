# Uso:
#   .\run-dev.ps1                ? pregunta PR; vacío = build de PR más reciente
#   .\run-dev.ps1 -Pr 123        ? usa PR #123
# Requiere: $env:PAT o $env:GITHUB_TOKEN con alcance repo

param(
  [int]$Pr = -1,
  [string]$Owner = "stley",
  [string]$Repo  = "open-roleplay",
  [int]$PausaSeg = 5          # segundos antes de lanzar el servidor
)
$env:PAT = ''
$ErrorActionPreference = 'Stop'
$Token = $env:GITHUB_TOKEN; if (-not $Token) { $Token = $env:PAT }
if (-not $Token) { throw "Defina PAT o GITHUB_TOKEN (alcance: repo)." }

# Si no viene PR, preguntar y permitir vacío
if ($Pr -lt 0) {
  $entrada = Read-Host "Ingrese número de PR (deje vacío para el más reciente)"
  if ($entrada -match '^\d+$') { $Pr = [int]$entrada }
}

$Raiz = Split-Path -Parent $PSCommandPath
Set-Location $Raiz
$Headers = @{ Authorization = "Bearer $Token"; "User-Agent"="gh-actions-fetch" }
$API = "https://api.github.com/repos/$Owner/$Repo/actions/artifacts?per_page=100"

# Resolver artefacto
if ($Pr -ge 0) {
  $NombreArtefacto = "dev-pr-$Pr"
  Write-Host "Buscando artefacto para PR #$Pr..."
} else {
  Write-Host "Sin PR. Buscando artefacto dev más reciente..."
  $resp = Invoke-RestMethod -Headers $Headers -Uri $API
  $NombreArtefacto = ($resp.artifacts |
    Where-Object { $_.name -like 'dev-pr-*' -and $_.expired -eq $false } |
    Sort-Object {[datetime]$_.created_at} -Descending |
    Select-Object -First 1).name
  if (-not $NombreArtefacto) { throw "No se encontró artefacto dev-pr-* no expirado." }
}

# Obtener URL de descarga
$resp = Invoke-RestMethod -Headers $Headers -Uri $API
$Descarga = ($resp.artifacts |
  Where-Object { $_.name -eq $NombreArtefacto -and $_.expired -eq $false } |
  Select-Object -First 1).archive_download_url
if (-not $Descarga) { throw "Artefacto '$NombreArtefacto' no encontrado o expirado." }

# Descargar y descomprimir
$Tmp = New-Item -ItemType Directory -Path (Join-Path $env:TEMP ("amx_" + [guid]::NewGuid())) -Force
$Zip = Join-Path $Tmp "artifact.zip"
Invoke-WebRequest -Headers $Headers -Uri $Descarga -OutFile $Zip -UseBasicParsing
$Unz = Join-Path $Tmp "unz"
Expand-Archive -Path $Zip -DestinationPath $Unz -Force

# Localizar main.amx (raíz o dist\)
$Amx = Get-ChildItem -Path $Unz -Recurse -File -Include main.amx | Select-Object -First 1
if (-not $Amx) { throw "main.amx no encontrado dentro del artefacto." }

# Instalar en gamemodes\
$Gm = Join-Path $Raiz "gamemodes"
New-Item -ItemType Directory -Path $Gm -Force | Out-Null
Get-ChildItem $Gm -Filter *.amx -File | Remove-Item -Force -ErrorAction SilentlyContinue
Copy-Item $Amx.FullName (Join-Path $Gm "main.amx") -Force
Write-Host "Instalado gamemodes\main.amx desde '$NombreArtefacto'."

# Lanzar servidor tras breve pausa
$Exe = Join-Path $Raiz "omp-server.exe"
if (Test-Path $Exe) {
  # Asocia las DLL en libs\
  $env:PATH = "$Raiz\libs;$env:PATH"

  Write-Host "Lanzando servidor en $PausaSeg segundo(s)..."
  Start-Sleep -Seconds $PausaSeg
  & $Exe @args
} else {
  Write-Warning "omp-server.exe no encontrado en $Raiz. Ejecución omitida."
}