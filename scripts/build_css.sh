#!/usr/bin/env bash
# Compile maia_v2's SCSS -> static/css/main.css using standalone dart-sass.
#
# main.css is a BUILD ARTIFACT (gitignored): bootstrap-overrides.scss does
# `@import "../bootstrap/scss/bootstrap"`, so we vendor Bootstrap's SCSS at
# maia_v2/static/bootstrap/scss/ (also gitignored) and compile with dart-sass
# — no Node runtime required. CI runs this before `python -m build` so the
# wheel ships a compiled main.css; you can also run it locally to preview.
#
# Versions are overridable via env: BOOTSTRAP_VERSION, DART_SASS_VERSION.
set -euo pipefail

BOOTSTRAP_VERSION="${BOOTSTRAP_VERSION:-5.3.0-alpha3}"
DART_SASS_VERSION="${DART_SASS_VERSION:-1.69.5}"

# Resolve repo root from this script's location so it works from any CWD.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
STATIC="$REPO_ROOT/maia_v2/static"

# Detect platform for the matching dart-sass release asset.
os="$(uname -s)"; arch="$(uname -m)"
case "$os" in
  Linux)  sass_os=linux  ;;
  Darwin) sass_os=macos  ;;
  *) echo "build_css: unsupported OS: $os" >&2; exit 1 ;;
esac
case "$arch" in
  x86_64|amd64)  sass_arch=x64   ;;
  arm64|aarch64) sass_arch=arm64 ;;
  *) echo "build_css: unsupported arch: $arch" >&2; exit 1 ;;
esac
sass_platform="${sass_os}-${sass_arch}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "build_css: dart-sass ${DART_SASS_VERSION} (${sass_platform}), bootstrap ${BOOTSTRAP_VERSION}"

# dart-sass (standalone binary bundle -> $tmp/dart-sass/sass)
curl -fsSL \
  "https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-${sass_platform}.tar.gz" \
  | tar -xz -C "$tmp"

# Bootstrap SCSS sources (npm tarball -> package/scss) vendored where
# bootstrap-overrides.scss expects them: maia_v2/static/bootstrap/scss/
curl -fsSL \
  "https://registry.npmjs.org/bootstrap/-/bootstrap-${BOOTSTRAP_VERSION}.tgz" \
  | tar -xz -C "$tmp"
mkdir -p "$STATIC/bootstrap" "$STATIC/css"
rm -rf "$STATIC/bootstrap/scss"
cp -r "$tmp/package/scss" "$STATIC/bootstrap/scss"

# Compile compressed, no source map.
"$tmp/dart-sass/sass" --no-source-map --style=compressed \
  "$STATIC/scss/main.scss" \
  "$STATIC/css/main.css"

test -s "$STATIC/css/main.css"
echo "build_css: wrote $STATIC/css/main.css ($(wc -c < "$STATIC/css/main.css") bytes)"
