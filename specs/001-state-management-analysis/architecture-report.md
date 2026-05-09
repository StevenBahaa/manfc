# Architecture Report: State Management Analysis

## Folder Structure

The project follows a **Feature-based with Layered Architecture (Clean Architecture Lite)** pattern.

### Core Folders
- **lib/app**: Contains global application logic, including the main app widget (`app.dart`), navigation shell, theme definitions, and global controllers (e.g., `AppSettingsController`).
- **lib/core**: Houses cross-cutting concerns and low-level infrastructure, such as database configuration (`database/`), error handling, common services, and utility functions.
- **lib/features**: The primary directory for business logic, organized by feature (e.g., `customers`, `invoices`, `products`).
- **lib/shared**: Contains components reused across multiple features, including common models, UI widgets, and extensions.
- **lib/l10n**: Dedicated to localization, containing ARB files and generated localization classes.
- **lib/main.dart**: The entry point of the application.

### Organization Pattern Details (lib/app & lib/features)

- **lib/app**:
    - `controllers/`: Global controllers (e.g., `AppSettingsController`).
    - `navigation/`: Navigation-related widgets like `MainShell` and tab management.
    - `theme/`: Global theme and color definitions.
    - `widgets/`: App-wide widgets.
- **lib/features/[feature_name]**:
    - Each feature strictly follows a three-layer structure:
        - `domain/`: Business entities and repository interfaces.
        - `data/`: Data sources (local/remote) and repository implementations.
        - `presentation/`: UI-related code, typically split into `screens/`, `widgets/`, and an empty `providers/` folder (reserved for future state management).


## App Size and Complexity

The application is currently in the **small to medium** size range, with a focused set of features.

### Component Breakdown
- **Screens**: 9 functional screens (Dashboard, Products, Customers, Invoices, Settings, and respective detail/form screens).
- **Widgets**: 16 dedicated UI components (10 feature-specific and 6 app-wide shared widgets).
- **Entities**: 5 core domain entities (Customer, Invoice, InvoiceItem, Payment, Product).

### Complexity Assessment
The project follows a clean layered structure which adds architectural complexity, but the total number of components is manageable. The business logic is primarily centered around CRUD operations for sales and inventory management.

## Controllers, Services, and Repositories

### Controllers
- **Global**: `AppSettingsController` (`lib/app/controllers/app_settings_controller.dart`) manages global settings like theme and language.
- **Feature-level**: No dedicated feature controllers were found. Business logic and state management for features are currently embedded directly within the UI (using `setState`).

### Services
- **Core Services**: Found in `lib/core/services/`:
    - `BackupService`: Likely handles data export/import.
    - `PdfService`: Handles PDF generation for invoices.
    - `PrintService`: Handles printing functionality.

### Repositories and Data Sources
- **Data Sources**: The project uses local data sources located in `lib/features/[feature]/data/datasources/`:
    - `CustomerLocalDatasource`
    - `InvoiceLocalDatasource`
    - `PaymentLocalDataSource`
    - `ProductLocalDatasource`
- **Repositories**: While directory structures exist for repositories (e.g., `lib/features/customers/data/repositories/`), they are currently **empty**. This indicates that the repository layer is planned but not yet implemented, with the UI likely interacting directly with data sources.


## State Management (setState usage)

The application relies heavily on **ephemeral state management** using Flutter's native `setState`.

### Findings
- **Total `setState` calls**: 47 occurrences across the `lib/` directory.
- **Affected Files**: 13 files, primarily screen and widget implementations in the presentation layer.
- **Usage Patterns**:
    - **Loading States**: Managing `_isLoading` or `_isSaving` flags during async operations (e.g., `customers_list_screen.dart`, `invoice_form_screen.dart`).
    - **UI Updates**: Triggering rebuilds for simple property changes or list updates (e.g., `main_shell.dart`, `app_search_field.dart`).
    - **Form Feedback**: Real-time validation or visibility toggling (e.g., `add_payment_sheet.dart`).

