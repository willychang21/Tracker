import SwiftUI

struct MainView: View {
    @State private var items: [Item] = []
    @State private var showAddItemForm = false

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: EditItemForm(item: item, items: $items)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("Category: \(item.category)")
                                Text("Produced on: \(item.produceDay, formatter: dateFormatter)")
                                Text("Expires on: \(item.expirationDay, formatter: dateFormatter)")
                            }
                            Spacer()
                            Text(daysLeftText(for: item))
                                .foregroundColor(daysLeftColor(for: item))
                                .bold()
                        }
                    }
                }
            }
            .navigationTitle("Tracker")
            .navigationBarItems(trailing: Button(action: {
                showAddItemForm.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showAddItemForm) {
                AddItemForm(items: $items)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    private func daysLeftText(for item: Item) -> String {
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: item.expirationDay).day ?? 0
        return "\(daysLeft + 1) days left"
    }
    
    private func daysLeftColor(for item: Item) -> Color {
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

struct AddItemForm: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var items: [Item]
    @State private var name = ""
    @State private var category = ""
    @State private var produceDay = Date()
    @State private var expirationDay = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Name", text: $name)
                    TextField("Category", text: $category)
                    DatePicker("Produce Day", selection: $produceDay, displayedComponents: .date)
                    DatePicker("Expiration Day", selection: $expirationDay, displayedComponents: .date)
                }
            }
            .navigationTitle("Add New Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let newItem = Item(name: name, category: category, produceDay: produceDay, expirationDay: expirationDay)
                        items.append(newItem)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

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

#Preview {
    MainView()
}
