import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var showAddItemForm = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink(destination: EditItemForm(viewModel: viewModel, itemViewModel: ItemViewModel(item: item))) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("\(item.category)")
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                                Text("\(item.produceDay, formatter: dateFormatter) - \(item.expirationDay, formatter: dateFormatter)")
                            }
                            Spacer()
                            Text(viewModel.daysLeftText(for: item))
                                .foregroundColor(viewModel.daysLeftColor(for: item))
                                .bold()
                        }
                    }
                }
            }
            .navigationTitle("Tracker")
            .navigationBarItems(
                leading: NavigationLink(destination: CategoryManagementView(categoryViewModel: viewModel.categoryViewModel)) {
                    Text("Categories")
                },
                trailing: Button(action: {
                    showAddItemForm.toggle()
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showAddItemForm) {
                AddItemForm(viewModel: viewModel, categoryViewModel: viewModel.categoryViewModel)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy"
        return formatter
    }
}
