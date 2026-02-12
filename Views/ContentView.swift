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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.filteredCharacters) { character in
                    NavigationLink(destination: CharacterDetailView(
                        character: character,
                        animation: Namespace().wrappedValue,
                        closeAction: {}
                    )) {
                        HStack {
                            AsyncImage(url: URL(string: character.image)) { img in
                                img.resizable().scaledToFit()
                            } placeholder: { Color.gray.opacity(0.3) }
                            .frame(width: 50, height: 50).clipShape(Circle())
                            
                            Text(character.name).font(.headline)
                        }
                    }
                    .onAppear {
                        viewModel.shouldLoadMore(currentCharacter: character)
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView().frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Characters")
            .task {
                await viewModel.loadData()
            }
            .overlay {
                if let error = viewModel.errorMessage, viewModel.characters.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("Connection error")
                            .font(.title2).bold()
                        
                        Text(error)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.retry()
                        }) {
                            Text("Try again")
                                .bold()
                                .padding()
                                .frame(width: 200)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                }
            }
        }
    }
}
