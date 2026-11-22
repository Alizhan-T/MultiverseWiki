# Contributing to MultiverseWiki

Thank you for your interest in contributing to **MultiverseWiki**. This guide outlines the workflow and quality standards used in this repository.

## Development Setup

1. Fork and clone the repository:
   ```bash
   git clone https://github.com/Alizhan-T/MultiverseWiki.git
   cd MultiverseWiki
   ```
2. Configure Firebase locally:
   - Copy `GoogleService-Info.plist.example` to `GoogleService-Info.plist` and populate it with your Firebase iOS app credentials from the Firebase Console.
   - Do **not** commit `GoogleService-Info.plist` (it is ignored by `.gitignore`).
3. Open `MultiverseWiki.xcodeproj` in Xcode and allow Swift Package Manager to resolve dependencies (`firebase-ios-sdk`).

## Branching & Commit Guidelines

- Create a dedicated branch from `main` for each change:
  - `feat/<short-description>` for new features
  - `fix/<short-description>` for bug fixes
  - `docs/<short-description>` for documentation updates
  - `refactor/<short-description>` for structural improvements
- Write clear, imperative commit messages (e.g., `Add disk-backed image caching for character avatars`).

## Code & Architecture Standards

- Follow the existing **MVVM** separation:
  - Keep SwiftUI `Views/` declarative and free of networking or decoding logic.
  - Place state transitions, pagination, and filtering in `ViewModels/`.
  - Isolate API calls, persistence, and system monitors under `Services/`.
- Use structured `OSLog` (`Logger.network`, `Logger.data`, `Logger.ui`) instead of `print()` in production code.
- Ensure all UI state mutations run on `@MainActor`.

## Testing Requirements

Before opening a pull request:
1. Run the unit test suite in Xcode (`Cmd + U`) and verify all tests in `MultiverseWikiTests` pass.
2. Add or update unit tests for any new business logic, models, or ViewModel behaviors.
3. Verify offline behavior (Airplane Mode / disabled network) and Light/Dark Mode readability on an iOS Simulator.

## Submitting a Pull Request

- Fill out the pull request template completely.
- Keep pull requests focused on a single concern.
- Include screenshots or recordings for UI changes.
