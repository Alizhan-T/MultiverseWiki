import SwiftUI
import CoreData

struct CharacterDetailView: View {
    let character: Character
    var animation: Namespace.ID
    var closeAction: () -> Void
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isSaved = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: character.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        Color.gray.opacity(0.3)
                    }
                }
                .matchedGeometryEffect(id: character.id, in: animation)
                .frame(height: 350)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(character.name)
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        Button(action: {
                            addToFavorites(context: viewContext)
                            isSaved = true
                        }) {
                            Image(systemName: isSaved ? "heart.fill" : "heart")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                        .disabled(isSaved)
                    }
                    
                    HStack {
                        StatusBadge(status: character.status)
                        Spacer()
                        Text(character.species)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    InfoRow(icon: "person", label: "Gender", value: character.gender)
                    InfoRow(icon: "globe", label: "Origin", value: character.origin.name)
                }
                .padding()
                
                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.top)
        
        .overlay(
            Button(action: closeAction) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Circle().fill(Color.black.opacity(0.6)))
                    .shadow(radius: 5)
            }
            .padding(.top, 50)
            .padding(.trailing, 20)
            , alignment: .topTrailing
        )
    }
}


struct StatusBadge: View {
    let status: String
    var color: Color {
        switch status {
        case "Alive": return .green
        case "Dead": return .red
        default: return .gray
        }
    }
    var body: some View {
        Text(status)
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    var body: some View {
        HStack {
            Image(systemName: icon).frame(width: 30).foregroundColor(.blue)
            Text(label).foregroundColor(.gray)
            Spacer()
            Text(value).bold()
        }
    }
}


extension CharacterDetailView {
    func addToFavorites(context: NSManagedObjectContext) {
        let request: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", Int64(character.id))
        
        do {
            let count = try context.count(for: request)
            if count == 0 {
                let favorite = FavoriteCharacter(context: context)
                favorite.id = Int64(character.id)
                favorite.name = character.name
                favorite.status = character.status
                favorite.species = character.species
                favorite.gender = character.gender
                favorite.image = character.image
                try context.save()
                print("Saved!")
            } else {
                print("Already saved")
            }
        } catch { print(error) }
    }
}
