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
    ├── screens/         # One directory per screen (see "Screen structure" below)
    ├── ui_models/       # Presentation models mapped from entities (fromEntity/toEntity)
    └── widgets/         # REUSABLE widgets only, one directory per widget
                         #   (joystick, drawing_layer, animated_color_filter…).
                         #   Anything unique to one screen belongs under that
                         #   screen's widgets/ instead.
```

**Dependency rule:** `ui → domain ← data`. The domain layer imports nothing from
`ui/` or `data/`; `data/` and `ui/` depend on `domain/` abstractions. Generated
files (`*.g.dart`, `*.gr.dart`, `*.config.dart`) are never edited by hand.

## Screen Structure

A **screen** is something that has a route and a `Scaffold` (and usually a cubit).
Each screen gets its own directory under `ui/screens/`, containing up to three
subdirectories:

```
ui/screens/<screen_name>/
├── screen/                 # The screen itself (files keep the full name):
│                           #   <screen_name>_screen.dart          — widget with the Scaffold
│                           # And ONLY if the screen has state (usual, not required):
│                           #   <screen_name>_screen_cubit.dart    — screen-level state owner
│                           #   <screen_name>_screen_state.dart    — Equatable state + copyWith
│                           #   <screen_name>_screen_provider.dart — does the DI, creates the cubit
├── widgets/                # One directory per widget, UNIQUE to this screen.
│   └── <widget_name>/      # Widgets may listen to the screen's state and have
│                           #   their own cubit/state/provider (same 4-file unit
│                           #   as the screen). Communication rules below.
└── coordinator/            # The manager + the RepositoryProvider that scopes it.
                            # Create ONLY if the screen and its widgets need to
                            # coordinate (e.g. selection, totals, expand/collapse).
```

### The 4-File Unit

Any widget (or screen) that has a cubit always has all four files:

| File | Role |
|---|---|
| `<name>_widget.dart` | View only — reads the cubit, renders, no logic |
| `<name>_cubit.dart` | Owns the logic; deps via constructor injection; subscribes to streams in `init()`, cancels them in `close()` |
| `<name>_state.dart` | Equatable state with `copyWith` (use explicit `clearX` flags for nullable fields) |
| `<name>_provider.dart` | The ONLY file that touches `getIt` — fetches the use cases / deps the widget and cubit need (plus `context.read` for scoped deps like the coordinator's manager), constructs the cubit in a `BlocProvider`, and wraps the widget |

`getIt` never appears in a widget or a cubit. If there's no cubit, none of the
other files exist either — a stateless widget is a single `*_widget.dart`, and a
stateless screen is a single `<screen_name>_screen.dart`. A cubit is never
mandatory; add one only when there is state to own.

**Routing:** `@RoutePage()` goes on the outermost widget of the screen's stack —
the coordinator's provider when a coordinator exists (nesting:
`coordinator provider → screen provider → screen`), then the screen's provider,
and for a stateless screen (no provider at all) the screen widget itself. The
route entry point is always where scoping begins.

### Widget State & Communication Rules

For widgets under `screens/<screen_name>/widgets/`:

1. **Internal state that affects no one else → own cubit** (with its own state +
   provider, same 4-file unit). A widget with no state of its own is a single
   `*_widget.dart` file — no cubit/state/provider. Purely view-mechanical state
   (`AnimationController`, `TextEditingController`, scroll position) uses a
   `StatefulWidget`, not a cubit.
2. **Affects a sibling that has its own cubit → coordinator.** This is also the
   only channel that physically works: cubits cannot subscribe to each other
   (no DI path between them) — the coordinator's manager is injectable into any
   cubit.
3. **Affects only the father (the screen), or a sibling that relies on the
   father's state → father's state.** The widget calls
   `context.read<ScreenCubit>().method()` to affect it, and watches it with
   `BlocBuilder` to read it.
4. **No callbacks.** Screen-unique widgets are coupled to their screen by
   definition, so they talk to the screen cubit directly (rule 3). Passing
   callbacks down is redundant indirection.

**Precedence when rules 2 and 3 overlap** (a signal the father renders AND a
sibling cubit reacts to, e.g. habit selection): the coordinator wins. The screen
cubit subscribes to the coordinator like any other consumer and mirrors what it
needs into its own state. Father state is the channel only when no sibling cubit
is involved.

**Corollary for reusable widgets** (in `ui/widgets/`): the opposite regime —
data flows IN through constructor params, events flow OUT through callbacks,
and nothing else. If a reusable widget needs to communicate, it always gets a
callback. It never `context.read`s another feature's cubit and never touches a
coordinator, or it would no longer be reusable.
