import Foundation

struct Item: Identifiable {
    let id: UUID
    let name: String
    let category: String
    let produceDay: Date
    let expirationDay: Date
    
    init(id: UUID = UUID(), name: String, category: String, produceDay: Date, expirationDay: Date) {
        self.id = id
        self.name = name
        self.category = category
        self.produceDay = produceDay
        self.expirationDay = expirationDay
    }
}
