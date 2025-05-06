import UIKit

class FavoritesViewController: UIViewController {
    
    private let tableView = UITableView()
    private var favorites: [Cat] = []
    private let saved = FavoritesManager()
    // Насранно с переменными
    let SerchCats = UIButton(type: .system)
    let DeliteCat = UIButton(type: .system)

    init() {
        super.init(nibName: nil, bundle: nil)
        /// Зачем тебе для этого синглтон?
        /// Синглтон создается для крупных модулей приложения, которые по пальцам пересчитать
        /// Нетворкинг, работа с БД, обработчик картинок и то, уже сомнительно. Для всего остального учимся думать
        /// В целом тут должна быть та же модель взаимодействия данных что и в CatList Model - View - Presenter. Если ты ее не понял, задавай вопросы, отвечу
        self.favorites = FavoritesManager.shared.getFavorites()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        

        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CatListCell.self, forCellReuseIdentifier: CatListCell.reuseIdentifier)
        tableView.rowHeight = view.bounds.height
        tableView.isPagingEnabled = true
        
        
        view.addSubview(tableView)
        setupButtons()
    }
    
    func addToFavorites(cat: Cat) {
        favorites = FavoritesManager.shared.getFavorites()
        saved.add(cat: cat)
        tableView.reloadData()
    }
    
    

    func setupButtons() {
        SerchCats.tintColor = .blue
        DeliteCat.tintColor = .red
        
        SerchCats.setTitle("Пошук котика ", for: .normal)
        SerchCats.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        SerchCats.frame = CGRect(x: 20, y: 100, width: 150, height: 50)
        SerchCats.titleLabel?.numberOfLines = 3
        
        DeliteCat.layer.cornerRadius = DeliteCat.frame.height / 3
        DeliteCat.clipsToBounds = true
        
        SerchCats.layer.cornerRadius = DeliteCat.frame.height / 3
        SerchCats.clipsToBounds = true
        
        DeliteCat.backgroundColor = .lightGray
        SerchCats.backgroundColor = .lightGray
        
        DeliteCat.setTitle("Видалити одного котика ", for: .normal)
        DeliteCat.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        DeliteCat.frame = CGRect(x: 20, y: 100, width: 150, height: 50)
        DeliteCat.titleLabel?.numberOfLines = 3
        
        
        
        SerchCats.addTarget(self, action: #selector(serchCat), for: .touchUpInside)
        DeliteCat.addTarget(self, action: #selector(deleteOneElement), for: .touchUpInside)
        
        SerchCats.translatesAutoresizingMaskIntoConstraints = false
        DeliteCat.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(DeliteCat)
        view.addSubview(SerchCats)
        
        NSLayoutConstraint.activate([
        
            SerchCats.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -25),
            SerchCats.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            SerchCats.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -7.5),
            SerchCats.heightAnchor.constraint(equalToConstant: 60),
            
            DeliteCat.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -25),
            DeliteCat.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 7.5),
            DeliteCat.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            DeliteCat.heightAnchor.constraint(equalToConstant: 60)
        
        ])
    }
    @objc func serchCat(){
        print("Тут має бути пошук за індексом")
        
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
            self.saved.save(self.favorites)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        

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

