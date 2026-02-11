import Foundation

struct APIResponse: Codable {
    let results: [Character]
}

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String     
    let image: String
    let origin: Origin
}

struct Origin: Codable {
    let name: String
    let url: String
}
