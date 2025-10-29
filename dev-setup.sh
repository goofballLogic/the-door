set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This setup script only supports macOS (Darwin)."
  exit 1
fi

echo "== macOS LÖVE Dev Environment Check =="

MISSING=0

check() {
  local cmd="$1"
  local desc="$2"
  local install_hint="$3"

  if command -v "$cmd" >/dev/null 2>&1; then
    printf "ok %-10s found: %s\n" "$cmd" "$(command -v "$cmd")"
  else
    printf " X %-10s missing — %s\n" "$cmd" "$desc"
    echo "   → To install: $install_hint"
    echo
    MISSING=1
  fi
}

check lua "Lua interpreter (required for luarocks and tooling)" \
   "brew install lua"

check love "LÖVE runtime (required to run the game)" \
   "brew install --cask love"

check luarocks "Lua package manager (recommended)" \
   "brew install luarocks"

check luacheck "Lua linter (recommended)" \
   "luarocks install --local luacheck; export PATH=\"\$HOME/.luarocks/bin:\$PATH\""

check stylua   "Lua code formatter (recommended for development)" \
   "brew install stylua"


echo
if (( MISSING == 0 )); then
  echo "All dependencies present. You’re good to go!"
else
  echo "⚠️  Some dependencies are missing. Follow the hints above, then re-run this script."
  exit 1
fi


