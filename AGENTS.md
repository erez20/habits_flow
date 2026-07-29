# perfect_claude.md

Guidance for working in this codebase: a Flutter app following clean
architecture with a reactive, stream-based data flow. Stack: flutter_bloc
(cubits), get_it + injectable (DI), auto_route (navigation), drift (SQLite),
rxdart (subjects & stream composition), fimber (logging).

## Required Stack Packages

Projects adopting these conventions need these architectural dependencies.
`pubspec.yaml` is the source of truth for exact versions.

| Purpose | Packages |
|---|---|
| State and immutable value objects | `flutter_bloc`, `equatable` |
| Dependency injection | `get_it`, `injectable`, `injectable_generator` |
| Navigation | `auto_route`, `auto_route_generator` |
| Reactive stream composition | `rxdart` |
| Logging | `fimber` |
| Code generation | `build_runner` |
| Local SQLite persistence | `drift`, `drift_flutter`, `drift_dev` |

Keep this list aligned whenever this guide adds or removes an architectural
dependency. Feature-specific packages belong in `pubspec.yaml`, not here.

## Directory Structure

```
lib/
├── main.dart            # Entry point → root app widget
├── main/                # TOP of the graph — imported by NO ONE. Composition root:
│                        #   injection wiring + config, root MaterialApp
├── core/                # BOTTOM — imported by everyone, imports nothing.
│   │                    #   Pure Dart (no Flutter). Cross-cutting, no business logic
│   ├── di/              # The getIt handle (di.dart)
│   ├── extensions/      # Pure-Dart extensions, one dir per extended type
│   │   └── int/         #   (*_ext.dart, e.g. duration_ext.dart)
│   └── logger/          # Logger initialization (app_logger.dart)
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
    ├── app/             # App-root cubit/state (e.g. restart)
    ├── theme/           # Design tokens — colors, fonts
    ├── constants/       # Layout constants (sizes, paddings)
    ├── type/            # Shared UI value types (enums, etc.)
    ├── routes/          # auto_route router (app_router.dart + generated .gr.dart)
    ├── screens/         # One directory per screen (see "Screen Structure" below)
    ├── dialogs/         # REUSABLE dialogs only, one dir per dialog (see "Dialogs")
    ├── ui_models/       # REUSABLE UI models only — a model scoped to one
    │                    #   screen lives under that screen (see "UI Models")
    └── widgets/         # REUSABLE widgets only, one dir per widget — anything
                         #   unique to one screen lives under that screen instead
```

**Dependency rule:** `ui → domain ← data`. The domain layer imports nothing from
`ui/` or `data/`. Generated files (`*.g.dart`, `*.gr.dart`, `*.config.dart`) are
never edited by hand.

**The sandwich — `core` at the bottom, `main` at the top:**

- **`core/` is imported by everyone and imports nothing** in the app, so it must
  stay **pure Dart (no Flutter)** — `domain` may import it, and `domain` is
  Flutter-free. A helper that needs Flutter types is therefore not `core`: a
  pure-Dart extension goes in `core/extensions/`, a Flutter-typed one under
  `ui/`.
- **`main/` is imported by no one.** It is the composition root: it may import
  anything to wire the app together, but nothing depends on it. If a lower layer
  seems to need something from `main`, `main` injects it downward instead (see
  DI below).

## Dependency Injection (get_it + injectable)

DI is split to honor the sandwich. The **`getIt` handle** lives in
`core/di/di.dart` (`final getIt = GetIt.instance;` — pure, imported by every
provider). The **wiring** lives at the top in `main/injection.dart`, because the
generated `injection.config.dart` imports nearly the whole app to register it —
that file is the composition root and can only live in `main/`:

```dart
// core/di/di.dart — pure handle, imported everywhere
final getIt = GetIt.instance;

// main/injection.dart — wiring, imported by no one but main.dart
@InjectableInit(initializerName: 'init', preferRelativeImports: false, asExtension: true)
void configureDependencies() => getIt.init();
```

`main()` calls `configureDependencies()` before `runApp`. After adding or
changing any annotation, run
`dart run build_runner build --delete-conflicting-outputs`.

**Logging setup.** Logging initialization lives in `core/logger/app_logger.dart`.
`initLogger()` plants `DebugTree()` (or environment-specific trees) and is
called in `main()` during bootstrap before `configureDependencies()`:

