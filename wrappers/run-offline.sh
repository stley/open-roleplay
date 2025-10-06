# ---- Run server (wrapper) ----
#!/bin/sh
set -eu

DIR="$(cd -- "$(dirname "$0")" && pwd)"
# Prepend both libs/ and lib32/ to the library search path
export LD_LIBRARY_PATH="$DIR/libs:$DIR/lib32:${LD_LIBRARY_PATH-}"

echo "Esperando 5 segundos antes de lanzar el servidor..."
sleep 5

exec "$DIR/omp-server" "$@"