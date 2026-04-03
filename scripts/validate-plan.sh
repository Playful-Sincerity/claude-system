#!/usr/bin/env bash
# validate-plan.sh — PostToolUse hook: structural validation of plan.md after writes.
# Fires when plan.md or plan-section-*.md is written/edited.
# Checks structure only (field completeness, file existence, basic cross-refs).
# Semantic validation (interface compatibility, conflict detection) is Step 3's job.
# Always exits 0 — informational, never blocks.

# Only run if the tool modified a plan file
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"
if ! echo "$TOOL_INPUT" | grep -qE 'plan\.md|plan-section-'; then
  exit 0
fi

# Find the project root (look for plan.md upward)
find_plan_root() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    [ -f "$dir/plan.md" ] && echo "$dir" && return 0
    dir=$(dirname "$dir")
  done
  return 1
}

PROJECT_ROOT=$(find_plan_root) || exit 0
PLAN="$PROJECT_ROOT/plan.md"
ISSUES=0
WARNINGS=""

add_warning() {
  WARNINGS="${WARNINGS}\n  - $1"
  ISSUES=$((ISSUES + 1))
}

# ─── Check 1: Meta-plan sections have corresponding plan-section files ───

# Extract section names from meta-plan (lines like "1. **Section Name** —" or "## Section: Name")
SECTIONS_IN_PLAN=$(grep -oE '\*\*[A-Z][^*]+\*\*' "$PLAN" | sed 's/\*\*//g' | head -20)

if [ -n "$SECTIONS_IN_PLAN" ]; then
  for section_file in "$PROJECT_ROOT"/plan-section-*.md; do
    [ -f "$section_file" ] && break
  done

  SECTION_FILES=$(ls "$PROJECT_ROOT"/plan-section-*.md 2>/dev/null | wc -l | tr -d ' ')
  if [ "$SECTION_FILES" = "0" ] && grep -q "## Meta-Plan" "$PLAN"; then
    add_warning "Meta-plan exists but no plan-section-*.md files found yet"
  fi
fi

# ─── Check 2: Section plan files have required contract fields ───

# Each check uses flexible patterns to match natural variations
# (e.g., "External dependencies assumed" OR "depends on" OR "Dependencies:")

for section_file in "$PROJECT_ROOT"/plan-section-*.md; do
  [ -f "$section_file" ] || continue
  basename=$(basename "$section_file")

  # Dependencies (what this section needs)
  if ! grep -qiE "dependenc|depends on|assumes.*exist|requires.*from|needs.*from" "$section_file"; then
    add_warning "$basename: no dependency declarations found"
  fi

  # Interfaces (what this section provides)
  if ! grep -qiE "interfaces? exposed|exposes|provides.*to|exports|endpoint" "$section_file"; then
    add_warning "$basename: no interface/export declarations found"
  fi

  # Technology commitments
  if ! grep -qiE "technology commit|tech stack|using.*library|framework|chose|selected" "$section_file"; then
    add_warning "$basename: no technology commitments found"
  fi

  # Breaks-if fragility conditions (the key innovation)
  if ! grep -qiE "breaks if|break.*if|invalid.*if|fails.*when|assumes.*that" "$section_file"; then
    add_warning "$basename: no 'breaks if' fragility conditions found"
  fi

  # Reasoning narrative
  if ! grep -qiE "reasoning|narrative|approach|considered|pivoted|explored|decided.*because" "$section_file"; then
    add_warning "$basename: no reasoning narrative found"
  fi
done

# ─── Check 3: plan.md has core structure ───

if [ -f "$PLAN" ]; then
  if ! grep -q "## Cross-Cutting Concerns\|## Assumptions" "$PLAN"; then
    add_warning "plan.md: missing Cross-Cutting Concerns or Assumptions section"
  fi

  if ! grep -q "## Meta-Plan\|## Goal" "$PLAN"; then
    add_warning "plan.md: missing Meta-Plan or Goal section"
  fi

  # Check for dependency graph
  if grep -q "## Meta-Plan" "$PLAN" && ! grep -qiE "depend|→|->|graph" "$PLAN"; then
    add_warning "plan.md: meta-plan exists but no dependency graph found"
  fi

  # Check for success criteria
  if grep -q "## Meta-Plan" "$PLAN" && ! grep -qi "success criteria\|success:" "$PLAN"; then
    add_warning "plan.md: meta-plan exists but no success criteria found"
  fi
fi

# ─── Check 4: Crude "breaks if" cross-reference ───
# Collect all "breaks if" conditions and check if any keywords appear in sibling tech commitments

if [ "$(ls "$PROJECT_ROOT"/plan-section-*.md 2>/dev/null | wc -l)" -gt 1 ]; then
  # Extract "breaks if" lines across all section files
  BREAKS=$(grep -hi "breaks if\|Breaks if" "$PROJECT_ROOT"/plan-section-*.md 2>/dev/null | sed 's/.*[Bb]reaks if[: ]*//')

  # Extract technology commitments
  TECH=$(grep -hi "technology commitments\|Technology commitments" "$PROJECT_ROOT"/plan-section-*.md 2>/dev/null | sed 's/.*[Tt]echnology commitments[: ]*//')

  # Very crude: check if any word in breaks-if appears in tech commitments of a different section
  # This is intentionally noisy — false positives are OK, it's a flag for human review
  if [ -n "$BREAKS" ] && [ -n "$TECH" ]; then
    POTENTIAL_CONFLICTS=$(echo "$BREAKS" | tr ' ' '\n' | grep -v '^$' | sort -u | while read -r word; do
      [ ${#word} -lt 4 ] && continue  # skip short words
      echo "$TECH" | grep -qi "$word" && echo "$word"
    done)

    if [ -n "$POTENTIAL_CONFLICTS" ]; then
      add_warning "Potential fragility overlap detected — review 'breaks if' conditions against sibling tech commitments during reconciliation"
    fi
  fi
fi

# ─── Output ───

if [ $ISSUES -gt 0 ]; then
  echo "Plan validation: $ISSUES issue(s) found"
  echo -e "$WARNINGS"
  echo "  Run Step 3 (Reconciliation) to resolve."
else
  # Only speak up if there's a plan with section files (meaning deep planning is active)
  SECTION_COUNT=$(ls "$PROJECT_ROOT"/plan-section-*.md 2>/dev/null | wc -l | tr -d ' ')
  if [ "$SECTION_COUNT" -gt 0 ]; then
    echo "Plan validation: structure OK ($SECTION_COUNT section files, all fields present)"
  fi
fi

exit 0
