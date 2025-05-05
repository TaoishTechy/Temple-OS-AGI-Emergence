#!/usr/bin/env bash
set -euo pipefail

OPT_TEST=false
OPT_STRIP=false
OPT_DEBUG=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --test)  OPT_TEST=true  ;;
    --strip) OPT_STRIP=true ;;
    --debug) OPT_DEBUG=true ;;
  esac; shift
done

echo ">>> Compiling Temple‑OS AGI…"
mkdir -p build dist log

# Compile kernel + CLI into flat binary
toscc -I include -o build/OpenAI.bin src/cli/TempleCLI.HC

# Package ISO
xorriso -as mkisofs -R -J -o dist/OpenAI.iso build/OpenAI.bin

[[ $OPT_STRIP == true ]] && strip build/OpenAI.bin
[[ $OPT_TEST  == false ]] && exit 0

echo ">>> Running smoke‑test in QEMU…"
qemu-system-x86_64 -nographic -m 256M \
     -drive file=dist/OpenAI.iso,media=cdrom,format=raw \
     -serial mon:stdio -snapshot \
     -no-reboot -d int > log/serial.txt 2>&1 || EXIT=$?
echo "Log written to log/serial.txt"
exit ${EXIT:-0}
