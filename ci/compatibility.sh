#!/usr/bin/env bash
set -euo pipefail

python3 - <<'PY'
from io import BytesIO

import msgpack

# A fixed MessagePack stream containing {"x": b"abc"} followed by [1, -1].
wire = bytes.fromhex("81 a1 78 c4 03 61 62 63 92 01 ff")
records = [{"x": b"abc"}, [1, -1]]

packer = msgpack.Packer(use_bin_type=True)
assert b"".join(packer.pack(record) for record in records) == wire
assert list(msgpack.Unpacker(BytesIO(wire), read_size=2, raw=False)) == records
PY
