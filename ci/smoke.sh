#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import msgpack

record = {"numbers": [1, 2, 3], "data": b"GetPatched"}
assert msgpack.unpackb(msgpack.packb(record, use_bin_type=True), raw=False) == record
PY
