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

1. **Restart mechanism — `main.dart` `AppRestarter`.**
   The doc explains `AppCubit` (one-shot signal + `onRestart` callback) but not
   the `AppRestarter` `StatefulWidget` that wraps the tree in `ValueKey(_key)`
   and bumps the key on `AppRestarting` to force a full remount. The *how* of
   restart is undocumented.

2. **App root — `main/habits_flow_app.dart`.**
   `MaterialApp.router` wired to `_appRouter.config()`, `ThemeData` setup, and
   who instantiates `AppRouter`. The doc says main/ holds "root MaterialApp" but
   never describes its content.

3. **Router — `ui/routes/app_router.dart`.**
   `AppRouter extends RootStackRouter`, `@AutoRouterConfig`, `defaultRouteType`,
   the `routes` list. The doc covers where `@RoutePage` goes but not the root
   router class scaffold.

4. **Logging — `core/logger/app_logger.dart`.**
   `Fimber` is not in the doc's stack list. `initLogger()` (plants `DebugTree`),
   the fact `main()` calls it, and the `Fimber.d/e/i` usage throughout cubits —
   no logging convention exists in the doc.

5. **`StatefulWidget` provider variant — `group_provider.dart`.**
   Every other provider is `StatelessWidget` + `BlocProvider`. This one is a
   `StatefulWidget` that owns the cubit and forwards parent changes via
   `didUpdateWidget → cubit.updateGroup(...)`. The doc's provider description
   only covers the stateless shape.

---

## Doc gaps — conventions (rebuild would guess wrong)

6. **Action-only cubits.**
   `SideMenuCubit` and `CreateHabitCubit` expose behavior (`exportDb`,
   `addHabit`) but hold no renderable state, so their `State` classes are empty
   `Equatable` shells with a no-op `copyWith`. The doc says "cubit only when
   there's state to own" and never addresses a cubit that exists for actions,
   nor what its `State` should be.

7. **`_widget` suffix is not universal.**
   The doc says the view file is `<name>_widget.dart`, but
   `animated_color_filter.dart` (class `AnimatedColorFiltered`) and the three
   `app_bar/` files have no suffix. The apparent real rule — `_widget` for
   4-file-unit views, free naming otherwise — is unwritten.

8. **Multiple widgets in one dir — `app_bar/`.**
   Holds a builder (`habits_app_bar_builder`) that `BlocBuilder`-switches
   between two variants (`ActiveHabitsAppBar` / `HabitSelectedAppBar`). This
   breaks "one directory per widget," and the "state-driven variant selector"
   shape isn't described.

9. **Theme / constants internal conventions.**
   `AppColors` (static class: `palette` + `getMaterialColor`/`getColorValue`), a
   second class `AppColorsConst` for border colors, and `Constants` (static
   consts + a `habitSide(context)` method). The doc says *what* goes in `theme/`
   and `constants/` but not their internal form (static classes named `App*`?
   methods taking `BuildContext`? why two color classes?).

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
