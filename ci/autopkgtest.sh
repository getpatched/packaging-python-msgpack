#!/usr/bin/env bash
set -euo pipefail
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
descriptors=(/originals/*.dsc)
test "${#descriptors[@]}" -eq 1
dpkg-source -x "${descriptors[0]}" "$work/source"

# Debian's python3 test imports the installed package from outside the source tree.
autopkgtest --no-auto-control --test-name=python3 --summary="$work/summary" \
  /candidate/*.deb "$work/source/" -- null
grep -Eq '^python3[[:space:]]+PASS([[:space:]]|$)' "$work/summary"
