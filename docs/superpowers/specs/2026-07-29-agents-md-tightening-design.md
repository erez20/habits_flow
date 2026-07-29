# AGENTS.md Tightening Design Spec

## Purpose
The `AGENTS.md` file acts as the ultimate source of truth for LLMs generating code in this project. While the Data and Domain layers are documented, several ambiguities remain that force an LLM to guess (e.g., package names, casing, and Drift pluralization). This spec outlines the exact rules to add to eliminate all guesswork.

## Proposed Changes

### 1. Placeholder Casing Rules
LLMs must not guess how to format an `<Aggregate>` placeholder depending on context. We will add a strict glossary defining:
- `<Aggregate>` = PascalCase (e.g., `UserProfile`) for classes and types.
- `<aggregate>` = snake_case (e.g., `user_profile`) for file paths and snake_case properties.
- `<camelAggregate>` = camelCase (e.g., `userProfile`) for variables, methods, and instances.

### 2. Global Package Name Rule
Currently, templates use example imports like `package:app/...` and `package:dio_mini/...`. 
- **Action:** Replace all hardcoded example packages in the templates with a unified `package:<package_name>/...` placeholder.
- **Rule:** Add a rule stating that `<package_name>` must match the project name found in `pubspec.yaml` (which is `habits_flow` for this repository).

### 3. Drift Pluralization Rule
Currently, the Drift Local Source template uses `<Aggregate>sCompanion` and `db.<aggregate>s`. If the aggregate is `category`, a blind string replacement results in invalid code (`CategorysCompanion`).
- **Rule:** Add an explicit rule under the Local Source section: "When replacing `<Aggregate>s` or `<aggregate>s` for Drift tables and companions, properly pluralize the word according to standard English rules (e.g., `Category` -> `Categories`, `CategorysCompanion` is invalid)."

### 4. Explicit Template Imports
Currently, the templates omit imports for core files like `AppDatabase`, `Loading`, `Success`, `Failure`, and `DomainError` subclasses, forcing the LLM to guess their location.
- **Rule:** We will add explicit import statements to the Data and Domain boilerplates using the `<package_name>` placeholder to eliminate all import path guesswork.
  - Examples: `import 'package:<package_name>/data/db/database.dart';` and `import 'package:<package_name>/domain/responses/domain_error.dart';`

## Scope & Constraints
- No existing architectural concepts are changing; this is purely an anti-ambiguity documentation update.
