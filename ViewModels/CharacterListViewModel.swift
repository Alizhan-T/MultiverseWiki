import Foundation
import Combine
import os

class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private var currentPage = 1
    private var canLoadMore = true
    private var cancellables = Set<AnyCancellable>()
    
    var filteredCharacters: [Character] {
        if searchText.isEmpty {
            return characters
        } else {
            return characters.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init() {
        setupSearch()
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if !text.isEmpty {
                    Logger.ui.debug("User searching for: \(text)")
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func loadData(reset: Bool = false) async {
        if reset {
            currentPage = 1
            characters = []
            canLoadMore = true
            errorMessage = nil
            Logger.network.info("Reloading data from scratch...")
        }
        
        guard !isLoading && canLoadMore else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            Logger.network.info("Requesting page \(self.currentPage)...")
            
            let newCharacters = try await NetworkService.shared.fetchCharacters(page: currentPage)
            
            if newCharacters.isEmpty {
                canLoadMore = false
                Logger.network.notice("No more characters to load.")
            } else {
                characters.append(contentsOf: newCharacters)
                currentPage += 1
                Logger.network.info("Successfully loaded \(newCharacters.count) items.")
            }
            
        } catch {
            Logger.network.error("Network Error: \(error.localizedDescription)")
            self.errorMessage = "Не удалось загрузить данные. Проверьте интернет."
        }
        
        isLoading = false
    }
    
    func shouldLoadMore(currentCharacter: Character) {
        if characters.last?.id == currentCharacter.id {
            Task {
                await loadData()
            }
        }
    }
    
    func retry() {
        Logger.ui.info("User tapped Retry button")
        Task {
            await loadData(reset: true) 
        }
    }
}
