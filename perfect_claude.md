# perfect_claude.md

Guidance for working in this codebase: a Flutter app following clean
architecture with a reactive, stream-based data flow. Stack: flutter_bloc
(cubits), get_it + injectable (DI), auto_route (navigation), drift (SQLite),
rxdart (subjects & stream composition).

## Directory Structure

```
lib/
├── main.dart            # Entry point → root app widget
├── main/                # App bootstrap: DI setup (injection.dart + injectable config), root MaterialApp
├── core/                # Cross-cutting utilities, no business logic
│   ├── extensions/      # Dart extension helpers
│   └── logger/          # Logger initialization
├── domain/              # Pure Dart business layer — NO Flutter imports
│   ├── entities/        # Equatable domain models
│   ├── repos/           # Abstract repository interfaces (implemented in data/)
│   ├── responses/       # DomainResponse<T> (Success/Failure) + sealed DomainError
│   └── use_cases/
│       ├── base/        # ExecUseCase<T, Params>, StreamUseCase<T, Params>
│       ├── <aggregate>/ # One directory per aggregate; one class per operation
│       │                #   (add, edit, delete, reorder…)
│       └── shared/      # Cross-aggregate operations
├── data/                # Implementation layer
│   ├── db/              # Drift database: table definitions, migrations
│   ├── sources/         # Local data sources: interface + impl pair per
│   │                    #   aggregate — the only code touching drift
│   └── repos/           # Repo implementations: wrap source calls in try/catch → Failure
└── ui/                  # Presentation layer
    ├── common/          # App-level cubit, colors, fonts, constants, shared UI types
    ├── routes/          # auto_route router (app_router.dart + generated .gr.dart)
    ├── screens/         # One directory per screen (see "Screen Structure" below)
    ├── ui_models/       # UI models: <X>UI classes in *_ui.dart (see "UI Models")
    └── widgets/         # REUSABLE widgets only, one directory per widget.
                         #   Anything unique to one screen lives under that
                         #   screen instead.
```

**Dependency rule:** `ui → domain ← data`. The domain layer imports nothing from
`ui/` or `data/`. Generated files (`*.g.dart`, `*.gr.dart`, `*.config.dart`) are
never edited by hand.

## Dependency Injection (get_it + injectable)

Setup lives in `main/injection.dart`; the registrations are generated into
`injection.config.dart` from annotations:

```dart
final getIt = GetIt.instance;

@InjectableInit(initializerName: 'init', preferRelativeImports: false, asExtension: true)
void configureDependencies() => getIt.init();
```

`main()` calls `configureDependencies()` before `runApp`. After adding or
changing any annotation, run
`dart run build_runner build --delete-conflicting-outputs`.

**What gets registered, and how:**

| Kind | Annotation | Lifetime |
|---|---|---|
| Database | `@singleton` | One instance, app lifetime |
| Repositories | `@LazySingleton(as: <DomainInterface>)` | One instance, created on first use |
| Data sources | `@LazySingleton(as: <SourceInterface>)` | One instance — sources hold state (refresh subjects) |
| Use cases | `@injectable` | Factory — stateless and cheap, new instance per request |
| Coordinators | `@Injectable(as: <Interface>)` | Factory — fresh instance per screen/flow scope; lifecycle owned by the scoping `RepositoryProvider`, not by getIt |

Registration is always against the abstraction (`as:` the domain interface);
consumers depend on the interface, never the impl.

**Lifetime follows state ownership:** app-owned state (database, repos, sources)
→ singleton; scope-owned state (coordinators) → factory + the scope's `dispose`;
stateless (use cases) → factory.

**Source ownership:** a source has exactly one owner — its repo. No other class
ever injects a source. Cross-aggregate needs go through the other aggregate's
repo *interface*: preferably composed in a use case that injects both repos;
repo→repo injection is allowed for infrastructure cases but must stay acyclic.

**Never registered:** cubits, widgets, ui models. Cubits are constructed by hand
in providers, receiving deps through their constructors.

**Who may call `getIt`:** `main()` and `*_provider.dart` files only (see The
4-File Unit). Everything else — cubits, repos, sources, use cases — receives its
dependencies via constructor; injectable generates that wiring.

## Screen & Flow Structure

A **screen** = has a route and a `Scaffold` (and usually a cubit). A **flow** =
several screens sharing one coordinator. Both live under `ui/screens/`:

```
ui/screens/
├── <screen_name>/          # STANDALONE SCREEN
│   ├── screen/             # <screen_name>_screen.dart (the Scaffold), plus the
│   │                       #   rest of the 4-file unit if the screen has state
│   ├── widgets/            # One directory per widget UNIQUE to this screen
│   │   └── <widget_name>/  #   (a 4-file unit when it owns state)
│   └── coordinator/        # <screen_name>_coordinator.dart + the
│                           #   RepositoryProvider that scopes it. Create ONLY
│                           #   if screen and widgets need coordination
│                           #   (e.g. selection, totals, expand/collapse-all).
└── <flow_name>/            # FLOW — create only when screens must share state
    ├── coordinator/        # <flow_name>_coordinator.dart — scoped above the
    │                       #   flow's nested router; injectable into every
    │                       #   cubit of every member screen
    ├── <screen_a>/         # Member screens: same shape as a standalone screen
    │   ├── screen/         #   (each may still have its own screen-local
    │   └── widgets/        #   coordinator for its own widgets)
    └── <screen_b>/
        ├── screen/
        └── widgets/
```

