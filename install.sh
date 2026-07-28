#!/usr/bin/env bash
# Установка 5 нейроагентов в Claude Code.
# Запуск:  bash install.sh

set -euo pipefail

AGENTS=(монтажер копирайтер техспец дизайнер ресерчер)
DEST="$HOME/.claude/skills"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/skills" && pwd)"

echo ""
echo "  Ставлю 5 нейроагентов в $DEST"
echo ""

mkdir -p "$DEST"

for agent in "${AGENTS[@]}"; do
  if [ ! -d "$SRC/$agent" ]; then
    echo "  ✗ $agent — папка не найдена рядом со скриптом, пропускаю"
    continue
  fi

  if [ -d "$DEST/$agent" ]; then
    backup="$DEST/$agent.backup-$(date +%Y%m%d-%H%M%S)"
    mv "$DEST/$agent" "$backup"
    echo "  ! $agent — старая версия сохранена в $(basename "$backup")"
  fi

  cp -R "$SRC/$agent" "$DEST/$agent"
  echo "  ✓ $agent"
done

echo ""
echo "  Готово. Запусти  claude  и набери / — агенты будут в списке."
echo ""

if ! command -v claude >/dev/null 2>&1; then
  echo "  Claude Code пока не установлен. Поставь его так:"
  echo "      npm install -g @anthropic-ai/claude-code"
  echo ""
fi
