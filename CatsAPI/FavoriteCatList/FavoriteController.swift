import UIKit
class FavoritesViewController: UIViewController {
    private let tableView = UITableView()
    private var favorites: [Cat] = []
    private var presenter: FavoritePresenter!

    private let searchButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FavoritePresenter(view: self)
        setupUI()
        presenter.loadFavorites()
    }

    private func setupUI() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(backButton))
                
                navigationItem.leftBarButtonItem = backButton
        view.backgroundColor = .white

            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(CatListCell.self, forCellReuseIdentifier: CatListCell.reuseIdentifier)
            tableView.rowHeight = view.bounds.height
            tableView.isPagingEnabled = true

            view.addSubview(tableView)

            searchButton.setTitle("Інфо проКотика", for: .normal)
            searchButton.setTitleColor(.white, for: .normal)
            searchButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
            searchButton.backgroundColor = .systemBlue
            searchButton.layer.cornerRadius = 12
            searchButton.translatesAutoresizingMaskIntoConstraints = false
            searchButton.addTarget(self, action: #selector(serchCat), for: .touchUpInside)

            deleteButton.setTitle("Видалити котика", for: .normal)
            deleteButton.setTitleColor(.white, for: .normal)
            deleteButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
            deleteButton.backgroundColor = .systemRed
            deleteButton.layer.cornerRadius = 12
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            deleteButton.addTarget(self, action: #selector(deleteOneElement), for: .touchUpInside)

            view.addSubview(searchButton)
            view.addSubview(deleteButton)

            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: searchButton.topAnchor),

                searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                searchButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
                searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                searchButton.heightAnchor.constraint(equalToConstant: 50),

                deleteButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
                deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                deleteButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        
    }
    @objc func backButton() {
        dismiss(animated: true)
    }
    @objc func serchCat(){
        guard let index = tableView.indexPathsForVisibleRows?.first else { return }
        let cat = favorites[index.row]
        
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

    @objc func deleteOneElement() {
            let alert = UIAlertController(
                title: "Підтвердження",
                message: "Ти впевнений, що хочеш видалити цього котика?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Скасувати", style: .cancel))
            alert.addAction(UIAlertAction(title: "Так", style: .destructive) { [weak self] _ in
                guard let self = self,
                      let indexPath = self.tableView.indexPathsForVisibleRows?.first else { return }

                self.favorites.remove(at: indexPath.row)
                self.presenter.manager.save(self.favorites)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            

            present(alert, animated: true)
        }
}

extension FavoritesViewController: FavoritesViewProtocol{
    func showFavorites(_ cats: [Cat]) {
        self.favorites = cats
        tableView.reloadData()
    }

    func reload() {
        tableView.reloadData()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Помилка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatListCell.reuseIdentifier, for: indexPath) as? CatListCell else {
            return UITableViewCell()
        }

        let cat = favorites[indexPath.row]
        let hasBreed = !(cat.breeds?.isEmpty ?? true)

        if let vm = CatListCellViewModel(urlString: cat.url, hasBreed: hasBreed) {
            cell.viewModel = vm
        }

        return cell
    }
}
    
extension FavoritesViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateTitle(scrollView)
    }
}

extension FavoritesViewController: UIScrollViewDelegate {
    func updateTitle(_ scrollView: UIScrollView) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if let scrollNow = self.tableView.indexPathsForVisibleRows?.first {
                let currentIndex = scrollNow.row
                
                let mainLabel = UILabel()
                mainLabel.text = "Котик: \(currentIndex + 1) із \(self.favorites.count)"
                mainLabel.textAlignment = .center
                
                self.navigationItem.titleView = mainLabel
            }
        }
    }

}
