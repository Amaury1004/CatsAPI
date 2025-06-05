protocol CatListProtocol {
    func loadNextPage()
    
}

class CatListPresenter: CatListProtocol {
    private var currentPage = 0
    private var isLoading = false
    weak var view: CatListView?
    private let pageSize = 10
    private let hasBreeds: Bool
    

    init(view: CatListView, hasBreeds: Bool) {
        self.view = view
        self.hasBreeds = hasBreeds
    }
    
    enum HasBreeds: String {
        case none = "0"
        case has = "1"
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
