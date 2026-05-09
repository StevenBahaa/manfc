# State Management Recommendation: Riverpod

## Recommended Approach: Riverpod

Based on the architectural analysis of the project, **Riverpod** is the recommended state management solution.

## Justification

### 1. Minimum Safe Migration Effort
- **Seamless Integration**: Riverpod's provider-based model fits perfectly with the project's existing "Clean Architecture Lite" folder structure.
- **Progressive Refactoring**: The transition from `setState` to Riverpod can be done screen-by-screen. Existing screens can remain as `StatefulWidgets` while using `ref` to access global logic.
- **Low Boilerplate**: Unlike Bloc, Riverpod requires minimal setup code, which is ideal for the current small-to-medium size of the application.

### 2. Long-term Maintainability
- **Compile-time Safety**: Riverpod catches common errors (like provider types) at compile-time, reducing runtime crashes.
- **Async Data Handling**: The built-in `AsyncValue` pattern provides a standard way to handle "Loading", "Error", and "Data" states, which will replace the manual `_isLoading` flags currently scattered across the UI.
- **Testability**: Logic is easily decoupled from the UI, making it straightforward to write unit tests for repositories and business logic without needing a Flutter environment.
- **Scalability**: As the app grows and potentially adds remote APIs or complex caching, Riverpod's dependency injection and caching mechanisms (e.g., `ref.keepAlive()`) will provide robust support.

## Final Decision Summary

| Approach | Migration Effort | Long-term Maintainability | Verdict |
|---|---|---|---|
| **Riverpod** | **Moderate** | **High** | **Recommended** |
| Bloc/Cubit | High | Very High | Overkill for now |
| Provider | Low | Moderate | Lacks advanced async features |
| GetX | Low | Low/Moderate | Tightly coupled logic |
| ValueNotifier | Very Low | Moderate | Insufficient for complex forms |

---

## Detailed Migration Strategy

### Step 1: Core Infrastructure
1.  **Add Dependencies**: Add `flutter_riverpod` and `riverpod_annotation` to `pubspec.yaml`.
2.  **Global Scope**: Wrap the root `MyApp` in `ProviderScope` in `main.dart`.
3.  **Database Provider**: Create a `Provider` for `AppDatabase` to allow repositories to access the SQLite instance safely.
4.  **Settings Migration**: Convert `AppSettingsController` into a `NotifierProvider`. This will allow any widget to listen to theme/locale changes using `ref.watch(settingsProvider)`.

### Step 2: Repository Layer Implementation
1.  **Define Interfaces**: Fill the existing `domain/repositories/` directories with abstract classes for each feature.
2.  **Implement Repositories**: In `data/repositories/`, create implementations that take the `LocalDataSource` as a dependency.
3.  **Create Providers**: For each repository, create a `Provider` (e.g., `customerRepositoryProvider`).

### Step 3: Feature-Specific State Management
1.  **Async Data**: Use `FutureProvider` or `StreamProvider` to fetch lists (e.g., `allInvoicesProvider`). This eliminates the need for manual `_isLoading` state in screens.
2.  **Logic Decoupling**: Move business logic (like calculating invoice totals or validating product stock) from UI methods into `Notifier` classes.
3.  **Form State**: For complex forms like `InvoiceForm`, create a `Notifier` that manages the `InvoiceModel` being edited, reducing the number of `TextEditingControllers` managed directly by the View.

### Step 4: UI Transition
1.  **Widget Conversion**: Change `StatefulWidgets` that only manage data-fetching to `ConsumerWidget`.
2.  **State Observation**: Replace `setState` blocks with `ref.read(provider.notifier).update(...)`.
3.  **Error Handling**: Use the Riverpod `.when()` syntax on `AsyncValue` to provide consistent Error and Loading UI across all screens.
