# GetPatched recipe: python-msgpack

This repository describes target-specific Debian backports for the `python-msgpack` source package. It does not fork or copy the upstream project. The build fetches Debian's pinned source archives, retains Debian packaging, applies the patch listed for that target, and builds the distribution's `python3-msgpack` binary.

## Security patch

| CVE | Patch | Affected behavior | Status |
|---|---|---|---|
| [CVE-2026-57585](https://security-tracker.debian.org/tracker/CVE-2026-57585) | [`CVE-2026-57585.patch`](patches/CVE-2026-57585.patch) | A streaming `Unpacker` can crash with SIGSEGV if reused after an unpacking error was caught. | Development candidate; no binary published |

The backport follows upstream commit [`2c56ddb`](https://github.com/msgpack/msgpack-python/commit/2c56ddb5d0025ed481d962c0f5d62d19dec7476d), adapted to Debian's older 1.0.3 parser implementation. It clears pending map keys and partially built objects, resets parser state after decoding errors, and prevents a stale map-key pointer from being released twice. The regression fixture first confirms malformed input is rejected, then calls `skip()` on the same errored `Unpacker`. Debian's pinned baseline exits with SIGSEGV; the patched build must complete without a process crash. The upstream advisory notes that applications should discard an `Unpacker` after any error; the patch prevents the crash and does not make reuse after malformed input a supported workflow.

## Supported targets

| Distribution | Source version | GetPatched version | Binary | Architecture | Release policy |
|---|---|---|---|---|---|
| Debian 12 Bookworm | `1.0.3-2` | `1.0.3-2+getpatched1` | `python3-msgpack` | amd64 | Public after verification |
| Debian 13 Trixie | `1.0.3-3` | `1.0.3-3+getpatched1` | `python3-msgpack` | amd64 | Public after verification |

The Debian Security Tracker currently lists both source versions as vulnerable. Each target is pinned independently in [`targets/debian/`](targets/debian/), including its Debian snapshot, source descriptor, archive hashes, binary scope, and release version. A target recipe never implies support for another Debian release, architecture, or source version.

## Build and verification

The GetPatched platform workflow builds each declared target from its pinned source archives, installs the candidate package in the target image, runs the baseline and patched regression, compares package-aware scan results, and retains verification reports. Both targets are configured for public release only after these checks pass. The current recipes are development candidates; passing a local test alone does not constitute release approval, and no binaries have been published.

## Repository layout

- `package-manifest.json` indexes the package and its target recipes.
- `targets/debian/*.json` records exact Debian source pins and target-specific build policy.
- `patches/CVE-2026-57585.patch` contains the GetPatched backport.
- `patches/metadata.json` records upstream provenance, applicability, and test expectations.
- `tests/fixtures/` contains the bounded installed-package regression input.
- `LICENSES/` preserves upstream and Debian notices.

GetPatched-authored recipe files and patches are MIT licensed. The upstream source and Debian packaging remain under their respective licenses; see `LICENSES/` and the source package notices.
