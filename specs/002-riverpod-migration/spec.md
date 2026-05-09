# Feature Specification: Incremental Riverpod Migration

**Feature Branch**: `002-riverpod-migration`  
**Created**: 2026-05-09  
**Status**: Draft  
**Input**: User description: "Create a safe incremental Riverpod migration plan for this Flutter app based on the completed architecture analysis and recommendation. Preserve current UI and routing. Do not rewrite the app. Migrate feature-by-feature. Implement the repository layer properly. Use flutter_riverpod. Reduce setState gradually. Start with AppSettings and the simplest feature first. Keep SQLite architecture intact. Migrate complex invoice forms last. Do not implement yet; only create the specification."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Global Application Settings (Priority: P1)

As a user, I want the application's theme and language settings to update instantly across all screens when I change them in the settings menu, without the app needing complex manual state passing or frequent rebuilds of unrelated components.

**Why this priority**: This is the foundation of the migration. It replaces the existing `AppSettingsController` and demonstrates the "reactive" nature of Riverpod at a global level.

**Independent Test**: Can be tested by changing the theme from "Light" to "Dark" in the settings screen and verifying all other screens (e.g., Dashboard, Products) immediately reflect the change.

**Acceptance Scenarios**:

1. **Given** the app is running, **When** the user changes the theme in Settings, **Then** all widgets listening to the settings provider must rebuild with the new theme.
2. **Given** the app restarts, **When** the settings were previously saved, **Then** Riverpod must initialize with the persisted values from `SharedPreferences`.

---

### User Story 2 - Simplified Product/Customer Lists (Priority: P2)

As a user, I want to see a loading indicator followed by a list of products or customers, with the confidence that the data is being fetched safely and handled consistently, even if there are errors.

**Why this priority**: This migrates the simplest feature screens (Products and Customers) to Riverpod, replacing manual `_isLoading` flags with `AsyncValue`.

**Independent Test**: Can be fully tested by navigating to the Products screen; it should show a loader briefly and then display the data from SQLite via the new Repository layer.

**Acceptance Scenarios**:

1. **Given** a list of products exists in the database, **When** the Products screen is opened, **Then** the UI should show a loading state, followed by the product list.
2. **Given** a database error occurs, **When** the screen is opened, **Then** a user-friendly error message should be displayed with a "Retry" option.

---

### User Story 3 - Repository-Driven Data Access (Priority: P2)

As a developer, I want to interact with data through abstract repositories instead of direct SQLite queries in the UI, ensuring the business logic remains decoupled from the persistence layer.

**Why this priority**: Essential for the "Proper Repository Layer" requirement. It ensures long-term maintainability and testability.

**Independent Test**: Can be verified by swapping a "MockRepository" for a "SqliteRepository" in a provider and seeing the UI function identically.

**Acceptance Scenarios**:

1. **Given** a new repository interface, **When** it is implemented using the existing `LocalDataSource`, **Then** the provider must return this implementation to any consuming widgets.

---

### User Story 4 - Complex Invoice Form Management (Priority: P3)

As a user, I want to fill out a complex multi-item invoice form that remains responsive and accurate as I add or remove items, with validation occurring in real-time.

**Why this priority**: This is the most complex part of the app. Migrating it last ensures the patterns for simpler features are well-established.

**Independent Test**: Can be tested by creating an invoice with multiple items and observing that calculating the total doesn't lag the UI or cause unnecessary full-screen rebuilds.

**Acceptance Scenarios**:

1. **Given** an empty invoice form, **When** items are added or quantities changed, **Then** the total amount should update reactively via a Notifier.
2. **Given** invalid data (e.g., zero quantity), **When** trying to save, **Then** the Riverpod-managed state should trigger validation errors in the UI.

### Edge Cases

- **Concurrent Data Updates**: What happens if the database is updated (e.g., a background backup restore) while a provider is holding a cached list? (Solution: Use `StreamProvider` where real-time updates are needed, or invalidate providers on change).
- **Provider Initialization Failures**: How does the app handle a failure during `ProviderScope` initialization or initial repository setup? (Solution: Standard Flutter error boundary and Riverpod error handling).
- **Navigation during Loading**: If a user navigates away from a screen while a `FutureProvider` is still fetching, the process should be cancelled or handled safely to avoid memory leaks.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST wrap the root `MyApp` widget in a `ProviderScope` to enable Riverpod across the entire application.
- **FR-002**: System MUST define abstract repository classes in `domain/repositories/` for all core features (Customers, Products, Invoices, Payments).
- **FR-003**: System MUST provide Repository implementations in `data/repositories/` that depend on the existing `LocalDataSource` classes.
- **FR-004**: System MUST convert the `AppSettingsController` into a `NotifierProvider` (or `AsyncNotifierProvider`) to manage global preferences.
- **FR-005**: System MUST replace manual `setState` calls for data fetching with `FutureProvider` or `StreamProvider` in the presentation layer.
- **FR-006**: System MUST utilize `AsyncValue.when` (or `.maybeWhen`) to handle Loading, Error, and Data states consistently across all screens.
- **FR-007**: System MUST implement a `Notifier` for complex forms (like the Invoice form) to manage internal form state and validation logic outside of the `StatefulWidget`.
- **FR-008**: System MUST maintain the existing `sqflite` database architecture as the primary data source for all repositories.

### Key Entities *(include if feature involves data)*

- **AppSetting**: Represents global user preferences (themeMode, languageCode). Managed by a global provider.
- **Repository**: Abstract interface for data operations. Decouples UI from SQLite.
- **AsyncValue**: A Riverpod wrapper for asynchronous data, providing a unified way to handle loading/error/data states.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of global settings (Theme and Locale) are managed by Riverpod providers, with the old controller removed.
- **SC-002**: All 5 core features (Customers, Products, Invoices, Payments, Dashboard) have functional Repository implementations and corresponding Providers.
- **SC-003**: The total number of `setState` calls in the application is reduced by at least 70% after full migration.
- **SC-004**: No regressions in UI appearance or existing Navigator 1.0 routing behavior after the migration is complete.
- **SC-005**: All data fetching in the UI is performed through Riverpod providers rather than direct Data Source or Database calls.

## Assumptions

- **Standard Riverpod**: We will use `flutter_riverpod` and the `riverpod_annotation` package with code generation for maximum type safety.
- **Navigator 1.0**: The current imperative navigation (Navigator.push) will be preserved as per user request, even though Riverpod often pairs well with `go_router`.
- **SQLite Persistence**: We assume the existing `AppDatabase` and `LocalDataSource` implementations are stable and will be the only data sources for the new repositories.
- **Incremental PRs**: The migration will be performed in multiple steps (PRs), ensuring the app remains buildable and testable at every stage.
