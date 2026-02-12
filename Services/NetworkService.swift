import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func fetchCharacters(page: Int) async throws -> [Character] {
        let urlString = "https://rickandmortyapi.com/api/character/?page=\(page)"
        
        guard let url = URL(string: urlString) else { return [] }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        return decodedResponse.results
    }
}
