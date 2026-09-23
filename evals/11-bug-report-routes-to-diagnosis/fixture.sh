#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
mkdir -p app tests
touch app/__init__.py tests/__init__.py
cat > app/profiles.py <<'P'
PROFILES = {
    "ana": {"name": "Ana", "email": "ana@example.com"},
    "bo": {"name": "Bo", "email": None},
}


def fetch_profile(user_id):
    return PROFILES.get(user_id)
P
cat > app/cache.py <<'P'
from app import profiles

_CACHE = {}


def get_profile(user_id):
    if user_id not in _CACHE:
        profile = profiles.fetch_profile(user_id)
        # store a compact entry: drop empty fields
        _CACHE[user_id] = {k: v for k, v in profile.items() if v}
    return _CACHE[user_id]
P
cat > app/handler.py <<'P'
from app import cache


def contact_card(user_id):
    profile = cache.get_profile(user_id)
    return f"{profile['name']} <{profile['email']}>"
P
cat > tests/test_handler.py <<'P'
import unittest

from app.handler import contact_card


class HandlerTest(unittest.TestCase):
    def test_contact_card(self):
        self.assertEqual(contact_card("ana"), "Ana <ana@example.com>")
P
git add -A && git commit -qm "Contact cards"
