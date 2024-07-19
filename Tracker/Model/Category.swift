import Foundation

struct Category: Identifiable, Codable {
    var id: UUID
    var name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