```dart
// core/logger/app_logger.dart — pure logger initialization
void initLogger() {
  Fimber.plantTree(DebugTree());
}
```

Use `Fimber` static methods (`Fimber.d`, `Fimber.i`, `Fimber.e`) directly across
cubits and services for log output.

Restart/reset is a `main/` concern too: `AppCubit` (in `ui/app/`) takes an
`onRestart` callback that `main.dart` supplies as
`() async { await getIt.reset(); configureDependencies(); }` — the cubit never
imports `main/`. App-root cubits (under `ui/app/`) omit provider and view files because they are instantiated and listened to directly at the composition root in `main.dart`.

**Optional full-app restart.** Add a root-restart wrapper only when an
operation—such as restoring a database—requires both rebuilding dependencies
and remounting the entire widget tree. Most apps do not need this pattern;
ordinary feature state changes should flow through cubits and streams instead.

When it is needed:

1. Bootstrap logging and dependencies before `runApp`, then place a
   `StatefulWidget` restart wrapper above the root app widget.
2. Let the wrapper own an incrementing key and provide a restart cubit/action
   with a callback that resets and reconfigures dependencies.
3. After that callback completes, emit a one-shot restart signal. A
   `BlocListener` in the wrapper increments the key in response.
4. Give the root app `ValueKey(key)`; changing it remounts the app against the
   newly configured dependencies.

Name the wrapper, action, and signal for the app at hand. A convenience
`restart(context)` helper is optional; prefer the restart cubit/action when it
is already available.

**Root app widget.** Keep the app shell in a dedicated widget under `main/`;
`main.dart` remains responsible only for bootstrap and composition. The root
widget owns the long-lived router instance and returns `MaterialApp.router`
from that router's configuration. Put app-wide configuration there—such as the
title, theme, localization, and navigation settings—and do not recreate the
router in `build`.

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

## Data Layer

### 1. Remote Data Sources & API Requests

Every API call is split into three strictly enforced components: the Request, the Remote Model, and the Remote Source.

**A. The Request Class**
- **Path:** `data/<aggregate>/requests/<action>_<aggregate>_request.dart`
- **Rule:** Exactly one class per API endpoint. Must extend a base verb (`GetRequest`, `PostRequest`).
- **Template:**
  ```dart
  import 'package:dio/dio.dart';
  import 'package:dio_mini/data/network/requests/get_request.dart';

  class Get<Aggregate>Request extends GetRequest {
    final String id;

    Get<Aggregate>Request({
      required this.id,
      required super.dio,
    });

    Future<Map<String, dynamic>> exec() async {
      final response = await dio.get('/<aggregate>/$id');
      return response.data;
    }
  }
  ```

**B. The Remote Model**
- **Path:** `data/<aggregate>/remote_models/<aggregate>_remote_model.dart`
- **Rule:** Must be annotated with `@JsonSerializable()`. Must implement `fromJson`, `toJson`, and `toEntity()`.
- **Template:**
  ```dart
  import 'package:json_annotation/json_annotation.dart';
  import 'package:app/domain/entities/<aggregate>_entity.dart';

  part '<aggregate>_remote_model.g.dart';

  @JsonSerializable()
  class <Aggregate>RemoteModel {
    final String id;
    // ...fields

    <Aggregate>RemoteModel({required this.id});

    factory <Aggregate>RemoteModel.fromJson(Map<String, dynamic> json) => 
        _$<Aggregate>RemoteModelFromJson(json);
    
    Map<String, dynamic> toJson() => _$<Aggregate>RemoteModelToJson(this);

    <Aggregate>Entity toEntity() => <Aggregate>Entity(id: id);
  }
  ```

**C. The Remote Source**
- **Path:** `data/<aggregate>/remote_source/<aggregate>_remote_source.dart`
- **Rule:** Registered as `@Injectable()`. Takes `Dio` via constructor. Instantiates the request, calls `exec()`, and returns the `RemoteModel`.
- **Template:**
  ```dart
  import 'package:dio/dio.dart';
  import 'package:injectable/injectable.dart';

  @Injectable()
  class <Aggregate>RemoteSource {
    final Dio _dio;

    <Aggregate>RemoteSource({required Dio dio}) : _dio = dio;

    Future<<Aggregate>RemoteModel> get<Aggregate>({required String id}) async {
      final request = Get<Aggregate>Request(dio: _dio, id: id);
      final data = await request.exec();
      return <Aggregate>RemoteModel.fromJson(data);
    }
  }
  ```

