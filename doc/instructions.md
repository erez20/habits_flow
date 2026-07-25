# Project Continuation Instructions

The user is actively shaping this project and likes the existing code. Preserve
its design; prefer the smallest change that addresses an agreed problem.

## Current goal

Refine `AGENTS.md` one item at a time using `docs/open_issues.md` as the audit
backlog. The guide is intended to transfer cleanly to other Flutter projects
that use the same architectural stack, so its examples must remain generic.

Start every new work session by reading:

1. `AGENTS.md`
2. `docs/open_issues.md`
3. `git status --short`
4. The code directly relevant to the issue being discussed

For this initiative, work only in `ui/`, `main/`, and `core/`. Do not review or
change `domain/`, `data/`, or `examples/` unless the user explicitly expands
the scope.

## Collaboration rules

- Never edit code or documentation without the user's explicit approval.
- First explain the issue, recommend the smallest resolution, and list the
  exact files that would change. Then wait for approval.
- Do not refactor, format broadly, or fix unrelated issues while addressing an
  approved item.
- After resolving an audit item, update both `AGENTS.md` and
  `docs/open_issues.md`. Move the issue to the resolved audit log without
  renumbering the remaining issue IDs.
- Keep `AGENTS.md` implementation-ready but portable: use placeholders such as
  `<Feature>`, `<Item>`, and `<App>` instead of this app's domain names.
- Keep the required-stack package list in `AGENTS.md` aligned whenever the
  guide adds or removes an architectural dependency. `pubspec.yaml` owns exact
  versions.

## Current position

Issues #1–#3 are resolved. The next item is #4, the logging convention. Assess
it and ask for approval before changing anything.

## Verification and handoff

- For documentation-only edits, run `git diff --check`.
- For code changes, run only the relevant formatter, analysis, generation, or
  tests described in `AGENTS.md`; report only commands that actually ran.
- Preserve existing user changes in the working tree and report exactly what
  changed.
