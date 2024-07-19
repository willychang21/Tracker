import SwiftUI

struct CustomCategorySheet: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Binding var selectedCategory: String
    @Environment(\.presentationMode) var presentationMode
    @State private var newCategoryName = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Custom Category")) {
                    TextField("Category Name", text: $newCategoryName)
                }
            }
            .navigationTitle("Add Custom Category")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        guard !newCategoryName.isEmpty else {
                            showAlert = true
                            return
                        }
                        if categoryViewModel.addCategory(Category(name: newCategoryName)) {
                            selectedCategory = newCategoryName
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showAlert = true
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text("Category name cannot be empty or already exists."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
