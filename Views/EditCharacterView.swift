import SwiftUI
import CoreData
import os

struct EditCharacterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var character: FavoriteCharacter
    
    @State private var name: String = ""
    @State private var status: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Character Info")) {
                    TextField("Name", text: $name)
                    TextField("Status", text: $status)
                }
                
                Section {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Edit Character")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            })
            .onAppear {
                name = character.name ?? ""
                status = character.status ?? ""
            }
        }
    }
    
    func saveChanges() {
        character.name = name
        character.status = status
        
        do {
            try viewContext.save()
            Logger.data.info("Updated favorite character \(character.id)")
            dismiss()
        } catch {
            Logger.data.error("Error saving changes: \(error.localizedDescription)")
        }
    }
}
