import UIKit

struct CatListCellViewModel {
    let imageUrl: URL

    init?(urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.imageUrl = url
    }
}

class CatListCell: UITableViewCell {
    static let reuseIdentifier = "CatListCell"
    private let catImageView = UIImageView()

    var viewModel: CatListCellViewModel? {
        didSet { configure() }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Full‐screen image
        catImageView.contentMode = .scaleAspectFit
        catImageView.clipsToBounds = true
        contentView.addSubview(catImageView)
        catImageView.isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        catImageView.addGestureRecognizer(imageTap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        catImageView.frame = contentView.bounds
    }

    private func configure() {
        guard let vm = viewModel else { return }
        catImageView.image = nil
        ImageDownloader.shared.downloadImage(from: vm.imageUrl.absoluteString) { [weak self] image in
            DispatchQueue.main.async {
                self?.catImageView.image = image
            }
        }
    }
    
    @objc
    private func imageTapped(_ sender: UITapGestureRecognizer) {
        let isFit = catImageView.contentMode == .scaleAspectFit
        catImageView.contentMode = isFit ? .scaleAspectFill : .scaleAspectFit
    }
}
