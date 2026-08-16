#!/bin/sh
# CC shim for the iQue EGCS compiler (egcs-2.91.66).
#
# Prefers a NATIVE build of the compiler and only falls back to the Linux
# container when one is not present. The native tree produces byte-identical
# .text to the container binary - it is what every permuter rig here already
# scores against - and it removes a Docker/colima dependency from an otherwise
# self-contained build.
#
# Point IQUE_EGCS_NATIVE at a directory holding gcc/cc1/cpp/as built for this
# host, or IQUE_EGCS_DIR at one holding egcs/{gcc,cc1,cpp,as} (the 32-bit Linux
# binaries) to force the container path.
set -e
NATIVE="${IQUE_EGCS_NATIVE:-$HOME/Documents/GitHub/Repo-Clones/mk64-jp/ique-toolchain/egcs-native}"
IQUE_EGCS_DIR="${IQUE_EGCS_DIR:-$HOME/Documents/GitHub/Repo-Clones/mk64-jp/ique-toolchain}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
OUT=""; PREV=""
for a in "$@"; do [ "$PREV" = "-o" ] && OUT="$a"; PREV="$a"; done

if [ -x "$NATIVE/gcc" ]; then
  COMPILER_PATH="$NATIVE" "$NATIVE/gcc" "$@"
else
  docker run --rm --platform linux/amd64 \
    -v "$IQUE_EGCS_DIR":/tc -v "$REPO":/repo -w /repo \
    -e COMPILER_PATH=/tc/egcs \
    -u "$(id -u):$(id -g)" \
    debian:bullseye-slim /tc/egcs/gcc "$@"
fi
# -mips3 objects need the o32 ABI flag or ld refuses to merge them
[ -n "$OUT" ] && python3 "$REPO/tools/set_o32abi_bit.py" "$OUT"
