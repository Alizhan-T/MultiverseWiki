# Changelog

All notable changes to **MultiverseWiki** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-20

### Added
- **Firebase Authentication Flow:** Email/password sign-up, sign-in, session restoration (`Auth.auth().currentUser`), and sign-out via `LoginView` and `ProfileView`.
- **Paginated Character Explorer:** Infinite-scroll character directory backed by the Rick and Morty REST API (`NetworkService`) using Swift `async/await` and `URLSession`.
- **Debounced Search Filtering:** Reactive Combine pipeline (`0.5s` debounce + deduplication) with case-insensitive filtering in `CharacterListViewModel`.
- **Offline-First Favorites (Core Data CRUD):** Local persistence via `PersistenceController` and `FavoriteCharacter` entity supporting save/unsave toggle, offline inspection (`FavoriteDetailView`), inline record editing (`EditCharacterView`), swipe-to-delete, and context menus.
- **Deterministic Secret Dossier Engine:** `StoryGenerator` producing consistent, character-ID-seeded dossiers derived from species, origin, and status.
- **Network Connectivity & Error Recovery:** `NetworkMonitor` (`NWPathMonitor` + `Combine`), offline indicator banner, and full-screen error overlay with one-tap retry.
- **Structured Logging:** `OSLog` categories (`Network`, `CoreData`, `UI`) via `Logger+Extension`.
- **Unit Test Suite:** 8 `XCTest` cases in `MultiverseWikiTests` verifying deterministic story generation, JSON decoding, and `CharacterListViewModel` state and filtering.
- **Engineering Documentation:** Architecture specification, QA defect log, release checklist, release notes, and App Store listing draft in `docs/`.

### Fixed
- Resolved offline launch crashes by introducing `NetworkMonitor` and graceful error overlays with retry support.
- Stabilized `StoryGenerator` output to be deterministic per `character.id`.
- Replaced fragile UI tests with focused, deterministic unit tests.
- Aligned `Character` and `APIResponse` decoding models with API payloads.
