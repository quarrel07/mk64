#!/bin/sh
# CC shim for the iQue EGCS compiler (egcs-2.91.66, 32-bit Linux binaries).
# Runs it in a Linux container; relative paths work because the repo root is
# mounted and used as the working directory. Point IQUE_EGCS_DIR at a
# directory holding egcs/{gcc,cc1,cpp,as} (sm64's tools/ique_egcs binaries).
set -e
IQUE_EGCS_DIR="${IQUE_EGCS_DIR:-$HOME/Documents/GitHub/Repo-Clones/mk64-jp/ique-toolchain}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
OUT=""; PREV=""
for a in "$@"; do [ "$PREV" = "-o" ] && OUT="$a"; PREV="$a"; done
docker run --rm --platform linux/amd64 \
  -v "$IQUE_EGCS_DIR":/tc -v "$REPO":/repo -w /repo \
  -e COMPILER_PATH=/tc/egcs \
  -u "$(id -u):$(id -g)" \
  debian:bullseye-slim /tc/egcs/gcc "$@"
# -mips3 objects need the o32 ABI flag or ld refuses to merge them
[ -n "$OUT" ] && python3 "$REPO/tools/set_o32abi_bit.py" "$OUT"
