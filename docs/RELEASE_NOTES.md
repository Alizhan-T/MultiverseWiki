# Release Notes — Version 1.0.0

**Release:** `v1.0.0`  
**Platform:** iOS (Swift 5 / SwiftUI)

---

## Highlights

- **Firebase Authentication:** Full email/password registration, sign-in, persistent session detection, and profile sign-out powered by `firebase-ios-sdk` (`12.9.0`).
- **Paginated Multiverse Explorer:** Infinite-scroll character catalog backed by the Rick and Morty REST API using modern Swift `async/await` networking.
- **Offline-First Favorites (Core Data CRUD):** Save characters locally with full offline detail browsing, inline editing (`EditCharacterView`), swipe-to-delete, and context menu management.
- **Deterministic Secret Dossiers:** Procedurally generated character lore seeded deterministically by `character.id` and status.
- **Network Resilience:** Live connectivity detection via `NWPathMonitor` (`NetworkMonitor`), offline status badges, and graceful error recovery with one-tap retry.

---

## Engineering & Quality Improvements

- **MVVM Architecture:** Clean separation of SwiftUI views, `@MainActor` `CharacterListViewModel`, `NetworkService`, `PersistenceController`, and domain helpers.
- **Structured Observability:** Adopted Apple's unified `OSLog` framework across `Network`, `CoreData`, and `UI` categories.
- **Automated Unit Tests:** Added 8 `XCTest` cases in `MultiverseWikiTests` covering deterministic lore generation, `Codable` JSON decoding, initial ViewModel state, and search filtering.

---

## Known Limitations

- **Avatar Caching:** Character thumbnails use SwiftUI `AsyncImage` with default `URLCache`; full offline avatar rendering after cache eviction is planned for a future release.
- **Client-Side Search Scope:** Search currently filters characters already fetched across paginated pages rather than querying the server-side `?name=` endpoint.
- **Firebase Configuration:** Developers building from source must supply their own `GoogleService-Info.plist` (template provided in `GoogleService-Info.plist.example`).
