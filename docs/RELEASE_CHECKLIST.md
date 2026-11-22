# Release Readiness Checklist — v1.0.0

Pre-release verification matrix for **MultiverseWiki v1.0.0**.

## 1. Authentication & Session Management
- [x] `LoginView` validates non-empty email and password before Firebase requests.
- [x] Sign-up and sign-in flows authenticate via `FirebaseAuth` and transition to `ContentView`.
- [x] Active session (`Auth.auth().currentUser`) restores automatically on relaunch.
- [x] `ProfileView` displays current user email and signs out cleanly.

## 2. Core Directory & Search Functionality
- [x] App launches cleanly on iOS Simulator without runtime crashes.
- [x] Initial page of characters loads asynchronously from the Rick & Morty API.
- [x] Infinite pagination triggers automatically when scrolling to the last item (`shouldLoadMore`).
- [x] Case-insensitive search filters characters cleanly via `CharacterListViewModel`.
- [x] Selecting a character navigates to `CharacterDetailView`.

## 3. Offline Persistence & Network Resilience
- [x] Disabling Wi-Fi displays the `OFFLINE MODE` indicator in `CharacterDetailView`.
- [x] Initial load failure renders the `Connection error` overlay with a functional `Try again` button.
- [x] Core Data (`MultiverseData`) persists favorited characters and dossiers across app restarts.
- [x] Saved favorites remain viewable (`FavoriteDetailView`), editable (`EditCharacterView`), and deletable offline.
- [x] Network calls use Swift `async/await` and `@MainActor` without blocking the main thread.

## 4. Domain Logic & Observability
- [x] `StoryGenerator` generates deterministic dossiers keyed by `character.id` and `status`.
- [x] Favorite heart toggle accurately reflects and updates Core Data records.
- [x] Structured logging via `OSLog` (`Logger.network`, `Logger.data`, `Logger.ui`) is active across core flows.

## 5. UI / UX & Release Configuration
- [x] Remote avatars render via `AsyncImage` with placeholder fallback states.
- [x] System color tokens (`Color(.systemBackground)`, `.secondary`) maintain readability in Light and Dark Mode.
- [x] Marketing version set to `1.0` (`MARKETING_VERSION = 1.0`).
- [x] Unit test suite (`MultiverseWikiTests`) passes (`8/8` tests).
- [x] Repository hygiene verified (`GoogleService-Info.plist` excluded via `.gitignore`; no `xcuserdata` tracked).
