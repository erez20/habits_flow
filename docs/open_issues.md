# Open Issues

Tracking gaps and deviations found while auditing the code against
`perfect_claude.md`. Two kinds of item:

- **Doc gap** — the code does something real that the doc doesn't explain, so
  the code could not be rebuilt from the doc alone. Fix = write the rule.
- **Code deviation** — the doc's rule is right; the code doesn't follow it yet.
  Fix = change the code.

Scope of this audit: `ui/`, `main/`, `core/` (domain/ and data/ not yet
reviewed).

---

## Doc gaps — app skeleton (would block a from-scratch rebuild)

These are the "how the app is assembled and boots" concerns the doc doesn't
cover. Every per-feature pattern is rebuildable; the shell is not.

---

## Doc gaps — conventions (rebuild would guess wrong)

10. **`app/` unit has no provider and no widget.**
    `AppCubit` is created directly in `main.dart` and consumed by a
    `BlocListener` there. The one-shot-signal exception covers the sealed state
    but not "this cubit skips the provider/widget files and is wired in main."

---

## Code deviations (doc is right; code is stale)

11. **`app_fonts.dart` is a dead placeholder** — only commented-out code, plus
    an unused `dart:ui` import (one of the 4 analyzer warnings).

12. **`create_habit` is over-built** — a full 4-file unit around an empty state;
    by the doc's "no state → no cubit" it shouldn't need a cubit/state (see also
    the action-only-cubit gap, #6).

13. **`all_groups_widget.dart` analyzer warnings** —
    `use_build_context_synchronously` (line ~91, missing `context.mounted` guard
    after an `await`) and deprecated `onReorder` (line ~106, replace with
    `onReorderItem`).

14. **`reorder_habit_use_case.dart`** — `prefer_initializing_formals` lint
    (uses `this._repo` assignment in the body instead of an initializing formal;
    also predates the named-parameter rule).

---

## Not yet audited

- `domain/` and `data/` — including empty use-case files
  (`add_habit_to_group_use_case.dart`, `change_habit_group_use_case.dart`,
  `remove_habit_from_group_use_case.dart`), `UnimplementedError` methods in
  `habit_repo_impl.dart` (`incHabitCount`, `resetHabitCount`), and the
  dummy-group/habit dev use cases.
- The **domain & data section of the doc** is not yet written.

---

## Resolved

Resolved items are retained here as a short audit log; remaining issue IDs stay
stable.

- **#1 Restart mechanism.** `AGENTS.md` now documents the optional, generic
  root-restart pattern: dependency reset/reconfiguration, a one-shot signal,
  and key-based root remounting.
- **#2 App root.** `AGENTS.md` now defines the dedicated root app widget as the
  owner of the long-lived router and app-wide `MaterialApp.router`
  configuration.
- **#3 Root router.** `AGENTS.md` now defines the root `RootStackRouter`, its
  `@AutoRouterConfig`, and its ownership of the root route list.
- **#4 Logging convention.** `AGENTS.md` now documents `fimber` as the logging
  dependency, logger initialization (`initLogger()`) in `core/logger/app_logger.dart`,
  and its bootstrap call in `main()` before DI.
- **#5 Provider forms.** `AGENTS.md` now documents both provider forms: standard
  `StatelessWidget` returning `BlocProvider`, and `StatefulWidget` using `BlocProvider.value`
  with `didUpdateWidget` to forward updated parent properties to the cubit.
- **#6 Action-only cubits.** `AGENTS.md` now documents cubits created solely to
  encapsulate actions without renderable state, specifying an empty single `Equatable` state structure.
- **#7 View file suffixes.** `AGENTS.md` now documents view file role suffix rules:
  `*_screen.dart` for screen 4-file units, `*_widget.dart` for widget 4-file units, and free naming for standalone helper widgets.
- **#8 Widget Variant Selectors.** `AGENTS.md` now documents grouping state-driven widget view variants and their builder/selector inside a single component directory.
- **#9 Theme & Constants.** `AGENTS.md` now documents internal conventions for `theme/` and `constants/` (static utility classes exposing tokens, palettes, and dynamic layout helpers).
