import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var categoryViewModel = CategoryViewModel()
    
    func addItem(item: Item) {
        items.append(item)
    }
    
    func updateItem(updatedItem: ItemViewModel) {
        if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
            items[index] = updatedItem.toItem()
        }
    }
    
    func daysLeftText(for item: Item) -> String {
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: item.expirationDay).day ?? 0
        return "\(daysLeft + 1) days left"
    }
    
    func daysLeftColor(for item: Item) -> Color {
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: item.expirationDay).day ?? 0
        switch daysLeft {
        case 0...1:
            return .red
        case 2...3:
            return .orange
        default:
            return .primary
        }
    }
}
