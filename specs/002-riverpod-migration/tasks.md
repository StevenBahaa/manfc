# Tasks: Incremental Riverpod Migration

**Input**: Design documents from `/specs/002-riverpod-migration/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/

**Tests**: No explicit TDD requested; validation will be via the "Independent Test" criteria for each story.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing. AppSettings is migrated first, and complex Invoice forms are migrated last, as requested.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1: Settings, US2: Lists, US3: Repo, US4: Invoice Form)
- Exact file paths are included in descriptions.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 Add `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, and `build_runner` to `pubspec.yaml`
- [X] T002 Wrap `MyApp` in `ProviderScope` in `lib/main.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure and repository interfaces that MUST be complete before feature migration

- [ ] T003 [P] [US3] Implement `dbProvider` (providing the SQLite `Database` instance) in `lib/app/providers/db_provider.dart`
- [ ] T004 [P] [US1] Implement `sharedPrefsProvider` (providing `SharedPreferences` instance) in `lib/app/providers/shared_prefs_provider.dart`
- [ ] T005 [P] [US3] Define `ICustomerRepository` interface in `lib/features/customers/domain/repositories/i_customer_repository.dart`
- [ ] T006 [P] [US3] Define `IProductRepository` interface in `lib/features/products/domain/repositories/i_product_repository.dart`
- [ ] T007 [P] [US3] Define `IInvoiceRepository` interface in `lib/features/invoices/domain/repositories/i_invoice_repository.dart`
- [ ] T008 [P] [US3] Define `IPaymentRepository` interface in `lib/features/payments/domain/repositories/i_payment_repository.dart`
- [ ] T009 [US1] Initialize `sharedPrefsProvider` override in `main()` within `lib/main.dart`

---

## Phase 3: User Story 1 - Global Application Settings (Priority: P1) 🎯 MVP

**Goal**: Migrate theme and language settings to Riverpod, replacing the old controller.

**Independent Test**: Change theme/locale in Settings screen and verify immediate update across the app.

### Implementation for User Story 1

- [ ] T010 [US1] Define `SettingsState` model in `lib/app/models/settings_state.dart`
- [ ] T011 [US1] Create `settingsProvider` (AsyncNotifier) in `lib/app/providers/settings_provider.dart`
- [ ] T012 [US1] Migrate `lib/app/app.dart` to use `ref.watch(settingsProvider)` for themeMode and locale
- [ ] T013 [US1] Migrate `lib/features/settings/presentation/screens/settings_screen.dart` to `ConsumerWidget`
- [ ] T014 [US1] Remove `appSettingsController` from `MainShell` in `lib/app/navigation/main_shell.dart`

**Checkpoint**: AppSettings migration complete. Old controller can be disabled (but not deleted yet).

---

## Phase 4: User Story 2 & 3 - Customer Feature Migration (Priority: P2)

**Goal**: Implement Customer repository and migrate the customer list to use Riverpod.

**Independent Test**: Open Customers list; verify loading spinner followed by data from SQLite.

### Implementation for Customer Feature

- [ ] T015 [US3] Implement `CustomerRepositoryImpl` (using `CustomerLocalDataSource`) in `lib/features/customers/data/repositories/customer_repository_impl.dart`
- [ ] T016 [P] [US2] Create `customerRepositoryProvider` in `lib/features/customers/presentation/providers/customer_providers.dart`
- [ ] T017 [US2] Create `customersProvider` (FutureProvider) in `lib/features/customers/presentation/providers/customer_providers.dart`
- [ ] T018 [US2] Migrate `lib/features/customers/presentation/screens/customers_list_screen.dart` to `ConsumerWidget` using `AsyncValue.when`

---

## Phase 5: User Story 2 & 3 - Product Feature Migration (Priority: P2)

**Goal**: Implement Product repository and migrate the product list to use Riverpod.

**Independent Test**: Open Products list; verify reactive updates when adding/deleting products.

### Implementation for Product Feature

- [ ] T019 [US3] Implement `ProductRepositoryImpl` (using `ProductLocalDataSource`) in `lib/features/products/data/repositories/product_repository_impl.dart`
- [ ] T020 [P] [US2] Create `productRepositoryProvider` in `lib/features/products/presentation/providers/product_providers.dart`
- [ ] T021 [US2] Create `productsProvider` (FutureProvider) in `lib/features/products/presentation/providers/product_providers.dart`
- [ ] T022 [US2] Migrate `lib/features/products/presentation/screens/products_list_screen.dart` to `ConsumerWidget`

---

## Phase 6: Dashboard Migration

**Goal**: Migrate the Dashboard screen to use Riverpod for its aggregated data fetching.

- [ ] T023 Migrate `lib/features/dashboard/presentation/screens/dashboard_screen.dart` to `ConsumerWidget`

---

## Phase 7: User Story 4 - Complex Invoice Form Migration (Priority: P3)

**Goal**: Implement Invoice repository and a Notifier to manage the complex multi-item invoice form state.

**Independent Test**: Create an invoice with 3+ items; verify real-time total calculation and validation.

### Implementation for User Story 4

- [ ] T024 [US3] Implement `InvoiceRepositoryImpl` in `lib/features/invoices/data/repositories/invoice_repository_impl.dart`
- [ ] T025 [P] [US4] Create `invoiceRepositoryProvider` in `lib/features/invoices/presentation/providers/invoice_providers.dart`
- [ ] T026 [US4] Define `InvoiceFormState` in `lib/features/invoices/presentation/providers/invoice_form_state.dart`
- [ ] T027 [US4] Create `InvoiceFormNotifier` in `lib/features/invoices/presentation/providers/invoice_form_provider.dart`
- [ ] T028 [US4] Migrate `lib/features/invoices/presentation/screens/invoice_form_screen.dart` to use `InvoiceFormNotifier`

---

## Phase 8: Polish & Cleanup

**Purpose**: Removing legacy code and final audits.

- [ ] T029 [P] Delete legacy controller `lib/app/controllers/app_settings_controller.dart`
- [ ] T030 Final check of all `setState` occurrences in the presentation layer

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Immediate start.
- **Foundational (Phase 2)**: Starts after T001-T002. Blocks all features.
- **AppSettings (Phase 3)**: High priority, should be done first as a POC.
- **Feature Migrations (Phase 4-7)**: Can proceed after Phase 2 is done.
- **Invoice Form (Phase 7)**: Depends on all repositories being available.

### Parallel Opportunities

- T003-T008 (Foundational interfaces and basic providers) can be implemented in parallel.
- Phase 4 (Customers) and Phase 5 (Products) are independent and can be done in parallel.
- Repo implementations ([US3]) can be done for multiple features simultaneously.

---

## Implementation Strategy

### Safe Incremental Path

1. **Infrastructure**: Setup Riverpod and base data providers (DB/Prefs).
2. **POC**: Migrate AppSettings. This is safe as it's global and doesn't touch complex business logic.
3. **Layering**: Implement repository interfaces. This enforces the architectural boundary before implementation.
4. **Simplification**: Migrate simple lists (Customers/Products). This replaces 50% of `setState` calls with minimal risk.
5. **Complexity**: Migrate the Invoice Form last. Use the lessons learned from earlier phases to handle its complex state.

### Preservation Rules
- Do NOT change `main_shell.dart` navigation logic yet (preserve Navigator 1.0).
- Keep all UI widgets (Screens/Cards) identical in appearance; only change the `State` management logic.
- Ensure SQLite raw queries remain inside DataSources; repositories only wrap them.