### 2. Local Sources (Drift Persistence)

Local sources are the *only* components that touch `AppDatabase`. They do not use intermediate models; they map Drift table rows directly to Domain Entities.

**A. The Interface**
- **Path:** `data/sources/<aggregate>/<aggregate>_local_source.dart`
- **Rule:** Pure abstract class defining CRUD and stream operations. Must include `Future<void> refresh();`.

**B. The Implementation**
- **Path:** `data/sources/<aggregate>/<aggregate>_local_source_impl.dart`
- **Rule:** Registered as `@LazySingleton(as: <Aggregate>LocalSource)`. Uses `BehaviorSubject` for manual refreshes.
- **Template:**
  ```dart
  import 'package:drift/drift.dart';
  import 'package:injectable/injectable.dart';
  import 'package:rxdart/rxdart.dart';
  import 'package:uuid/uuid.dart';

  @LazySingleton(as: <Aggregate>LocalSource)
  class <Aggregate>LocalSourceImpl implements <Aggregate>LocalSource {
    final AppDatabase db;
    final _refreshController = BehaviorSubject<void>();

    <Aggregate>LocalSourceImpl({required this.db});

    @override
    Future<void> refresh() async => _refreshController.add(null);

    @override
    Future<<Aggregate>Entity> create<Aggregate>({required String title}) async {
      final companion = <Aggregate>sCompanion.insert(id: const Uuid().v4(), title: title);
      await db.into(db.<aggregate>s).insert(companion);
      return <Aggregate>Entity(id: companion.id.value, title: title); // Direct Entity mapping
    }

    @override
    Stream<List<<Aggregate>Entity>> <aggregate>sStream() {
      // Use switchMap to combine manual refresh with Drift's reactive watch()
      return _refreshController.startWith(null).switchMap((_) {
        return db.select(db.<aggregate>s).watch().map((rows) => 
          rows.map((row) => <Aggregate>Entity(id: row.id, title: row.title)).toList()
        );
      });
    }
  }
  ```

### 3. Repositories (Strict Error Boundaries & Data State)

Repositories orchestrate data but never touch the DB or API directly. They are the strict error boundary mapped to `DomainResponse<T>`. 

**A. Interface & Return Types (Domain Layer)**
- **Path:** Interfaces sit in `domain/repos/<aggregate>_repo.dart`.
- **Rule:** Repositories must enforce strict return types:
  - Synchronous/One-off requests must return `Future<DomainResponse<T>>`. They **never** return raw `Future<T>`.
  - Reactive subscriptions must return `Stream<T>` or `Stream<DomainResponse<T>>`.

**B. Implementation (Data Layer)**
- **Path:** Implementations sit in `data/repos/<aggregate>_repo_impl.dart`.
- **Rule:** A single repository implementation may compose both local and remote sources. 
  - For **local sources**, it often acts as a stateless passthrough (since Drift maintains the state), mapping database exceptions.
  - For **remote sources**, it may use stateful in-memory caching (e.g. `BehaviorSubject` + `Map`) to broadcast network results.
