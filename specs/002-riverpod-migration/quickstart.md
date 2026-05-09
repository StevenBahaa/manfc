# Quickstart: Riverpod in manfc

## 1. Accessing Global Settings
Wrap your widget in a `ConsumerWidget` and use `ref.watch`:

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    
    return settings.when(
      data: (s) => Text("Theme: ${s.themeMode}"),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text("Error: $e"),
    );
  }
}
```

## 2. Fetching Lists (Customers/Products)
Providers handle the loading and error states automatically:

```dart
class CustomerListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersProvider);
    
    return customersAsync.when(
      data: (customers) => ListView(...),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => ErrorWidget(err),
    );
  }
}
```

## 3. Modifying State
Use the notifier of the provider:

```dart
ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark);
```

## 4. Code Generation
Always run the builder when adding or changing providers:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
