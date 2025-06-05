import UIKit

class MainViewController: UIViewController {
    
    let mainLabel = UILabel()
    
    let buttonCats = UIButton(type: .system)
    let buttonCatsBreeds = UIButton(type: .system)
    let buttonFavoriteCats = UIButton(type: .system)

    let pawButton = UIButton(type: .system)
    let mainBackground = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setupUi()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setupUi() {
        mainBackground.backgroundColor = .systemBlue
        mainBackground.translatesAutoresizingMaskIntoConstraints = false
        
        mainLabel.text =  "КіТі(Tікі-Ток)кіTi"
        mainLabel.font = UIFont.systemFont(ofSize: 36)
        mainLabel.textColor = .yellow
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pawButton.setTitle("Cats", for: .normal)
        pawButton.setImage(UIImage(systemName: "pawprint.fill"), for: .normal)
        pawButton.tintColor = .black
        pawButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        pawButton.translatesAutoresizingMaskIntoConstraints = false
        //catsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
       
        
        buttonCats.setTitle("Звичайний котик", for: .normal)
        buttonCats.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        buttonCats.setTitleColor(.black, for: .normal)
        buttonCats.backgroundColor = .red
        buttonCats.layer.cornerRadius = 7
        buttonCats.clipsToBounds = true
        
        buttonCatsBreeds.setTitle("Котик з породою", for: .normal)
        buttonCatsBreeds.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        buttonCatsBreeds.setTitleColor(.red, for: .normal)
        buttonCatsBreeds.backgroundColor = .black
        buttonCatsBreeds.layer.cornerRadius = 7
        buttonCatsBreeds.clipsToBounds = true
        
        buttonFavoriteCats.setTitle("Улюблені котики's", for: .normal)
        buttonFavoriteCats.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        buttonFavoriteCats.setTitleColor(.white, for: .normal)
        buttonFavoriteCats.backgroundColor = .systemPink
        buttonFavoriteCats.layer.cornerRadius = 7
        buttonFavoriteCats.clipsToBounds = true
        
        buttonCats.translatesAutoresizingMaskIntoConstraints = false
        buttonCatsBreeds.translatesAutoresizingMaskIntoConstraints = false
        buttonFavoriteCats.translatesAutoresizingMaskIntoConstraints = false
        
        pawButton.addTarget(self, action: #selector(powCats), for: .touchUpInside)
        buttonCats.addTarget(self, action: #selector(justCat), for: .touchUpInside)
        buttonCatsBreeds.addTarget(self, action: #selector(breedsCat), for: .touchUpInside)
        buttonFavoriteCats.addTarget(self, action: #selector(favoriteCat), for: .touchUpInside)

        view.addSubview(mainBackground)
        mainBackground.addSubview(mainLabel)
        mainBackground.addSubview(buttonCats)
        mainBackground.addSubview(buttonCatsBreeds)
        mainBackground.addSubview(buttonFavoriteCats)
        mainBackground.addSubview(pawButton)


        NSLayoutConstraint.activate([
            mainBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            mainLabel.centerXAnchor.constraint(equalTo: mainBackground.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            pawButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 15),
            pawButton.centerXAnchor.constraint(equalTo: mainBackground.centerXAnchor),

            buttonCats.centerXAnchor.constraint(equalTo: pawButton.centerXAnchor),
            buttonCats.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 80),
            buttonCats.heightAnchor.constraint(equalToConstant: 55),
            buttonCats.widthAnchor.constraint(equalToConstant: 225),
            
            buttonCatsBreeds.centerXAnchor.constraint(equalTo: mainBackground.centerXAnchor),
            buttonCatsBreeds.topAnchor.constraint(equalTo: buttonCats.bottomAnchor, constant: 20),
            buttonCatsBreeds.heightAnchor.constraint(equalToConstant: 55),
            buttonCatsBreeds.widthAnchor.constraint(equalToConstant: 225),
            
            buttonFavoriteCats.centerXAnchor.constraint(equalTo: mainBackground.centerXAnchor),
            buttonFavoriteCats.topAnchor.constraint(equalTo: buttonCatsBreeds.bottomAnchor, constant: 20),
            buttonFavoriteCats.heightAnchor.constraint(equalToConstant: 55),
            buttonFavoriteCats.widthAnchor.constraint(equalToConstant: 225)
        ])
    }
    @objc private func justCat() {
        let justCat = CatListViewController(hasBreeds: false)
        let nc = UINavigationController(rootViewController: justCat)
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true, completion: nil)
    }
    @objc private func powCats() {
        // Ахуенно
        let alert = UIAlertController(title: "Мяу!", message: "Мяу Мяу?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Мяу.", style: .default))
        present(alert, animated: true)
    }
    @objc private func breedsCat() {
        let breedsCat = CatListViewController(hasBreeds: true)
        let nc = UINavigationController(rootViewController: breedsCat)
        nc.modalPresentationStyle = .fullScreen
        // ЧТобы не подалить (present) а делать пуш(push) тебе надо этот контроллер обернуть в навигейшен
        self.present(nc, animated: true, completion: nil)
    }
    
    @objc private func favoriteCat() {
        // Отсюда нельзя выйти
        let favoriteCat = FavoritesViewController()
        let nc = UINavigationController(rootViewController: favoriteCat)
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true, completion: nil)
    }
    
}
