import Foundation

extension UserDefaults {
    func save<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: key)
        }
    }

    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = self.data(forKey: key), let decoded = try? JSONDecoder().decode(type, from: data) {
            return decoded
        }
        return nil
    }
}
