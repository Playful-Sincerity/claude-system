#!/bin/bash
# pdf — convert HTML or Markdown to a nicely styled PDF in one shot.
#
# Usage:
#   pdf input.html [output.pdf]      HTML file → PDF
#   pdf input.md   [output.pdf]      Markdown file → PDF
#   pdf - output.pdf < content       read from stdin (auto-detect md vs html)
#
# Env:
#   PDF_OPEN=0    don't auto-open the result (default: open on macOS)
#   PDF_ENGINE=chrome   force chrome headless instead of weasyprint (for JS-heavy pages)

set -euo pipefail

input="${1:-}"
output="${2:-}"

if [[ -z "$input" ]]; then
  echo "usage: pdf <input.{html,md}|-> [output.pdf]" >&2
  exit 1
fi

# stdin → temp file, sniff content for html vs md
if [[ "$input" == "-" ]]; then
  tmp_raw=$(mktemp -t pdfin)
  cat > "$tmp_raw"
  if grep -qiE '<html|<!doctype|<body|<head|<div|<p>' "$tmp_raw"; then
    input="${tmp_raw}.html"
  else
    input="${tmp_raw}.md"
  fi
  mv "$tmp_raw" "$input"
fi

if [[ -z "$output" ]]; then
  output="${input%.*}.pdf"
fi

ext="${input##*.}"
ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

render_html() {
  local src="$1" dst="$2"
  if [[ "${PDF_ENGINE:-}" == "chrome" ]]; then
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
      --headless --disable-gpu --no-pdf-header-footer \
      --print-to-pdf="$dst" "file://$(cd "$(dirname "$src")" && pwd)/$(basename "$src")" \
      >/dev/null 2>&1
  else
    weasyprint "$src" "$dst" 2>/dev/null
  fi
}

case "$ext_lower" in
  html|htm)
    render_html "$input" "$output"
    ;;
  md|markdown)
    # Wrap markdown in a nicely styled HTML shell, then render as HTML.
    tmp_html=$(mktemp -t pdfmd).html
    {
      cat <<'CSS'
<!doctype html><meta charset="utf-8"><style>
@page { size: letter; margin: 0.9in; }
body { font-family: -apple-system, 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #1a1a1a; line-height: 1.55; font-size: 11pt; max-width: none; }
h1 { font-size: 24pt; margin: 0 0 0.3em; letter-spacing: -0.02em; }
h2 { font-size: 15pt; margin-top: 1.6em; border-bottom: 1px solid #e4e4e4; padding-bottom: 0.25em; }
h3 { font-size: 12pt; margin-top: 1.3em; }
p, li { margin: 0.4em 0; }
blockquote { border-left: 3px solid #d0d0d0; margin: 1em 0; padding-left: 1em; color: #555; }
code { background: #f4f4f4; padding: 1px 5px; border-radius: 3px; font-size: 0.92em; }
pre { background: #f7f7f7; padding: 0.8em 1em; border-radius: 4px; overflow-x: auto; font-size: 0.9em; }
pre code { background: none; padding: 0; }
table { width: 100%; border-collapse: collapse; margin: 1em 0; }
th, td { text-align: left; padding: 0.5em 0.7em; border-bottom: 1px solid #eee; }
th { background: #fafafa; font-weight: 600; }
a { color: #0645ad; text-decoration: none; }
hr { border: none; border-top: 1px solid #e4e4e4; margin: 2em 0; }
</style>
CSS
      pandoc "$input" -f markdown -t html
    } > "$tmp_html"
    render_html "$tmp_html" "$output"
    rm -f "$tmp_html"
    ;;
  *)
    echo "pdf: unknown extension .$ext (expected html, htm, md, markdown)" >&2
    exit 1
    ;;
esac

size=$(du -h "$output" | cut -f1 | tr -d ' ')
echo "✓ $output ($size)"

if [[ "${PDF_OPEN:-1}" == "1" ]] && [[ "$(uname)" == "Darwin" ]]; then
  open "$output" 2>/dev/null || true
fi
