import SwiftUI
import CoreData

struct CharacterDetailView: View {
    let character: Character
    var animation: Namespace.ID
    var closeAction: () -> Void
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var network = NetworkMonitor()
    
     @State private var isFavorite = false
    
     var generatedStory: String {
        return StoryGenerator.generate(for: character)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 1. КАРТИНКА + КРЕСТИК
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: character.image)) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 20))
                        } else {
                            Color.gray.opacity(0.3)
                        }
                    }
                    .matchedGeometryEffect(id: character.id, in: animation)
                    .frame(height: 350)
                    
                    Button(action: closeAction) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.black.opacity(0.4)))
                    }
                    .padding(.top, 40)
                    .padding(.trailing, 20)
                }

                VStack(alignment: .leading, spacing: 15) {
                     if !network.isConnected {
                        Label("OFFLINE MODE", systemImage: "wifi.slash")
                            .font(.caption).bold()
                            .padding(6)
                            .background(Color.orange.opacity(0.2))
                            .foregroundColor(.orange)
                            .cornerRadius(5)
                    }

                     HStack {
                        Text(character.name)
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: toggleFavorite) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 30))
                                .foregroundColor(isFavorite ? .red : .gray)
                                .padding(10)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }

                     VStack(alignment: .leading, spacing: 10) {
                        Text("SECRET DOSSIER")
                            .font(.caption).bold().foregroundColor(.blue)
                        
                        Text(generatedStory)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue.opacity(0.05)))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue.opacity(0.2), lineWidth: 1))
                    }
                    
                     InfoRow(icon: "globe", label: "Origin", value: character.origin.name)
                    InfoRow(icon: "person.fill", label: "Species", value: character.species)
                    InfoRow(icon: "heart.text.square", label: "Status", value: character.status)
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            checkIfSaved()
        }
    }

 
     func checkIfSaved() {
        let request: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", Int64(character.id))
        
        do {
            let count = try viewContext.count(for: request)
            isFavorite = count > 0
        } catch { print(error) }
    }
    
     func toggleFavorite() {
        let request: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", Int64(character.id))
        
        do {
            let results = try viewContext.fetch(request)
            
            if let existing = results.first {
                 viewContext.delete(existing)
                isFavorite = false
            } else {
                 let newEntry = FavoriteCharacter(context: viewContext)
                newEntry.id = Int64(character.id)
                newEntry.name = character.name
                newEntry.image = character.image
                newEntry.status = character.status
                newEntry.species = character.species
                newEntry.story = generatedStory
                
                isFavorite = true
            }
            try viewContext.save()  
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
}
