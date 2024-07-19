import SwiftUI

struct EditItemForm: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: MainViewModel
    @ObservedObject var itemViewModel: ItemViewModel
    @State private var selectedCategory: String
    @State private var customCategory: String
    @State private var showAlert = false
    @State private var showCustomCategorySheet = false
    
    init(viewModel: MainViewModel, itemViewModel: ItemViewModel) {
        self.viewModel = viewModel
        self.itemViewModel = itemViewModel
        
        _selectedCategory = State(initialValue: viewModel.categoryViewModel.categories.contains { $0.name == itemViewModel.category } ? itemViewModel.category : "Custom")
        _customCategory = State(initialValue: viewModel.categoryViewModel.categories.contains { $0.name == itemViewModel.category } ? "" : itemViewModel.category)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.leading, 16)
                    Spacer()
                    Text("Edit Item")
                        .font(.headline)
                    Spacer()
                    Button("Save") {
                        if itemViewModel.name.isEmpty || (selectedCategory == "Custom" && customCategory.isEmpty) {
                            showAlert = true
                        } else {
                            let category = selectedCategory == "Custom" ? customCategory : selectedCategory
                            itemViewModel.category = category
                            viewModel.updateItem(updatedItem: itemViewModel)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(itemViewModel.name.isEmpty || (selectedCategory == "Custom" && customCategory.isEmpty))
                    .padding(.trailing, 16)
                }
                .padding(.vertical, 8)
                
                Form {
                    Section(header: Text("Item Details")) {
                        TextField("Name", text: $itemViewModel.name)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.categoryViewModel.categories.map { $0.name }, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                        if category != "Custom" {
                                            customCategory = ""
                                        }
                                    }) {
                                        Text(category)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(selectedCategory == category ? Color.blue : Color.gray)
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                    }
                                }
                                Button(action: {
                                    showCustomCategorySheet.toggle()
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color.gray)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                        
                        if selectedCategory == "Custom" {
                            TextField("Custom Category", text: $customCategory)
                        }
                        
                        DatePicker("Produce Day", selection: $itemViewModel.produceDay, displayedComponents: .date)
                        DatePicker("Expiration Day", selection: $itemViewModel.expirationDay, displayedComponents: .date)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text("Item name and category cannot be empty."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(isPresented: $showCustomCategorySheet) {
                CustomCategorySheet(categoryViewModel: viewModel.categoryViewModel, selectedCategory: $selectedCategory)
            }
        }
        .navigationBarHidden(true)
    }
}
