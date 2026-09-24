---
type: llm
focus: last_message
---
PASS if the response is grounded in the actual code (it refers to specifics such as per-client API keys in `app/auth.py`, the `handle` entry point, or the multi-process deployment in the README) AND it either (a) asks several independent design questions together in one message, giving a recommended answer or default for most of them, or (b) presents a concrete draft design with the decisions it made on the user's behalf called out for review — a draft written to a spec file counts when the response names the file and summarizes those decisions. Comparing two or three approaches with a recommendation also counts toward (a).
FAIL if the response asks a single question and stops while other independent questions remained, asks generic questions not tied to this codebase, or starts implementing without any design agreement.
