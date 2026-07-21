# perfect_claude.md — habits_flow

Guidance for working in this codebase. Daily habit tracker built with Flutter,
following clean architecture with a reactive, stream-based data flow.

## Directory Structure

```
lib/
├── main.dart            # Entry point — AppRestarter (app-restart via key bump) → HabitsFlowApp
├── main/                # App bootstrap: DI setup (injection.dart + injectable config), root MaterialApp
├── core/                # Cross-cutting utilities, no business logic
│   ├── extensions/      # Dart extension helpers (e.g. color parsing on String)
│   └── logger/          # Fimber logger initialization
├── domain/              # Pure Dart business layer — NO Flutter imports
│   ├── entities/        # Equatable domain models (HabitEntity, GroupEntity)
│   ├── repos/           # Abstract repository interfaces (implemented in data/)
│   ├── responses/       # DomainResponse<T> (Success/Failure) + sealed DomainError
│   └── use_cases/
│       ├── base/        # ExecUseCase<T, Params>, StreamUseCase<T, Params>
│       ├── habit/       # One class per operation (add, edit, delete, perform, reorder…)
│       ├── group/
│       └── shared/      # Cross-entity operations (refresh_all, backup/restore)
├── data/                # Implementation layer
│   ├── db/              # Drift database: table definitions, migrations, backup helpers
│   ├── sources/         # Local data sources: interface + impl pairs per aggregate
│   │                    #   (habits/, groups/, backup/) — the only code touching drift
│   └── repos/           # Repo implementations: wrap source calls in try/catch → Failure
└── ui/                  # Presentation layer
    ├── common/          # App-level cubit, colors, fonts, constants, shared UI types
    ├── routes/          # auto_route router (app_router.dart + generated .gr.dart)
    ├── screens/         # One directory per screen (see "Screen Structure" below)
    ├── ui_models/       # Presentation models mapped from entities (fromEntity/toEntity)
    └── widgets/         # REUSABLE widgets only, one directory per widget
                         #   (joystick, drawing_layer…). Anything unique to one
                         #   screen lives under that screen instead.
```

**Dependency rule:** `ui → domain ← data`. The domain layer imports nothing from
`ui/` or `data/`. Generated files (`*.g.dart`, `*.gr.dart`, `*.config.dart`) are
never edited by hand.

## Screen Structure

A **screen** = has a route and a `Scaffold` (and usually a cubit). Each screen
gets a directory under `ui/screens/` with up to three subdirectories:

```
ui/screens/<screen_name>/
├── screen/                 # <screen_name>_screen.dart (the Scaffold), plus the
│                           #   rest of the 4-file unit if the screen has state
├── widgets/                # One directory per widget UNIQUE to this screen
│   └── <widget_name>/      #   (a 4-file unit when it owns state)
└── coordinator/            # Manager + the RepositoryProvider that scopes it.
                            # Create ONLY if screen and widgets need coordination
                            # (e.g. selection, totals, expand/collapse).
```

### The 4-File Unit

A widget or screen that owns state has a cubit — and then always all four files,
named after it (`habit_widget.dart`, `habit_cubit.dart`, …):

| File | Role |
|---|---|
| `*_widget.dart` | View only — reads the cubit, renders, no logic |
| `*_cubit.dart` | Owns the logic; deps via constructor injection; subscribes to streams in `init()`, cancels in `close()` |
| `*_state.dart` | Equatable state with `copyWith` (explicit `clearX` flags for nullable fields) |
| `*_provider.dart` | The ONLY file that touches `getIt`. Fetches deps, `context.read`s scoped ones (e.g. the manager), creates the cubit in a `BlocProvider`, wraps the widget |

A cubit is never mandatory. No state → no cubit, and the other files don't exist
either: just `*_widget.dart` (or `<screen_name>_screen.dart`). Purely
view-mechanical state (`AnimationController`, `TextEditingController`, scroll
position) uses a `StatefulWidget`, not a cubit.

**Routing:** `@RoutePage()` goes on the outermost widget of the screen's stack:
the coordinator's provider if one exists → else the screen's provider → else the
screen widget itself.

### Widget Communication Rules

For widgets under `screens/<screen_name>/widgets/`:

1. **Internal state affecting no one else → own cubit.**
2. **Affects a sibling that has its own cubit → coordinator.** Also the only
   channel that physically works: cubits cannot subscribe to each other — the
   coordinator's manager is injectable into any cubit.
3. **Affects only the father (the screen), or a sibling relying on the father's
   state → father's state.** Call `context.read<ScreenCubit>().method()` to
   affect it; watch it with `BlocBuilder` to read it.
4. **No callbacks** — the screen cubit is already the channel (rule 3).

**Precedence (rules 2 vs 3):** if any sibling cubit needs the signal, the
coordinator wins; the screen cubit subscribes to the coordinator like any other
consumer. Father state only when no sibling cubit is involved.

**Reusable widgets** (`ui/widgets/`) are the opposite regime: params in,
callbacks out, nothing else. Never `context.read` a feature's cubit, never touch
a coordinator — or the widget is no longer reusable.
