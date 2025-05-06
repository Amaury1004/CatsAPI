import UIKit

class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "favoriteCats"
    
    

    func add(cat: Cat) {
        var favorites = getFavorites()
        if !favorites.contains(where: { $0.id == cat.id }) {
            favorites.append(cat)
            save(favorites)
        }
    }

    func getFavorites() -> [Cat] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Cat].self, from: data) else {
            return []
        }
        return decoded
    }

     func save(_ cats: [Cat]) {
        if let encoded = try? JSONEncoder().encode(cats) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
