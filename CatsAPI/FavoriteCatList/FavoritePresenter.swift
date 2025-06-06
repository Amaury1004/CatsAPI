
import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func showFavorites(_ cats: [Cat])
    func showError(_ message: String)
    func reload()

}

class FavoritePresenter {
    
    weak var  view: FavoritesViewProtocol?
    private var favorites: [Cat] = []
    var  manager: FavoritesManagerProtocol
    
    init(view: FavoritesViewProtocol, manager: FavoritesManagerProtocol = FavoritesManager.shared) {
        self.view = view
        self.manager = manager
    }
    
    func loadFavorites() {
        favorites = manager.getFavorites()
        view?.showFavorites(favorites)
    }

    func deleteCat(at index: Int) {
        guard index < favorites.count else {
            view?.showError("Індекс за межами")
            return
        }
        favorites.remove(at: index)
        manager.save(favorites)
        view?.reload()
    }

    var numberOfCats: Int {
        favorites.count
    }

    func cat(at index: Int) -> Cat {
        favorites[index]
    }
}
