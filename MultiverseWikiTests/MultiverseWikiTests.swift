import XCTest
@testable import MultiverseWiki

@MainActor
final class MultiverseWikiTests: XCTestCase {

     func createMockCharacter(id: Int, name: String, status: String) -> Character {
        return Character(
            id: id,
            name: name,
            status: status,
            species: "Human",
            gender: "Male",
             image: "http://example.com/image.png",
            origin: Origin(name: "Earth", url: "")
        )
    }

 
    func testStoryGenerator_Deterministic() {
        let rick = createMockCharacter(id: 1, name: "Rick", status: "Alive")
        let story1 = StoryGenerator.generate(for: rick)
        let story2 = StoryGenerator.generate(for: rick)
        
        XCTAssertEqual(story1, story2, "Stories must be identical for the same ID")
    }
    
    func testStoryGenerator_UniqueSecrets() {
        let char1 = createMockCharacter(id: 1, name: "A", status: "Alive")
        let char2 = createMockCharacter(id: 2, name: "B", status: "Alive")
        
        XCTAssertNotEqual(StoryGenerator.generate(for: char1), StoryGenerator.generate(for: char2))
    }
    
    func testStoryGenerator_DeadStatus() {
        let deadChar = createMockCharacter(id: 3, name: "Dead Guy", status: "Dead")
        let story = StoryGenerator.generate(for: deadChar)
        
        let isDeadContent = story.contains("perished") || story.contains("Dead") || story.contains("records confirm")
        XCTAssertTrue(isDeadContent)
    }
    
    func testStoryGenerator_AliveStatus() {
        let aliveChar = createMockCharacter(id: 4, name: "Alive Guy", status: "Alive")
        let story = StoryGenerator.generate(for: aliveChar)
        
        let isAliveContent = story.contains("hiding") || story.contains("Alive") || story.contains("dangerous")
        XCTAssertTrue(isAliveContent)
    }

 
    func testCharacterDecoding() throws {
         let json = """
        {
            "id": 1, 
            "name": "Rick", 
            "status": "Alive", 
            "species": "Human", 
            "gender": "Male",
            "image": "http://img.com",
            "origin": {"name": "Earth", "url": ""}
        }
        """.data(using: .utf8)!
        
        let character = try JSONDecoder().decode(Character.self, from: json)
        XCTAssertEqual(character.name, "Rick")
    }

 
    func testViewModel_InitialState() {
        let vm = CharacterListViewModel()
        XCTAssertTrue(vm.characters.isEmpty)
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.errorMessage)
    }
    
    func testViewModel_SearchFilter() {
        let vm = CharacterListViewModel()
        let char1 = createMockCharacter(id: 1, name: "Rick", status: "Alive")
        let char2 = createMockCharacter(id: 2, name: "Morty", status: "Alive")
        
        vm.characters = [char1, char2]
        vm.searchText = "Rick"
        
        XCTAssertEqual(vm.filteredCharacters.count, 1)
        XCTAssertEqual(vm.filteredCharacters.first?.name, "Rick")
    }
    
    func testAPIResponseDecoding() throws {
        let json = """
        {
            "info": {"count": 100, "pages": 5, "next": null, "prev": null},
            "results": []
        }
        """.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(APIResponse.self, from: json)
        XCTAssertNotNil(response)
    }
}
