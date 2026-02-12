# Architecture Overview

The app follows the **MVVM (Model-View-ViewModel)** pattern combined with **Clean Architecture** principles.

## 🏗 High-Level Diagram

[ View (SwiftUI) ] <---> [ ViewModel (State) ] <---> [ Service Layer ]
       ^                          ^                        ^
       |                          |                        |
User Actions              Business Logic           API / CoreData

## 🧩 Layers

### 1. Presentation Layer (Views)
- **Framework:** SwiftUI.
- **Responsibility:** Displays UI and observes ViewModels.
- **Key Components:**
  - `CharacterDetailView`: Displays character info & generated story.
  - `FavoritesView`: Lists saved characters from Core Data.

### 2. Logic Layer (ViewModels)
- **Responsibility:** Manages state, handles user intent, calls services.
- **Key Components:**
  - `CharacterListViewModel`: Handles pagination, search, and error states.

### 3. Data Layer (Services)
- **NetworkService:** Fetches data from Rick & Morty API using `URLSession` and `async/await`.
- **CoreData:** Persists favorite characters for **Offline Mode**.
- **StoryGenerator:** Helper class that procedurally generates unique lore for characters.

### 4. Utilities
- **NetworkMonitor:** Uses `Combine` and `NWPathMonitor` to detect internet connection.
- **Logger:** Custom logging system for debugging vs release.
