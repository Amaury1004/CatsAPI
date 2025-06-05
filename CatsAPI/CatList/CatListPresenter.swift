protocol CatListProtocol {
    func loadNextPage()
    func getCatIndex(at index: Int) -> Cat
    func getCatsCount() -> Int
    func addCats(_ newCats: [Cat])
}

class CatListPresenter: CatListProtocol {
    private var currentPage = 0
    private var isLoading = false
    weak var view: CatListView?
    private let pageSize = 10
    private let hasBreeds: Bool
    
    private var cats: [Cat] = []
    

    init(view: CatListView, hasBreeds: Bool) {
        self.view = view
        self.hasBreeds = hasBreeds
    }
    
    enum HasBreeds: String {
        case none = "0"
        case has = "1"
    }
    func getCatIndex(at index: Int) -> Cat {
        return cats[index]
    }
    func getCatsCount() -> Int {
        return cats.count
    }
    func addCats(_ newCats: [Cat]) {
            cats.append(contentsOf: newCats)
        }
    
    func loadNextPage() {
        guard !isLoading else { return }
        isLoading = true
        let hasBreedsEnum: HasBreeds = hasBreeds ? .has : .none
        NetworkManager.shared.request(.search,
                                      parameters: ["limit": "\(pageSize)", "page": "\(currentPage)", "breeds": "\(hasBreedsEnum.rawValue)"])  { [weak self] (result: Result<[Cat], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let cats):
                self.currentPage += 1
                self.view?.showCats(cats)
            case .failure(let error):
                self.view?.showError(error)
            }
            self.isLoading = false
        }
    }
}
