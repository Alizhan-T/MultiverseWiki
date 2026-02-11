import SwiftUI
import Combine

@MainActor
class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var searchText = "" // 1. Текст поиска
    
    private var currentPage = 1
    private var isFetching = false

    var filteredCharacters: [Character] {
        if searchText.isEmpty {
            return characters
        } else {
            return characters.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func loadData() async {
        guard !isFetching else { return }
        isFetching = true
        
        do {
            let newCharacters = try await NetworkService.shared.fetchCharacters(page: currentPage)
            self.characters.append(contentsOf: newCharacters)
            currentPage += 1
        } catch {
            print(error.localizedDescription)
        }
        isFetching = false
    }
    
    func shouldLoadMore(currentCharacter item: Character) {
        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -3)
        if characters.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            Task {
                await loadData()
            }
        }
    }
}
