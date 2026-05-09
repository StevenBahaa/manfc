# Data Model: Riverpod State Management

## Provider Hierarchy

```mermaid
graph TD
    PS[ProviderScope] --> SP[SharedPreferencesProvider]
    PS --> DB[DatabaseProvider]
    
    SP --> ST[SettingsProvider]
    
    DB --> CDS[CustomerDataSourceProvider]
    CDS --> CR[CustomerRepositoryProvider]
    CR --> CL[CustomerListProvider]
    
    DB --> PDS[ProductDataSourceProvider]
    PDS --> PR[ProductRepositoryProvider]
    PR --> PL[ProductListProvider]
    
    DB --> IDS[InvoiceDataSourceProvider]
    IDS --> IR[InvoiceRepositoryProvider]
    IR --> IL[InvoiceListProvider]
    IR --> IF[InvoiceFormProvider]
```

## Entities & State

### SettingsState
- **themeMode**: `ThemeMode` (light, dark, system)
- **locale**: `Locale` (en, ar)

### AsyncValue<T>
- Used for all repository-backed data.
- **States**: `Loading`, `Error(Object, StackTrace)`, `Data(T)`.

### InvoiceFormState
- **invoice**: `InvoiceModel` (the current draft)
- **isSaving**: `bool`
- **validationErrors**: `Map<String, String>`
- **items**: `List<InvoiceItemModel>`