### Implications
While effective for local UI state, the high frequency of `setState` in complex forms like `invoice_form_screen.dart` (where it's used 9 times) suggests that state is becoming difficult to track and might benefit from a more structured reactive approach or decoupled controllers.

Based on `pubspec.yaml`, there are **no external state management packages** (like Riverpod, Bloc, or Provider) currently installed. This indicates a reliance on Flutter's native state management solutions (`setState`, `ChangeNotifier`, `ValueNotifier`).

## Routing Style

The application uses **Navigator 1.0 (Imperative Navigation)** with a **Tab-based Shell** architecture.

### Findings
- **Main Shell**: `lib/app/navigation/main_shell.dart` implements the top-level navigation using a `Scaffold` with a `NavigationBar` and an `IndexedStack`.
- **Navigation Logic**: Switching between main tabs is handled via `setState` within `MainShell`, changing the `_currentIndex` of the `IndexedStack`.
- **Route Configuration**: `MaterialApp` (in `lib/app/app.dart`) does not define `routes` or `onGenerateRoute`. It sets `MainShell` as the `home` widget.
- **Deep Linking / Named Routes**: No support for named routes or deep linking was observed. Navigation to sub-screens (e.g., detail or form screens) likely relies on direct `Navigator.push` calls with `MaterialPageRoute`.

### Implications
While simple and sufficient for the current app size, the lack of a formal routing table or a package like `go_router` makes it harder to manage complex navigation state or implement deep links in the future.

## API / Data Fetching Pattern

The application currently operates on a **local-first** basis, with no remote API integrations detected.

### Findings
- **Remote Networking**: No usage of `http`, `dio`, or native `HttpClient` was found in the codebase.
- **Local Data Persistence**: Data is managed locally using the **`sqflite`** package.
- **Implementation**:
    - **Local DataSources**: Feature-specific classes (e.g., `InvoiceLocalDataSource`) in `lib/features/[feature]/data/datasources/` encapsulate SQLite interactions.
    - **Query Pattern**: Uses raw or semi-structured SQL queries via the `sqflite` `db.query`, `db.insert`, etc., methods.
    - **Transactions**: Complex operations (like saving an invoice with its line items) are wrapped in `db.transaction` to ensure data integrity.
    - **Asynchrony**: All data-fetching methods return `Future` objects, which are then consumed by the UI layer.

### Implications
The current architecture is well-suited for an offline-only application. However, if remote synchronization or a backend integration is required in the future, a repository layer (which is currently defined but empty) will be critical to abstracting the source of data (local vs. remote) from the rest of the application.

## Form Handling

The application uses **Standard Flutter Form widgets** and **TextEditingControllers** for data entry and validation.

### Findings
- **Form Architecture**: Uses the native `Form` widget coupled with `GlobalKey<FormState>` for form-level operations (validation, saving).
- **Input Management**: Relies heavily on `TextEditingController` for managing the state of text inputs. These are typically managed within `StatefulWidget` states.
- **Validation Pattern**:
    - **Synchronous Validation**: Uses the `validator` property of `TextFormField` or custom input widgets.
    - **Methods**: Validation logic is often extracted into private methods within the widget state (e.g., `_validateName`, `_validatePhone`, `_validatePrice`).
- **Feedback**: Validation errors are displayed using the built-in error text support of standard Flutter inputs.
- **Complexity**: In more complex scenarios, like `invoice_form_screen.dart`, multiple controllers are used to manage a dynamic list of items, adding significant state overhead to the UI layer.

### Implications
The manual management of multiple `TextEditingController` instances and the tight coupling of validation logic to UI widgets increases the risk of memory leaks (if not disposed correctly) and makes the forms harder to unit test independently of the UI.

## Authentication and Session State

There is currently **no authentication or session management system** implemented in the application.

### Findings
- **Access Control**: The application is fully accessible upon launch without any login requirement.
- **User Identity**: No `User` entity, `AuthService`, or persistent token management (e.g., JWT) was found in the codebase.
- **Session Persistent State**: The only persistent "session-like" state is managed by `AppSettingsController`, which stores user preferences for theme and language.
- **Settings Feature**: The `SettingsScreen` (`lib/features/settings/presentation/screens/settings_screen.dart`) focuses exclusively on appearance and localization, with no profile or account management sections.

### Implications
The app operates as a local, single-user tool. If multi-user support or cloud synchronization is added, a comprehensive authentication layer and session state management (likely utilizing a global provider) will need to be architected from scratch.

## Local Storage Usage

The application utilizes two primary storage mechanisms for local data persistence.

### Findings
- **`shared_preferences`**:
    - **Usage**: Managed via `AppSettingsController` (`lib/app/controllers/app_settings_controller.dart`).
    - **Purpose**: Persisting lightweight app settings such as `theme_mode` and `language_code`.
- **`sqflite` (SQLite)**:
    - **Architecture**: Centralized management in `AppDatabase` (`lib/core/database/app_database.dart`).
    - **Data Persistence**: Powering local data sources across all major features (Customers, Invoices, Payments, Products).
    - **Pattern**: Standard SQL-based interactions for structured relational data.

### Implications
The heavy reliance on `sqflite` for business data confirms the "local-first" nature of the application. The storage layer is well-decoupled into data sources, but since there is no centralized state management package, the UI frequently queries these storage layers directly or via simple controllers, leading to asynchronous code mixed with UI logic.

