#!/usr/bin/env bash
set -euo pipefail

# Exercise the upstream suite with the pure-Python implementation forced.
export MSGPACK_PUREPYTHON=1
python3 -m pytest test
