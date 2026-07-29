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



---

## Code deviations (doc is right; code is stale)

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
- **#10 Root App Cubit Wiring.** `AGENTS.md` now documents that app-root cubits (`ui/app/`) omit provider and view files because they are created and listened to directly at the composition root in `main.dart`.
- **#11 `app_fonts.dart` cleanup.** Removed unused `dart:ui` import and commented-out placeholder code from `app_fonts.dart`.
- **#12 `create_habit` unit.** Verified compliance with the Action-Only Cubit pattern documented in #6.
- **#13 `all_groups_widget.dart` warnings.** Added `mounted` check after `Future.delayed` to prevent `use_build_context_synchronously` warning.
