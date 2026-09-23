#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
mkdir -p app tests
cat > app/__init__.py <<'P'
P
cat > app/config.py <<'P'
DEFAULT_TIMEOUT = 30
P
cat > app/client.py <<'P'
from app import config


def connect_timeout():
    return config.DEFAULT_TIMEOUT


def read_timeout():
    return config.DEFAULT_TIMEOUT * 2
P
cat > tests/__init__.py <<'P'
P
cat > tests/test_client.py <<'P'
import unittest

from app import client


class ClientTest(unittest.TestCase):
    def test_timeouts(self):
        self.assertEqual(client.connect_timeout(), 30)
        self.assertEqual(client.read_timeout(), 60)


if __name__ == "__main__":
    unittest.main()
P
git add -A && git commit -qm "Add client timeouts"
