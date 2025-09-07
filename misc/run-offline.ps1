param(
  [int]$PausaSeg = 5          # segundos antes de lanzar el servidor
)
$Raiz = Split-Path -Parent $PSCommandPath
Set-Location $Raiz
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