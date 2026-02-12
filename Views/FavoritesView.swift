import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteCharacter.name, ascending: true)],
        animation: .default)
    private var favorites: FetchedResults<FavoriteCharacter>
    
    @State private var characterToEdit: FavoriteCharacter?

    var body: some View {
        NavigationView {
            List {
                ForEach(favorites) { favorite in
                     NavigationLink(destination: FavoriteDetailView(favorite: favorite)) {
                        HStack {
                            if let imageLink = favorite.image, let url = URL(string: imageLink) {
                                AsyncImage(url: url) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            }
                            
                            VStack(alignment: .leading) {
                                Text(favorite.name ?? "Unknown").font(.headline)
                                Text(favorite.status ?? "Unknown")
                                    .font(.subheadline)
                                    .foregroundColor(favorite.status == "Alive" ? .green : .red)
                            }
                        }
                    }
                     .contextMenu {
                        Button { characterToEdit = favorite } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive) { deleteCharacter(favorite) } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) { deleteCharacter(favorite) } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .sheet(item: $characterToEdit) { character in
                EditCharacterView(character: character)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private func deleteCharacter(_ character: FavoriteCharacter) {
        withAnimation {
            viewContext.delete(character)
            try? viewContext.save()
        }
    }
}