### The 4-File Unit

A widget or screen that owns state has a cubit — and then always all four files,
named after it (`<name>_widget.dart`, `<name>_cubit.dart`, …):

| File | Role |
|---|---|
| `*_widget.dart` | View only — reads the cubit, renders, no logic |
| `*_cubit.dart` | Owns the logic; deps via constructor injection; subscribes to streams in `init()`, cancels in `close()` |
| `*_state.dart` | Equatable state with `copyWith` (explicit `clearX` flags for nullable fields) |
| `*_provider.dart` | The ONLY file that touches `getIt`. Fetches deps, `context.read`s scoped ones (e.g. the coordinator), creates the cubit in a `BlocProvider`, wraps the widget |

A cubit is never mandatory. No state → no cubit, and the other files don't exist
either: just `*_widget.dart` (or `<screen_name>_screen.dart`). Purely
view-mechanical state (`AnimationController`, `TextEditingController`, scroll
position) uses a `StatefulWidget`, not a cubit.

**Routing:** `@RoutePage()` goes on the outermost widget of each stack:

- **Screen:** the coordinator's provider if one exists → else the screen's
  provider → else the screen widget itself.
- **Flow:** the flow is a shell route — a `@RoutePage` widget where the flow
  coordinator's `RepositoryProvider` wraps a nested `AutoRouter()`; the member
  screens are its child routes.

### UI Models

The presentation counterpart of an entity. Lives in `ui/ui_models/`, class named
`<X>UI` (`GroupUI`, `SelectedHabitUI`), file named `<x>_ui.dart`. Name it after
**what it presents, not where it's used**: an aggregate's default presentation
is plain `<Aggregate>UI`; a prefix (`Selected…UI`, `New…FormUI`) is earned only
by a genuinely different projection.

- **Cubits and widgets deal only with UI models — never entities.** Entities
  appear inside a cubit only *in transit* at the domain boundary: map with
  `fromEntity` the moment a use case delivers one, and with `toEntity` right at
  the call when submitting back. State fields, widget code, and cubit public
  APIs never carry an entity.
- **Always `Equatable`, always `copyWith`** — same requirements as states.
- **`fromEntity` always; `toEntity` only if some flow actually submits the
  model back** to a use case.
- **Conversions get their own line.** Never bury `fromEntity`/`toEntity` inside
  another call's argument list — assign to a named local first, then pass it:

  ```dart
  // NO
  editGroupUseCase.exec(uiModel.toEntity(groupUI: state.uiModel));
  // YES
  final entity = uiModel.toEntity(groupUI: state.uiModel);
  editGroupUseCase.exec(entity);
  ```

### Widget Communication Rules

For widgets under `screens/<screen_name>/widgets/`:

1. **Internal state affecting no one else → own cubit.**
2. **Affects a sibling that has its own cubit → coordinator.** A *sibling* is
   any other cubit under the same coordinator's scope — in the same screen, or
   in a sister screen of the flow. Also the only channel that physically works:
   cubits cannot subscribe to each other — the coordinator is injectable into
   any cubit.
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

### Coordinator Anatomy

The coordinator coordinates through rx: it is a plain class (abstract interface
+ `Impl`, registered `@Injectable(as: ...)`) holding **one `BehaviorSubject` per
signal**, with void methods as the write side and streams as the read side:

```dart
abstract class <Name>Coordinator {
  Stream<Item?> get listenToItemSelected;        // read: raw stream
  Stream<bool> listenIsItemSelected(String id);  // read: filtered per consumer
  void itemSelected(Item item);                  // write
  void clearItemSelection();                     // write
  void dispose();
}

@Injectable(as: <Name>Coordinator)
class <Name>CoordinatorImpl implements <Name>Coordinator {
  final _itemSelected = BehaviorSubject<Item?>();
  final _total = BehaviorSubject<int>.seeded(0); // seeded: has a value pre-write

  @override
  Stream<Item?> get listenToItemSelected => _itemSelected.stream;

  @override
  Stream<bool> listenIsItemSelected(String id) =>
      _itemSelected.stream.map((e) => e?.id == id);

  @override
  void itemSelected(Item item) => _itemSelected.add(item);

  @override
  void clearItemSelection() => _itemSelected.add(null);

  @override
  void dispose() {
    _itemSelected.close();
    _total.close();
  }
}
```

The rules that make it work:

- **`BehaviorSubject`, not `StreamController`** — it replays the latest value,
  so a cubit created after a signal fired still syncs on subscribe. Use
  `.seeded(...)` when consumers need a value before the first write.
- **Writers call methods, readers get streams.** No one outside the impl ever
  sees a subject. Expose raw streams (`listenToX`) or per-consumer slices
  (`listenIsItemSelected(id)` via `.map`/`.where`) so each subscriber receives
  only what concerns it.
- **No logic, no storage.** The coordinator transports signals between cubits;
  it never calls use cases and holds no renderable state. Each consuming cubit
  subscribes in `init()`, mirrors what it needs into its own state with `emit`,
  and cancels the subscription in `close()`.
- **Lifecycle.** `dispose()` closes every subject, and the `RepositoryProvider`
  that scopes the coordinator owns that call
  (`dispose: (c) => c.dispose()`) — the subjects die with the scope.
- **Naming.** Streams are `listenToX` / `listenIsX(param)`; write methods are
  imperative verbs (`itemSelected`, `clearItemSelection`, `updateTotal`).
