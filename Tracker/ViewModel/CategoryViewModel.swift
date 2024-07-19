import Foundation

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] {
        didSet {
            saveCategories()
        }
    }
    
    private let categoriesKey = "categoriesKey"
    
    init() {
        self.categories = UserDefaults.standard.load([Category].self, forKey: categoriesKey) ?? [
            Category(name: "Food"),
            Category(name: "Pill"),
            Category(name: "Makeup"),
            Category(name: "Custom")
        ]
    }
    
    func addCategory(_ category: Category) -> Bool {
        guard !categories.contains(where: { $0.name.lowercased() == category.name.lowercased() }) else {
            return false
        }
        categories.append(category)
        return true
    }
    
    func updateCategory(_ category: Category) -> Bool {
        guard !categories.contains(where: { $0.name.lowercased() == category.name.lowercased() && $0.id != category.id }) else {
            return false
        }
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            return true
        }
        return false
    }
    
    func deleteCategory(at indexSet: IndexSet) {
        categories.remove(atOffsets: indexSet)
    }
    
    private func saveCategories() {
        UserDefaults.standard.save(categories, forKey: categoriesKey)
    }
}