- **Template:**
  ```dart
  @LazySingleton(as: <Aggregate>Repo)
  class <Aggregate>RepoImpl implements <Aggregate>Repo {
    final <Aggregate>LocalSource localSource;
    final <Aggregate>RemoteSource remoteSource;
    
    // Stateful caching for remote data
    final _db = <String, DomainResponse<<Aggregate>Entity>>{};
    final _subject = BehaviorSubject<Map<String, DomainResponse<<Aggregate>Entity>>>.seeded({});

    <Aggregate>RepoImpl({
      required this.localSource, 
      required this.remoteSource,
    });

    // Example 1: Stateful Remote Interaction (Caching + Error Mapping)
    @override
    Future<DomainResponse<<Aggregate>Entity>> fetchRemote<Aggregate>({required String id}) async {
      try {
        _db[id] = Loading(data: _db[id]?.data);
        _subject.add(Map.unmodifiable(_db));

        final model = await remoteSource.get<Aggregate>(id: id);
        final success = Success(model.toEntity());
        _db[id] = success;
        _subject.add(Map.unmodifiable(_db));
        return success;
      } on DioException catch (e) {
        return Failure(error: NetworkError(e.response?.statusCode));
      } catch (e) {
        return Failure(error: UnknownError(e.toString()));
      }
    }

    // Example 2: Stateless Local Interaction (DB Error Mapping)
    @override
    Future<DomainResponse<void>> updateLocal<Aggregate>({required <Aggregate>Entity item}) async {
      try {
        await localSource.update<Aggregate>(item: item);
        return const Success(null);
      } on Exception catch (e) {
        return Failure(error: DatabaseError(message: e.toString()));
      }
    }

    // Example 3: Stateless Local Stream (Stream Mapping)
    @override
    Stream<DomainResponse<<Aggregate>Entity>> <aggregate>Stream({required String id}) {
      return localSource
          .<aggregate>Stream(id)
          .map((item) => Success(item) as DomainResponse<<Aggregate>Entity>)
          .handleError((e) => Failure(error: DatabaseError(message: e.toString())));
    }
  }
  ```

## Screen & Flow Structure

A **screen** = has a route and a `Scaffold` (and usually a cubit). A **flow** =
several screens sharing one coordinator. Both live under `ui/screens/`:

