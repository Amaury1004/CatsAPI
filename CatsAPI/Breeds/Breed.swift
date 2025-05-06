import UIKit

class CatBreedDetailViewController: UIViewController {
    private let breed: Breed
    private let catImageUrl: URL?
    private let tableView = UITableView()
    private let headerImageView = UIImageView()

    private let attributes: [(title: String, value: String)]

    init(breed: Breed, imageUrl: URL?) {
        self.breed = breed
        self.catImageUrl = imageUrl

        self.attributes = [
            ("Weight (Imperial)", breed.weight?.imperial ?? "none"),
            ("Weight (Metric)", breed.weight?.metric ?? "none"),
            ("Temperament", breed.temperament ?? "none"),
            ("Origin", breed.origin ?? "none"),
            ("Country Codes", breed.countryCodes ?? "none"),
            ("Country Code", breed.countryCode ?? "none"),
            ("Life Span", breed.lifeSpan ?? "none"),
            ("Description", breed.description ?? "none"),
            ("Alt Names", breed.altNames ?? "none"),
            ("Intelligence", "\(breed.intelligence ?? 0)"),  // Перевірка опціонального значення
                ("Affection Level", "\(breed.affectionLevel ?? 0)"),  // Перевірка опціонального значення
                ("Energy Level", "\(breed.energyLevel ?? 0)"),
                ("Child Friendly", "\(breed.childFriendly ?? 0)"),
                ("Dog Friendly", "\(breed.dogFriendly ?? 0)"),
                ("Grooming", "\(breed.grooming ?? 0)"),
                ("Health Issues", "\(breed.healthIssues ?? 0)"),
                ("Shedding Level", "\(breed.sheddingLevel ?? 0)"),
                ("Social Needs", "\(breed.socialNeeds ?? 0)"),
                ("Stranger Friendly", "\(breed.strangerFriendly ?? 0)"),
                ("Vocalisation", "\(breed.vocalisation ?? 0)"),
                ("Lap", "\(breed.lap ?? 0)"),
                ("Indoor", "\(breed.indoor ?? 0)"),
                ("Adaptability", "\(breed.adaptability ?? 0)"),
                ("Hypoallergenic", "\(breed.hypoallergenic ?? 0)"),
                ("Natural", "\(breed.natural ?? 0)"),
                ("Rare", "\(breed.rare ?? 0)"),
                ("Rex", "\(breed.rex ?? 0)"),
                ("Short Legs", "\(breed.shortLegs ?? 0)"),
                ("Suppressed Tail", "\(breed.suppressedTail ?? 0)"),
                ("Experimental", "\(breed.experimental ?? 0)"),
            ("Wikipedia URL", breed.wikipediaURL ?? "none"),
            ("Vetstreet URL", breed.vetstreetURL ?? "none")
        ]

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        loadImage()
    }

    private func setupTableView() {
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.clipsToBounds = true
        headerImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = headerImageView
        tableView.register(AttributeCell.self, forCellReuseIdentifier: AttributeCell.reuseIdentifier)


        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadImage() {
        guard let url = catImageUrl else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.headerImageView.image = image
                }
            }
        }.resume()
    }
}
             
             
extension CatBreedDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.reuseIdentifier, for: indexPath) as! AttributeCell
        let attribute = attributes[indexPath.row]
        cell.configure(title: attribute.title, value: attribute.value)
        return cell
    }
}
