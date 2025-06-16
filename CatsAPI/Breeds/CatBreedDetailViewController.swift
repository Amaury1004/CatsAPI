import UIKit
import SafariServices


class CatBreedDetailViewController: UIViewController {
    private let breed: Breed
    private let catImageUrl: URL?
    private let tableView = UITableView()
    private let headerImageView = UIImageView()
    
    

    private let attributes: [Attribute]

    init(breed: Breed, imageUrl: URL?) {
        self.breed = breed
        self.catImageUrl = imageUrl
        self.attributes = AttributeFactory.makeAttributes(from: breed)
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
        cell.configure(model: attribute)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let attribute = attributes[indexPath.row]

        if attribute.title.contains("URL"),
           let url = URL(string: attribute.value){
           let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }

            tableView.deselectRow(at: indexPath, animated: true)
        }
}
