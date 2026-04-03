#!/usr/bin/env bash
# setup.sh — Set up the Claude Code meta-system
#
# This script creates symlinks from ~/.claude/ to this repository,
# giving you git-tracked Claude Code configuration.
#
# Usage:
#   git clone <this-repo> ~/claude-system
#   cd ~/claude-system
#   ./setup.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Claude Code Meta-System Setup"
echo "=============================="
echo ""
echo "Repo directory: $REPO_DIR"
echo "Claude directory: $CLAUDE_DIR"
echo ""

# Ensure ~/.claude exists
mkdir -p "$CLAUDE_DIR"

# Directories to symlink
DIRS=(skills agents rules knowledge scripts)

for dir in "${DIRS[@]}"; do
  SOURCE="$REPO_DIR/$dir"
  TARGET="$CLAUDE_DIR/$dir"

  if [ ! -d "$SOURCE" ]; then
    echo "SKIP: $dir/ not found in repo"
    continue
  fi

  if [ -L "$TARGET" ]; then
    EXISTING=$(readlink "$TARGET")
    if [ "$EXISTING" = "$SOURCE" ]; then
      echo "OK:   $dir/ already linked"
      continue
    else
      echo "WARN: $dir/ symlink exists but points to $EXISTING"
      read -p "      Replace with $SOURCE? [y/N] " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm "$TARGET"
        ln -s "$SOURCE" "$TARGET"
        echo "      Updated."
      else
        echo "      Skipped."
        continue
      fi
    fi
  elif [ -d "$TARGET" ]; then
    echo "WARN: $dir/ exists as a real directory"
    echo "      Back it up first: mv $TARGET ${TARGET}.backup"
    read -p "      Move existing to ${TARGET}.backup and create symlink? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      mv "$TARGET" "${TARGET}.backup"
      ln -s "$SOURCE" "$TARGET"
      echo "      Moved and linked. Review ${TARGET}.backup for files to migrate."
    else
      echo "      Skipped."
      continue
    fi
  else
    ln -s "$SOURCE" "$TARGET"
    echo "OK:   $dir/ → linked"
  fi
done

# Create memory directory if it doesn't exist
mkdir -p "$CLAUDE_DIR/projects"

# Create chronicle directory
mkdir -p "$REPO_DIR/chronicle"

# Make scripts executable
if [ -d "$REPO_DIR/scripts" ]; then
  chmod +x "$REPO_DIR/scripts/"*.sh 2>/dev/null || true
  echo ""
  echo "Scripts marked executable."
fi

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Copy examples/settings.json.example to ~/.claude/settings.json"
echo "     (or merge the hooks into your existing settings.json)"
echo ""
echo "  2. Create your global CLAUDE.md:"
echo "     cp examples/global-CLAUDE.md.example ~/.claude/CLAUDE.md"
echo "     Then customize it with your project map."
echo ""
echo "  3. Initialize your memory system:"
echo "     mkdir -p ~/.claude/projects/-Users-\$(whoami)/memory"
echo "     cp memory/MEMORY.md ~/.claude/projects/-Users-\$(whoami)/memory/MEMORY.md"
echo ""
echo "  4. Start a Claude Code session — your rules, skills, and hooks are now active."
echo ""
echo "For the full guide, see README.md"
