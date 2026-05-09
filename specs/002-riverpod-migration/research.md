# Research: Riverpod Migration Technical Details

## State of the App

The application currently uses `ChangeNotifier` for global settings (`AppSettingsController`) and `setState` for feature-level state management. Data access is handled by "DataSources" that directly interact with `sqflite`.

## Key Findings & Decisions

### 1. Global Settings Migration
- **Current**: `AppSettingsController` (ChangeNotifier + SharedPreferences).
- **Decision**: Migrate to an `AsyncNotifierProvider` named `settingsProvider`.
- **Rationale**: Settings are persisted asynchronously. `AsyncNotifier` provides built-in support for the "loading" state during initial load from `SharedPreferences`.
- **Alternatives**: A simple `NotifierProvider` with a manual `load()` method, but `AsyncNotifier` is more idiomatic in Riverpod 2.x for persisted state.

### 2. Repository Layer Design
- **Decision**: Each feature will have:
  - `domain/repositories/i_[feature]_repository.dart`: Abstract class defining the contract.
  - `data/repositories/[feature]_repository_impl.dart`: Implementation using the existing `[Feature]LocalDataSource`.
- **Rationale**: This fulfills the requirement for a "Proper Repository Layer" and enables easier testing by allowing repository mocks.

### 3. Provider Structure
- **Data Source Providers**: `Provider<CustomerLocalDataSource>((ref) => CustomerLocalDataSource())`.
- **Repository Providers**: `Provider<ICustomerRepository>((ref) => CustomerRepositoryImpl(ref.watch(customerDataSourceProvider)))`.
- **Data Providers**:
  - `FutureProvider<List<Customer>>`: For one-time fetches.
  - `StreamProvider<List<Customer>>`: If we add reactive listeners to SQLite later (e.g., via `Watch` or manual invalidation).

### 4. Code Generation
- **Decision**: Use `riverpod_annotation` and `riverpod_generator`.
- **Rationale**: Reduces boilerplate, ensures type safety, and is the current recommendation from the Riverpod team.
- **Dependency**: Requires `build_runner`.

### 5. Incremental Strategy
- **Phase 1**: Infrastructure (ProviderScope, Base Providers).
- **Phase 2**: Global Settings (`settingsProvider`).
- **Phase 3**: Simplest Feature (Customers) - Repository + Providers + Screen Migration.
- **Phase 4**: Products, Payments, Dashboard.
- **Phase 5**: Complex Forms (Invoices).

## Unresolved Details (Handled via Assumptions)
- **Shared Preferences Provider**: We will create a `Provider<SharedPreferences>` that is initialized in `main()` using `ProviderScope(overrides: [...])` to ensure settings can be loaded synchronously once the app starts.
- **Database Provider**: We will create a `Provider<Database>` to decouple the `LocalDataSource` from the singleton `AppDatabase.instance`.
