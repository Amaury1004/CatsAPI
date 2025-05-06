/// Дополнить модель Cat новым полем breeds которое будет breeds: [Breed] ✅
/// Добавить кнопку, которая будет пушить на экран с информацией о породе ❌ (ты модалишь, а не пушишь)
/// Кнопка сохранения кота и возможность просмотреть всех сохраненных котов

/// У тебя нарушена логика работы Model - View - Presenter, ниже я отмечу все места, которы ене должны быть во Вью КОнтроллере


import UIKit

protocol CatListView: AnyObject {
    func showCats(_ cats: [Cat])
    func showError(_ error: Error)
}

class CatListViewController: UIViewController {
    private let tableView = UITableView()
    private var cats: [Cat] = []
    private let withBreeds: Bool
    
    
    var favoriteCats: [Cat] {
        FavoritesManager.shared.getFavorites()
    }
    
    private lazy var presenter: CatListProtocol = CatListPresenter(view: self)
    
    init(withBreeds: Bool) {
        // Переменная по управлению логикой контента, не должна быть во VC
         self.withBreeds = withBreeds
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CatListCell.self, forCellReuseIdentifier: CatListCell.reuseIdentifier)
        tableView.rowHeight = view.bounds.height
        tableView.isPagingEnabled = true
        view.addSubview(tableView)
        setupTopPanel()
        // То же самое, это решение для презентера, не VC
        if withBreeds {
            presenter.loadNextpage_withBreeds()
        }else{
            presenter.loadNextPage_withoutBreeds()
        }
    }
    
    func setupTopPanel() {
        // У тебя модальный тип отображения экрана. Не должно быть шевронов, ты делаешь антипаттерн.
        // Экран должен закрываться сверху вниз, но ты отображаешь шеврон, вводя пользователя в заблуждение,
        // что это экран который пушится, тем самым давая ему ложное ощущение от действия
        // исправить на крестик
        // P.S. В целом не понимаю зачем ты его модалишь, если можно презентовать первый экран на навигейшен вью
        // и с нее пушить
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButton))
        
        
        
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(menu))
        navigationItem.leftBarButtonItems = [backButton, leftButton]

        let addFavoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(addCurrentToFavorites))
        addFavoriteButton.tintColor = .lightGray

        let showFavoritesButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(showFavorites))
        showFavoritesButton.tintColor = .lightGray

        navigationItem.rightBarButtonItems = [showFavoritesButton, addFavoriteButton]
        }

    @objc func addCurrentToFavorites() {
        guard let index = tableView.indexPathsForVisibleRows?.first else { return }
        let cat = cats[index.row]
        
        if !FavoritesManager.shared.getFavorites().contains(where: { $0.id == cat.id }) {
                FavoritesManager.shared.add(cat: cat)
                let alert = UIAlertController(title: "Успіх", message: "Кітик доданий до колекції", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true)
            }    }

    @objc func showFavorites() {
        let favoritesVC = FavoritesViewController()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    @objc func menu() {
        guard let index = tableView.indexPathsForVisibleRows?.first else { return }
        let cat = cats[index.row]
        
        guard let breeds = cat.breeds, !breeds.isEmpty else {
            let alert = UIAlertController(title: "Нет информации", message: "У этого кота нет описания породы", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            present(alert, animated: true)
            return
        }
        
        if let breed = cat.breeds?.first, let imageUrl = URL(string: cat.url) {
            let vc = CatBreedDetailViewController(breed: breed, imageUrl: imageUrl)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @objc func backButton() {
        dismiss(animated: true)
    }

    func setCats(_ cats: [Cat]) {
        self.cats = cats
        tableView.reloadData()
    }

}

extension CatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatListCell.reuseIdentifier, for: indexPath) as? CatListCell else {
            return UITableViewCell()
        }
        let cat = cats[indexPath.row]
        // Так код выглядет чище. Старайся не усложнять логические улосвия(по возможности)
        let breeds = cat.breeds ?? []
        let hasBreed = !breeds.isEmpty
        //let hasBreed = !(cat.breeds?.isEmpty ?? true)
        if let vm = CatListCellViewModel(urlString: cat.url, hasBreed: hasBreed) {
            cell.viewModel = vm
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == cats.count - 1 {
            // Кривой нейминг, в iOS так не пишут.
            presenter.loadNextpage_withBreeds()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension CatListViewController: CatListView {
    func showCats(_ newCats: [Cat]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !newCats.isEmpty else { return }
            let startIndex = self.cats.count
            let endIndex = startIndex + newCats.count
            let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
            self.cats.append(contentsOf: newCats)
            self.tableView.performBatchUpdates({
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }

    func showError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }}

extension CatListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Это делегат Scroll View он не может выполняться не на мейн потоке, делаешь овер трединг, убирай
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if let scrollNow = self.tableView.indexPathsForVisibleRows?.first {
                let currentIndex = scrollNow.row
                
                let mainLabel = UILabel()
                mainLabel.text = "Котик: \(currentIndex + 1)"
                mainLabel.textAlignment = .center
                
                self.navigationItem.titleView = mainLabel
            }
        }
    }
}
