import Foundation

struct StoryGenerator {
    
    static func generate(for character: Character) -> String {
        let intro = "According to galactic archives, \(character.name) is a \(character.species) originating from \(character.origin.name)."
        
        var statusStory = ""
        switch character.status {
        case "Alive":
            statusStory = "Currently hiding from the Galactic Federation and considered highly dangerous."
        case "Dead":
            statusStory = "Unfortunately, records confirm this character perished under mysterious circumstances in dimension C-137."
        default:
            statusStory = "Current location unknown. Possibly lost in a micro-verse."
        }
        
        let secrets = [
            "Rumored to have stolen a portal gun once.",
            "Loves Szechuan sauce more than life itself.",
            "Secret files say they hate Jerry Smith.",
            "Owns an illegal Plumbus farm.",
            "Was seen hanging out with Birdperson.",
            "The only one who knows how to escape the simulation.",
            "Secretly works for the Citadel of Ricks.",
            "Beat Krombopulos Michael at cards once.",
            "Suffers from an existential crisis every morning.",
            "Tried to sell anti-matter to high schoolers."
        ]
        
        let index = character.id % secrets.count
        let uniqueFact = secrets[index]
        
        return "\(intro)\n\n\(statusStory)\n\nSECRET FACT: \(uniqueFact)"
    }
}
