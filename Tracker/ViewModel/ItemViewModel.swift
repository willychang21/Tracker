import Foundation
import SwiftUI

class ItemViewModel: ObservableObject, Identifiable {
    let id: UUID
    @Published var name: String
    @Published var category: String
    @Published var produceDay: Date
    @Published var expirationDay: Date
    
    init(item: Item) {
        self.id = item.id
        self.name = item.name
        self.category = item.category
        self.produceDay = item.produceDay
        self.expirationDay = item.expirationDay
    }
    
    func toItem() -> Item {
        return Item(id: id, name: name, category: category, produceDay: produceDay, expirationDay: expirationDay)
    }
}
