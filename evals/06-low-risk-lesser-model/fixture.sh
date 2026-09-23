#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
mkdir -p core docs/specs
touch core/__init__.py
cat > core/dates.py <<'P'
def format_date(d, style="iso"):
    return d.isoformat() if style == "iso" else d.strftime("%d/%m/%Y")
P
i=0
for mod in orders invoices shipping returns payroll audit exports reminders; do
  mkdir -p "$mod"; touch "$mod/__init__.py"
  i=$((i+1))
  if [ $((i % 2)) -eq 0 ]; then
    printf 'from core.dates import format_date\n\n\ndef label(record):\n    return "%s " + format_date(record["when"], style="uk")\n' "$mod" > "$mod/view.py"
  else
    printf 'from core.dates import format_date\n\n\ndef label(record):\n    return "%s " + format_date(record["when"])\n' "$mod" > "$mod/view.py"
  fi
done
cat > docs/specs/2026-09-04-date-locale.md <<'P'
# Locale-aware dates

## Contract

**Decisions.** `format_date(d, style="iso")` becomes `format_date(d, locale)`:
the `style` keyword is removed and `locale` is required.

**Acceptance criteria.** Every caller passes a locale.
P
git add -A && git commit -qm "Date formatting callers and locale spec"
