#!/usr/bin/env bash
set -euo pipefail
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
descriptors=(/originals/*.dsc)
test "${#descriptors[@]}" -eq 1
dpkg-source -x "${descriptors[0]}" "$work/source"

# The null testbed already has the exact candidate installed. Passing a .deb here
# would register a temporary APT repository whose teardown needs network access.
candidate=(/candidate/python3-msgpack_*.deb)
test "${#candidate[@]}" -eq 1
version=$(dpkg-deb -f "${candidate[0]}" Version)
test "$(dpkg-query -W -f='${Version}' python3-msgpack)" = "$version"
status=0
autopkgtest --no-auto-control --no-built-binaries --test-name=python3 \
  --summary=/reports/autopkgtest-summary.txt \
  "$work/source/" -- null || status=$?
# Debian returns 8 when the only executed test is marked superficial.
case "$status" in
  0) grep -Eq '^python3[[:space:]]+PASS([[:space:]]|$)' /reports/autopkgtest-summary.txt ;;
  8) grep -Eq '^python3[[:space:]]+PASS[[:space:]]+\(superficial\)$' /reports/autopkgtest-summary.txt ;;
  *) exit "$status" ;;
esac
test "$(dpkg-query -W -f='${Version}' python3-msgpack)" = "$version"
