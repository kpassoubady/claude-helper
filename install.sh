#!/usr/bin/env bash
set -euo pipefail

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Installable modules (add new ones here as they're created)
ALL_MODULES=(rules commands agents hooks plugins docs skills templates settings)

usage() {
  echo -e "${BOLD}Usage:${NC} ./install.sh [options] [modules...]"
  echo ""
  echo -e "${BOLD}Modules:${NC} rules commands agents hooks plugins docs skills templates settings"
  echo "  If no modules specified, all available modules are installed."
  echo ""
  echo -e "${BOLD}Options:${NC}"
  echo "  -f, --force       Overwrite existing files (default: skip)"
  echo "  -d, --dry-run     Show what would be installed without copying"
  echo "  -h, --help        Show this help message"
  echo ""
  echo -e "${BOLD}Examples:${NC}"
  echo "  ./install.sh                  # Install everything"
  echo "  ./install.sh rules            # Install only rules"
  echo "  ./install.sh rules commands   # Install rules and commands"
  echo "  ./install.sh -f rules         # Force overwrite rules"
  echo "  ./install.sh -d               # Dry run, show what would happen"
}

# Defaults
FORCE=false
DRY_RUN=false
MODULES=()

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force)  FORCE=true; shift ;;
    -d|--dry-run) DRY_RUN=true; shift ;;
    -h|--help)   usage; exit 0 ;;
    -*)          echo -e "${RED}Unknown option: $1${NC}"; usage; exit 1 ;;
    *)           MODULES+=("$1"); shift ;;
  esac
done

# If no modules specified, install all that exist in repo
if [[ ${#MODULES[@]} -eq 0 ]]; then
  for mod in "${ALL_MODULES[@]}"; do
    if [[ "$mod" == "settings" ]]; then
      [[ -d "$SCRIPT_DIR/.claude" ]] && MODULES+=("$mod")
    else
      [[ -d "$SCRIPT_DIR/$mod" ]] && MODULES+=("$mod")
    fi
  done
fi

# Validate requested modules
for mod in "${MODULES[@]}"; do
  if [[ "$mod" == "settings" ]]; then
    [[ ! -d "$SCRIPT_DIR/.claude" ]] && echo -e "${RED}Module 'settings' not found in repo. Skipping.${NC}"
  elif [[ ! -d "$SCRIPT_DIR/$mod" ]]; then
    echo -e "${RED}Module '$mod' not found in repo. Skipping.${NC}"
  fi
done

# Stats
copied=0
skipped=0
overwritten=0

install_file() {
  local src="$1"
  local dest="$2"

  # Skip .DS_Store
  [[ "$(basename "$src")" == ".DS_Store" ]] && return

  local dest_dir
  dest_dir="$(dirname "$dest")"

  if [[ -f "$dest" ]]; then
    if [[ "$FORCE" == true ]]; then
      if [[ "$DRY_RUN" == true ]]; then
        echo -e "  ${YELLOW}[overwrite]${NC} $dest"
      else
        mkdir -p "$dest_dir"
        cp "$src" "$dest"
        echo -e "  ${YELLOW}[overwrite]${NC} $dest"
      fi
      overwritten=$((overwritten + 1))
    else
      echo -e "  ${CYAN}[skip]${NC} $dest (already exists)"
      skipped=$((skipped + 1))
    fi
  else
    if [[ "$DRY_RUN" == true ]]; then
      echo -e "  ${GREEN}[copy]${NC} $dest"
    else
      mkdir -p "$dest_dir"
      cp "$src" "$dest"
      echo -e "  ${GREEN}[copy]${NC} $dest"
    fi
    copied=$((copied + 1))
  fi
}

echo ""
echo -e "${BOLD}Claude Helper Installer${NC}"
echo -e "Target: ${CYAN}$CLAUDE_HOME${NC}"
if [[ "$DRY_RUN" == true ]]; then
  echo -e "${YELLOW}(dry run - no files will be modified)${NC}"
fi
echo ""

for mod in "${MODULES[@]}"; do
  # Settings is a special module — copies .claude/ files to ~/.claude/ root
  if [[ "$mod" == "settings" ]]; then
    [[ ! -d "$SCRIPT_DIR/.claude" ]] && continue
    echo -e "${BOLD}[settings]${NC}"
    while IFS= read -r -d '' file; do
      rel_path="${file#"$SCRIPT_DIR/.claude/"}"
      dest="$CLAUDE_HOME/$rel_path"
      install_file "$file" "$dest"
    done < <(find "$SCRIPT_DIR/.claude" -type f -print0)
    echo ""
    continue
  fi

  [[ ! -d "$SCRIPT_DIR/$mod" ]] && continue

  echo -e "${BOLD}[$mod]${NC}"

  while IFS= read -r -d '' file; do
    rel_path="${file#"$SCRIPT_DIR/$mod/"}"
    dest="$CLAUDE_HOME/$mod/$rel_path"
    install_file "$file" "$dest"
  done < <(find "$SCRIPT_DIR/$mod" -type f -print0)

  echo ""
done

echo -e "${BOLD}Done.${NC} ${GREEN}$copied copied${NC}, ${CYAN}$skipped skipped${NC}, ${YELLOW}$overwritten overwritten${NC}"