```
ui/
└── screens/
    ├── <screen_name>/          # STANDALONE SCREEN
    │   ├── screen/             # <screen_name>_screen.dart (the Scaffold), plus the
    │   │                       #   rest of the 4-file unit if the screen has state
    │   ├── widgets/            # One directory per widget UNIQUE to this screen
    │   │   └── <widget_name>/  #   (a 4-file unit when it owns state)
    │   ├── dialogs/            # One directory per dialog UNIQUE to this screen —
    │   │   └── <name>_dialog/  #   sibling of widgets/ at every scope (see "Dialogs")
    │   ├── ui_models/          # UI models shared by this screen's widgets
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

**Widget Variant Selectors.** When a UI component has multiple state-driven view variants (e.g. an app bar switching between a standard view and a selection view based on screen state), group the variants and their builder/selector widget together inside a single component directory (`widgets/<component_name>/`). The builder widget (e.g. `<Component>Builder`) owns the `BlocBuilder` switching logic and renders the appropriate variant.

### The 4-File Unit

A widget or screen that owns state has a cubit — and then always all four files,
named after it (`<name>_widget.dart` or `<name>_screen.dart`, `<name>_cubit.dart`, …):

| File | Role |
|---|---|
| `*_widget.dart` / `*_screen.dart` | View only — reads the cubit, renders, no logic (`*_screen.dart` for screens, `*_widget.dart` for widgets) |
| `*_cubit.dart` | Owns the logic; deps via constructor injection; subscribes to streams in `init()`, cancels in `close()` |
| `*_state.dart` | Equatable state with `copyWith` (explicit `clearX` flags for nullable fields) |
| `*_provider.dart` | The ONLY file that touches `getIt`. Fetches deps, `context.read`s scoped ones (e.g. the coordinator), creates the cubit in a `BlocProvider`, wraps the widget |

A cubit is never mandatory. If a widget has no state and no actions requiring a cubit, the other files don't exist: just `*_widget.dart` (or `<screen_name>_screen.dart`). Purely
view-mechanical state (`AnimationController`, `TextEditingController`, scroll
position) uses a `StatefulWidget`, not a cubit. Reusable helper widgets without
a 4-file unit use free descriptive naming without a required view suffix.

**Provider forms.** Most providers are a `StatelessWidget` returning a `BlocProvider`
that creates the cubit. However, when a provider receives data from a parent widget
that can change over the provider's lifecycle, implement the provider as a
`StatefulWidget` using `BlocProvider.value`: initialize the cubit in `initState()`,
dispose it in `dispose()`, and forward updated parent properties to the cubit inside
`didUpdateWidget()`.

**Root router.** Keep the root router in `ui/routes/` as a class extending
`RootStackRouter` and annotated with `@AutoRouterConfig`. It owns the root
`AutoRoute` list, including the initial route and default route type. The root
app widget supplies this router's configuration; it does not declare routes.

**Routing:** `@RoutePage()` goes on the outermost widget of each stack:

- **Screen:** the coordinator's provider if one exists → else the screen's
  provider → else the screen widget itself.
- **Flow:** the flow is a shell route — a `@RoutePage` widget where the flow
  coordinator's `RepositoryProvider` wraps a nested `AutoRouter()`; the member
  screens are its child routes.

### State

A cubit has exactly **one** state class — a single `Equatable` class, never a
sealed hierarchy of multiple states. It always has:

- `extends Equatable` with `props`.
- A `factory <Name>.init()` producing the initial state. Params are allowed when
  the initial state needs seed data (`FeatureState.init({required item})`);
  otherwise it takes none (`ScreenState.init()`).
- `copyWith`, with an explicit `clearX` bool flag for any field that needs to be
  set back to null (nullable fields can't be cleared through `x ?? this.x`).

The cubit changes state **only** through `emit(state.copyWith(...))` — never by
constructing a fresh state instance.

**Exception — one-shot signal cubits.** A cubit whose whole job is to emit a
transient signal rather than hold renderable state (e.g. an app-restart trigger)
uses a **sealed** state hierarchy instead: one variant per signal, plain classes
(no Equatable/copyWith/init). The widget reacts with a `BlocListener` that fires
on the signal variant. This is the *only* place a sealed multi-state hierarchy
is allowed; if the cubit holds anything a widget renders, it is not this case.

**Action-only cubits.** When a cubit exists solely to encapsulate actions (such
as triggering use cases or dialogs) and holds no renderable state, it still
uses the standard single `Equatable` state structure: an empty state class
(`props => []`), a parameterless `factory <Name>.init() => const <Name>()`, and a
no-op `copyWith()`.

**No inline conditional rendering logic in widgets.** Widgets must never contain inline conditional branch expressions (such as `if (condition) Widget1() else Widget2()` or ternary operators choosing between distinct view branches). Any condition that determines layout branching must be evaluated in the cubit or computed on the state class (or UI model) as a field or getter. The widget only inspects state properties to select what to render.

### Theme & Constants

- **Theme (`ui/theme/`):** Exposes design tokens (colors, palettes, font styles) through static utility classes (`AppColors`, `AppFonts`). Palette mapping and conversion utilities belong on `AppColors`.
- **Constants (`ui/constants/`):** Exposes layout constants (paddings, spacing) and dynamic layout helper methods accepting `BuildContext` (e.g. `Constants.itemDimension(context)`) through static utility classes (`Constants`).

### UI Models

The presentation counterpart of an entity: class named `<X>UI` (`ItemUI`,
`SelectedItemUI`), file named `<x>_ui.dart`. Name it after **what it presents,
not where it's used**: an aggregate's default presentation is plain
`<Aggregate>UI`; a prefix (`Selected…UI`, `New…FormUI`) is earned only by a
genuinely different projection.

**Placement — the narrowest scope that contains all consumers:**

1. Used by one widget → flat in that widget's directory (the unit's fifth file).
2. Used by several widgets of one screen (or screens of one flow) →
   `<screen_name>/ui_models/` (or `<flow_name>/ui_models/`).
3. Proven reuse across screens → top-level `ui/ui_models/`.

A model is promoted up the ladder only when a consumer from a wider scope
actually appears — never preemptively.

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
  editItemUseCase.exec(uiModel.toEntity(existing: state.uiModel));
  // YES
  final entity = uiModel.toEntity(existing: state.uiModel);
  editItemUseCase.exec(entity);
  ```

### Widget Communication Rules

**Prime rule: a cubit is never aware of another cubit** — no references, no
subscriptions, in any direction. A cross-cubit effect travels on exactly one of
two channels, chosen by the nature of the change:

- **It changes data (db / server)?** Then it isn't communication at all — call
  the use case. Affected cubits react through the domain streams they already
  subscribe to (perform an action → db write → every watching stream re-emits).
  A data change is **never** echoed through the coordinator.
- **It is pure UI** (selection, expand/collapse, gesture signals)? → the
  coordinator.

For widgets under `screens/<screen_name>/widgets/`:

1. **Internal state affecting no one else → own cubit.**
2. **Affects a sibling's UI state (sibling has its own cubit) → coordinator.**
   A *sibling* is any other cubit under the same coordinator's scope — in the
   same screen, or in a sister screen of the flow. Also the only channel that
   physically works: cubits cannot subscribe to each other — the coordinator is
   injectable into any cubit.
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

