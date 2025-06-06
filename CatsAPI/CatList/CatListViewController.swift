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
    private let hasBreeds: Bool
    private var infoButton: UIBarButtonItem!
    
    
    private lazy var presenter: CatListProtocol = CatListPresenter(view: self, hasBreeds: hasBreeds)
    
    init(hasBreeds: Bool) {
        // Переменная по управлению логикой контента, не должна быть во VC
        self.hasBreeds = hasBreeds
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
        
        presenter.loadNextPage()
    }
    
    func setupTopPanel() {
        // У тебя модальный тип отображения экрана. Не должно быть шевронов, ты делаешь антипаттерн.
        // Экран должен закрываться сверху вниз, но ты отображаешь шеврон, вводя пользователя в заблуждение,
        // что это экран который пушится, тем самым давая ему ложное ощущение от действия
        // исправить на крестик
        // P.S. В целом не понимаю зачем ты его модалишь, если можно презентовать первый экран на навигейшен вью
        // и с нее пушить
        let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButton))
        infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(menu))
        infoButton.tintColor = .lightGray
        navigationItem.leftBarButtonItems = [backButton, infoButton]

        let addFavoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(addToFavorites))
        addFavoriteButton.tintColor = .lightGray

        let showFavoritesButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(showFavorites))
        showFavoritesButton.tintColor = .lightGray

        navigationItem.rightBarButtonItems = [showFavoritesButton, addFavoriteButton]
        }

    @objc func addToFavorites() {
        guard let index = tableView.indexPathsForVisibleRows?.first else { return }
        let cat = presenter.getCatIndex(at: index.row)

        if !FavoritesManager.shared.getFavorites().contains(where: { $0.id == cat.id }) {
            FavoritesManager.shared.add(cat: cat)

            let alert = UIAlertController(
                title: "Успіх",
                message: "Кітик доданий до колекції",
                preferredStyle: .actionSheet
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    }

    @objc func showFavorites() {
        let favoritesVC = FavoritesViewController()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    @objc func menu() {
        print("INFO BUTTON PRESSED")
        guard let index = tableView.indexPathsForVisibleRows?.first else { return }
        let cat = presenter.getCatIndex(at: index.row)

        guard let breeds = cat.breeds, !breeds.isEmpty else {
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
        tableView.reloadData()
    }

}

extension CatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCatsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatListCell.reuseIdentifier, for: indexPath) as? CatListCell else {
            return UITableViewCell()
        }
        let cat = presenter.getCatIndex(at: indexPath.row)
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
        if indexPath.row == presenter.getCatsCount() - 1 {
            presenter.loadNextPage()
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
            let startIndex = self.presenter.getCatsCount()
            let endIndex = startIndex + newCats.count
            let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
            self.presenter.addCats(newCats)
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
            if let scrollNow = self.tableView.indexPathsForVisibleRows?.first {
                let currentIndex = scrollNow.row
                
                let mainLabel = UILabel()
                mainLabel.text = "Котик: \(currentIndex + 1)"
                mainLabel.textAlignment = .center
                
                self.navigationItem.titleView = mainLabel
            }
        if let index = tableView.indexPathsForVisibleRows?.first {
            let cat = presenter.getCatIndex(at: index.row)
            let hasBreed = !(cat.breeds?.isEmpty ?? true)
            infoButton.isEnabled = hasBreed
            infoButton.tintColor = hasBreed ? .systemBlue : .lightGray
        }
        
    }
}
