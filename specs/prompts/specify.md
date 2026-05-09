Create a safe incremental Riverpod migration plan for this Flutter app based on the completed architecture analysis and recommendation.

Requirements:
- preserve current UI
- preserve routing
- do not rewrite the app
- migrate feature-by-feature
- implement repository layer properly
- use flutter_riverpod
- reduce setState usage gradually
- start with the simplest feature first
- avoid breaking current functionality
- support future API synchronization
- keep SQLite architecture intact
- improve testability

The migration must:
1. add ProviderScope
2. implement repository interfaces
3. create providers for repositories
4. migrate global settings state
5. migrate one simple feature first
6. migrate complex invoice form last

Do not implement yet.
Only create the specification.