### Dialogs

A **dialog** is anything presented on its own modal route — `showDialog` or
`showModalBottomSheet`; which one is an implementation detail hidden inside the
dialog's `show()`. The `_dialog` suffix is a view-role suffix parallel to
`_widget`: the view file is `<name>_dialog.dart` (class `<Name>Dialog`), and a
dialog that owns state completes the 4-file unit (`<name>_dialog_cubit.dart`,
`..._state.dart`, `..._provider.dart`).

**Placement** mirrors widgets — `dialogs/` is a sibling of `widgets/` at every
scope: `<screen_name>/dialogs/` for screen dialogs (create only when needed),
`ui/dialogs/` for reusable ones. The scope ladder applies unchanged.

**Widgets specific to a dialog:** dialogs never nest a `widgets/` of their own —
they are leaf units, like widgets. Small dialog-internal pieces are private
classes in the dialog's own file; anything that earns its own unit goes in the
screen's `widgets/` (also the natural home for a widget shared by several
dialogs, e.g. a color picker used by two forms). Inside a dialog's subtree the
communication rules apply with the dialog's cubit as the father.

**The route boundary.** A dialog's route is a *sibling* of the screen's route,
not a child — the screen's providers are unreachable from inside it, so the
widget communication rules do not cross it. Instead:

- **In: params** — a snapshot taken by the launcher (`uiModel: state.uiModel`).
- **Out:** a callback for flow dialogs (forms:
  `onUpdate: cubit.editItem`), or an awaited result for decision dialogs
  (`final ok = await ConfirmDialog.show(...); if (ok) cubit.deleteItem();` —
  the launcher applies the domain meaning).
- **Never bridge with `BlocProvider.value`** to observe a screen cubit from a
  dialog. A dialog that needs *live* data gets its own cubit subscribing to a
  domain stream, keyed by ids passed as params — same logic as rule 2: a cubit
  that needs live data goes to the domain, never to another cubit.

**Opening.** Every dialog exposes a
`static Future<T?> show(BuildContext context, {...})` that owns the route
plumbing; launchers never call `showDialog`/`showModalBottomSheet` directly.
Opening is a **widget's** job:

- User-triggered: call `<Name>Dialog.show(...)` in the tap handler.
- Cubit-triggered: the cubit emits a one-shot signal (see the State exception)
  and a `BlocListener` in the widget opens the dialog. **A cubit never touches
  `BuildContext`** — no navigation, dialogs, sheets, or snackbars from cubits.

Guard with `context.mounted` before using a context after any `await`.

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
- **No logic, no storage, UI signals only.** The coordinator is **deaf to the
  domain**: it never calls *or listens to* a use case, holds no renderable
  state, and never carries data-change echoes — live data always travels
  through domain streams straight to the cubits that need it (see the prime
  rule). A coordinator that subscribed to the domain would just be a cubit
  rebuilt badly out of raw subjects. Each consuming cubit subscribes in
  `init()`, mirrors what it needs into its own state with `emit`, and cancels
  the subscription in `close()`.
- **Lifecycle.** `dispose()` closes every subject, and the `RepositoryProvider`
  that scopes the coordinator owns that call
  (`dispose: (c) => c.dispose()`) — the subjects die with the scope.
- **Naming.** Streams are `listenToX` / `listenIsX(param)`; write methods are
  imperative verbs (`itemSelected`, `clearItemSelection`, `updateTotal`).

## Code Style

- **Imports:** full package path (`package:<app>/...`) for anything outside the
  file's own directory; bare filename (`import 'item_state.dart';`) for files
  in the same directory; `../` never. Package paths keep consumers greppable
  and rewritable when files move; bare same-dir imports keep a unit's internal
  wiring intact when its whole directory moves. No lint expresses this hybrid —
  `avoid_relative_lib_imports` guards the worst case, the rest is convention.
- **Named parameters, always:** constructors and multi-parameter functions take
  named parameters (`{required this.xxx}`), never positional. Since named
  parameters cannot be private, injected dependency fields are public
  (`final ItemRepo itemRepo`, not `_repo`). The one exception: single-value
  wrappers and converters (`Success(data)`, `fromEntity(entity)`,
  `exec(params)`) keep their single positional parameter — naming it adds
  noise, and positional keeps them tear-off friendly.
