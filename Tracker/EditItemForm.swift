import SwiftUI

struct EditItemForm: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var item: Item
    @Binding var items: [Item]
    @State private var name: String
    @State private var category: String
    @State private var produceDay: Date
    @State private var expirationDay: Date
    
    init(item: Item, items: Binding<[Item]>) {
        self._item = State(initialValue: item)
        self._items = items
        self._name = State(initialValue: item.name)
        self._category = State(initialValue: item.category)
        self._produceDay = State(initialValue: item.produceDay)
        self._expirationDay = State(initialValue: item.expirationDay)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Item Details")) {
                TextField("Name", text: $name)
                TextField("Category", text: $category)
                DatePicker("Produce Day", selection: $produceDay, displayedComponents: .date)
                DatePicker("Expiration Day", selection: $expirationDay, displayedComponents: .date)
            }
        }
        .navigationTitle("Edit Item")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    if let index = items.firstIndex(where: { $0.id == item.id }) {
                        items[index] = Item(id: item.id, name: name, category: category, produceDay: produceDay, expirationDay: expirationDay)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
