import Foundation
import NaturalLanguage

class TextAnalyzer {
    func analyzeText(_ texts: [String], completion: @escaping (String?, Date?) -> Void) {
        var itemName: String?
        var expirationDate: Date?
        
        for text in texts {
            if text.lowercased().contains("exp") {
                expirationDate = parseDate(from: text)
            } else {
                itemName = text
            }
        }
        
        completion(itemName, expirationDate)
    }
    
    func parseDate(from text: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy" // Adjust the date format based on the text format
        return dateFormatter.date(from: text)
    }
}
