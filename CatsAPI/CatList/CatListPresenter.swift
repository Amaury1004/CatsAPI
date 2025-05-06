protocol CatListProtocol {
    func loadNextPage_withoutBreeds()
    func loadNextpage_withBreeds()
}

class CatListPresenter: CatListProtocol {
    private var currentPage = 0
    private var isLoading = false
    weak var view: CatListView?
    private let pageSize = 10 // Тут раньше было 5, я так понял что это кол-во картинок, но загружальнось все равно 10, как только я подключил апи но начало отображать 5 как тут и приишлось поменять на 10 как было до этого. Вопрос: Как оно ранее генерело 10 при значении в 5,( мб это связано с апи кекВ)

    init(view: CatListView) {
        self.view = view
    }
    // Неверный нейминг
    func loadNextpage_withBreeds() {
        // Ну и можно не разбивать на два метода, я объяснил, где должна передаваться эта переменная
        loadNextPage(with: .hasBreads)
    }
    // Неверный нейминг
    func loadNextPage_withoutBreeds() {
        loadNextPage()
    }

    func loadNextPage(with type: NetworkManager.TypeRequest? = nil) {
        guard !isLoading else { return }
        isLoading = true
        // Ультра гига омега критическая ошибка идем разбираться в Network Manager
        NetworkManager.shared.request(.search,
                                      parameters: ["limit": "\(pageSize)", "page": "\(currentPage)"], typeRequest: type) { [weak self] (result: Result<[Cat], Error>) in
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
