# Implementation Plan: Incremental Riverpod Migration

**Branch**: `002-riverpod-migration` | **Date**: 2026-05-09 | **Spec**: [specs/002-riverpod-migration/spec.md]
**Input**: Feature specification from `/specs/002-riverpod-migration/spec.md`

## Summary

The goal is to migrate the application's state management from `setState` and `ChangeNotifier` to **Riverpod** in a safe, incremental manner. We will introduce a formal **Repository Layer** to decouple the UI from the SQLite data sources, while preserving the existing Navigator 1.0 routing and core UI logic.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x
**Primary Dependencies**: `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
**Storage**: `sqflite` (relational data), `shared_preferences` (settings)
**Testing**: `flutter_test`, `riverpod_test`
**Target Platform**: Mobile (iOS, Android)
**Project Type**: Mobile App
**Performance Goals**: Instant theme/locale switching, reactive list updates
**Constraints**: No app rewrite, preserve SQLite architecture, incremental migration
**Scale/Scope**: ~10 screens, 5 core entities

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **Library-First**: Core logic (Repositories) will be designed as independent units.
- [x] **Layered Architecture**: Strictly separates Presentation (Riverpod) from Domain (Repositories) and Data (DataSources).
- [x] **Minimal Change**: Preserve existing routing and UI widgets where possible.

## Project Structure

### Documentation (this feature)

```text
specs/002-riverpod-migration/
├── plan.md              # This file
├── research.md          # Research findings and technical decisions
├── data-model.md        # Provider hierarchy and state models
├── quickstart.md        # Guide for using the new state management
├── contracts/           # Repository interface definitions
└── checklists/          # Quality validation
```

### Source Code (repository root)

```text
lib/
├── app/
│   ├── controllers/      # To be phased out
│   ├── providers/        # NEW: Global providers (settings, db)
├── core/
│   ├── database/         # Existing SQLite setup
├── features/
│   ├── [feature]/
│   │   ├── domain/
│   │   │   ├── repositories/ # NEW: Abstract interfaces
│   │   ├── data/
│   │   │   ├── repositories/ # NEW: Implementations
│   │   │   ├── datasources/  # Existing
│   │   ├── presentation/
│   │   │   ├── providers/    # NEW: Feature-specific providers
│   │   │   ├── screens/      # Modified: From StatefulWidget to ConsumerWidget
```

**Structure Decision**: Standard "Clean Architecture Lite" already present in the project, enhanced with explicit Repository and Provider layers.

## Phases

### Phase 1: Infrastructure & Core Providers
- Add dependencies to `pubspec.yaml`.
- Wrap `MyApp` in `ProviderScope` in `main.dart`.
- Create `dbProvider` and `sharedPrefsProvider`.
- Set up `build_runner` for code generation.

### Phase 2: Global Settings Migration
- Create `SettingsState` model.
- Implement `settingsProvider` using `AsyncNotifier`.
- Update `main.dart` and `SettingsScreen` to use the new provider.
- Remove `AppSettingsController` once verified.

### Phase 3: Customer Feature (POC)
- Define `ICustomerRepository` in `domain/repositories/`.
- Implement `CustomerRepositoryImpl` in `data/repositories/`.
- Create `customersProvider` (FutureProvider) and `customerRepositoryProvider`.
- Migrate `CustomersListScreen` to `ConsumerWidget`.

### Phase 4: Product & Payment Migration
- Repeat Repository/Provider pattern for Products and Payments.
- Migrate respective screens.
- Replace remaining `setState` for simple loading flags.

### Phase 5: Dashboard & UI Cleanup
- Migrate Dashboard screen.
- Ensure all app-wide widgets (e.g., search bars) use Riverpod for global state.

### Phase 6: Complex Invoice Form Migration
- Create `InvoiceFormNotifier` to manage complex multi-item state.
- Handle real-time validation and calculation in the Notifier.
- Migrate `InvoiceFormScreen` last as planned.
