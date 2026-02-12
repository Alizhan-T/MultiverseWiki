import SwiftUI

struct FavoriteDetailView: View {
    let favorite: FavoriteCharacter  
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                 if let imageLink = favorite.image, let url = URL(string: imageLink) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .cornerRadius(20)
                    .frame(height: 350)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(favorite.name ?? "Unknown")
                        .font(.largeTitle)
                        .bold()
                    
                     if let savedStory = favorite.story, !savedStory.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("SAVED STORY")
                                .font(.caption).bold().foregroundColor(.green)
                            
                            Text(savedStory)
                                .font(.body)
                                .italic()
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(12)
                        }
                    } else {
                        Text("No story archives found.")
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    InfoRow(icon: "heart.text.square", label: "Status", value: favorite.status ?? "-")
                    InfoRow(icon: "person.fill", label: "Species", value: favorite.species ?? "-")
                }
                .padding()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
