import SwiftUI
import CoreData

 struct ContentView: View {
    @Binding var isLoggedIn: Bool
    var body: some View {
        TabView {
             MainCharacterListView()
                .tabItem {
                    Label("Characters", systemImage: "person.3")
                }

             FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
             ProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

 struct MainCharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    
     @Namespace private var animation
    @State private var selectedCharacter: Character? = nil
    @State private var showDetail = false
    
    var body: some View {
        ZStack {
             NavigationView {
                List(viewModel.filteredCharacters) { character in
                    HStack {
                         if selectedCharacter?.id != character.id {
                            AsyncImage(url: URL(string: character.image)) { phase in
                                if let image = phase.image {
                                    image.resizable().scaledToFit()
                                } else {
                                    Color.gray.opacity(0.3)
                                }
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .matchedGeometryEffect(id: character.id, in: animation)
                        } else {
                             Circle().fill(Color.clear).frame(width: 50, height: 50)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(character.name).font(.headline)
                            Text(character.status)
                                .font(.subheadline)
                                .foregroundColor(character.status == "Alive" ? .green : .red)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            selectedCharacter = character
                            showDetail = true
                        }
                    }
                    .onAppear { viewModel.shouldLoadMore(currentCharacter: character) }
                }
                .navigationTitle("Rick & Morty")
                .searchable(text: $viewModel.searchText)
                .task { await viewModel.loadData() }
            }
            .opacity(showDetail ? 0 : 1) // Скрываем список, когда открываем детали

             if let character = selectedCharacter, showDetail {
                CharacterDetailView(character: character, animation: animation) {
                    // Действие при закрытии (крестик)
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showDetail = false
                        selectedCharacter = nil
                    }
                }
                .zIndex(2)
            }
        }
    }
}
