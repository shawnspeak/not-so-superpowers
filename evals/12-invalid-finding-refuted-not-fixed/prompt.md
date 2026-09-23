---
max_turns: 50
timeout_seconds: 1500
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---
Here's the PR review feedback on the order-search change (branch `feat/order-search`). Please address it.

1. `search.py:9` — `limit` can be None when passed to the slice, which will raise a TypeError. Needs a None check.
2. `search.py:8` — the search term is interpolated straight into SQL. This is an injection hole; use a parameterized query.
3. `search.py:15` — `summarize` crashes with IndexError when `rows` is empty.
4. I'd rename `search_orders` to `find_orders`, reads better.

Work under the not-so-superpowers skills.
