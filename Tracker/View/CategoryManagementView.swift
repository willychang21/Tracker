import SwiftUI

struct CategoryManagementView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @State private var newCategoryName = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var editMode: EditMode = .inactive
    @State private var editedCategory: Category?
    @State private var showCustomCategorySheet = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Manage Categories")) {
                    List {
                        ForEach(categoryViewModel.categories) { category in
                            if editMode == .active && editedCategory?.id == category.id {
                                HStack {
                                    TextField("Category Name", text: $newCategoryName, onCommit: {
                                        guard !newCategoryName.isEmpty else {
                                            alertMessage = "Category name cannot be empty."
                                            showAlert = true
                                            return
                                        }
                                        var updatedCategory = category
                                        updatedCategory.name = newCategoryName
                                        if categoryViewModel.updateCategory(updatedCategory) {
                                            editedCategory = nil
                                            editMode = .inactive
                                            newCategoryName = ""
                                        } else {
                                            alertMessage = "Category name must be unique."
                                            showAlert = true
                                        }
                                    })
                                    Button("Save") {
                                        guard !newCategoryName.isEmpty else {
                                            alertMessage = "Category name cannot be empty."
                                            showAlert = true
                                            return
                                        }
                                        var updatedCategory = category
                                        updatedCategory.name = newCategoryName
                                        if categoryViewModel.updateCategory(updatedCategory) {
                                            editedCategory = nil
                                            editMode = .inactive
                                            newCategoryName = ""
                                        } else {
                                            alertMessage = "Category name must be unique."
                                            showAlert = true
                                        }
                                    }
                                }
                            } else {
                                HStack {
                                    Text(category.name)
                                    Spacer()
                                    Button("Edit") {
                                        editedCategory = category
                                        newCategoryName = category.name
                                        editMode = .active
                                    }
                                }
                            }
                        }
                        .onDelete(perform: categoryViewModel.deleteCategory)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(isPresented: $showCustomCategorySheet) {
                CustomCategorySheet(categoryViewModel: categoryViewModel, selectedCategory: .constant(""))
            }
        }
        .navigationBarTitle("Manage Categories", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            showCustomCategorySheet.toggle()
        }) {
            Image(systemName: "plus")
        })
    }
}
