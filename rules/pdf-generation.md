# PDF Generation — Use `pdf`, Don't Reinvent

When the task is "make a PDF" — from HTML, Markdown, or inline content — use the `pdf` command. Don't reach for raw `pandoc`, `weasyprint`, or Chrome headless directly unless the default isn't enough.

## The Command

`pdf` is installed at `~/bin/pdf` (symlinked to `~/claude-system/scripts/pdf.sh`). It:

- Auto-detects HTML vs Markdown by extension (or sniffs stdin content)
- Uses weasyprint by default (fast, ~0.5s); falls back to Chrome headless via `PDF_ENGINE=chrome` for JS-heavy pages
- Wraps Markdown in a clean default CSS (letter size, 0.9in margins, sensible typography, tables, code blocks, blockquotes)
- Auto-names the output (`foo.md` → `foo.pdf`) if no second arg
- Auto-opens the result on macOS (set `PDF_OPEN=0` to suppress)

## Usage

```bash
pdf input.html                     # → input.pdf, opened
pdf input.md output.pdf            # explicit output
cat <<EOF | pdf - note.pdf         # stdin, auto-detect md vs html
# My note
EOF
PDF_ENGINE=chrome pdf page.html    # for JS-rendered content
PDF_OPEN=0 pdf report.md           # don't auto-open
```

## Tool-Call Count

- File → PDF: **2 calls** (`Write` the content, then `Bash: pdf file.ext`)
- Inline → PDF: **1 call** (single `Bash` with heredoc piped to `pdf -`)

If you find yourself doing 3+ tool calls for a PDF, you're doing it wrong — re-read this rule.

## When to Bypass

Reach for the underlying tools directly only when:
- You need a specific pandoc template (academic paper, custom LaTeX)
- You need per-page headers/footers Chrome supports but weasyprint doesn't
- You're integrating into a larger pipeline where invoking a shell wrapper is awkward

In those cases, note why in a chronicle entry so future-you doesn't rewrite the wrapper.

## Don't Duplicate the Defaults

The script already has clean default CSS for Markdown. Don't wrap Markdown in your own HTML shell "to make it look nice" — run it through `pdf` first and see whether the default is enough. It usually is.
