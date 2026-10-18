#!/bin/sh
# Local validation for `rfcs` (GOVERNANCE.md section 6.6).
#
# This repository commits no workflows: every check runs on the machine that made
# the change. Run from anywhere:
#
#   scripts/check.sh                  # every check
#   scripts/check.sh markdown         # only the named check
#
# Exit code: 0 every check passed, 1 one or more failed, 2 usage error.
set -eu

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

default_checks="markdown links naming reuse gitleaks"
if [ "$#" -gt 0 ]; then
  checks="$*"
else
  checks="$default_checks"
fi

builder="${BUILDER:-$(cd "$root/.." && pwd)/builder}"

failures=""
skips=""

pass() { echo "==> $1: ok"; }
fail() { echo "==> $1: FAILED" >&2; failures="$failures $1"; }
skip() { echo "==> $1: skipped ($2)"; skips="$skips $1"; }

for check in $checks; do
  case "$check" in
  markdown)
    # Every file parses as far as this check goes: the code fences are balanced, so
    # the rest of the file is not swallowed by a block that never closed.
    status=0
    for file in $(find . -name '*.md' -not -path './.git/*' | sort); do
      fences="$(grep -c '^```' "$file" || true)"
      if [ $((fences % 2)) -ne 0 ]; then
        echo "    $file: $fences code fences, an odd number" >&2
        status=1
      fi
    done
    if [ "$status" -eq 0 ]; then pass markdown; else fail markdown; fi
    ;;
  links)
    # Offline: only the links that point inside this repository are checked.
    if ! command -v lychee >/dev/null 2>&1; then
      skip links "lychee is not installed"
    elif lychee --offline --no-progress .; then
      pass links
    else
      fail links
    fi
    ;;
  naming)
    lint="$builder/target/debug/zarish-naming-lint"
    if [ ! -x "$lint" ]; then
      skip naming "build it with: cargo build -p zarish-naming-lint (in builder)"
    elif "$lint" check --repo "$root" --name rfcs \
      --config "$builder/policies/naming.toml"; then
      pass naming
    else
      fail naming
    fi
    ;;
  reuse)
    if ! command -v reuse >/dev/null 2>&1; then
      skip reuse "reuse is not installed"
    elif reuse lint; then
      pass reuse
    else
      fail reuse
    fi
    ;;
  gitleaks)
    if ! command -v gitleaks >/dev/null 2>&1; then
      skip gitleaks "gitleaks is not installed"
    elif gitleaks detect --no-git --redact --source .; then
      pass gitleaks
    else
      fail gitleaks
    fi
    ;;
  *)
    echo "unknown check: $check" >&2
    echo "known checks: $default_checks" >&2
    exit 2
    ;;
  esac
done

echo
if [ -n "$skips" ]; then
  echo "skipped:$skips"
fi
if [ -n "$failures" ]; then
  echo "failed:$failures" >&2
  exit 1
fi
echo "all checks passed"
