import UIKit

protocol CatListCellDelegate: AnyObject {
    func didTapShowBreed(for cell: CatListCell)
}

struct CatListCellViewModel {
    let imageUrl: URL
    let hasBreed: Bool

    init?(urlString: String, hasBreed: Bool) {
        guard let url = URL(string: urlString) else { return nil }
        self.imageUrl = url
        self.hasBreed = hasBreed
    }
}
class CatListCell: UITableViewCell {
    static let reuseIdentifier = "CatListCell"
    
    private let catImageView = UIImageView()
    
    private var currentScale: CGFloat = 1.0
    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 3.0

    var viewModel: CatListCellViewModel? {
        didSet { configure() }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupImageView()
        setupLayout()
        setupPinchGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        catImageView.contentMode = .scaleAspectFit
        catImageView.clipsToBounds = true
        catImageView.translatesAutoresizingMaskIntoConstraints = false
        catImageView.isUserInteractionEnabled = true
        contentView.addSubview(catImageView)
    }


    private func setupLayout() {
        NSLayoutConstraint.activate([
               catImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
               catImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               catImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               catImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    
        ])

    }

    private func setupPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        catImageView.addGestureRecognizer(pinchGesture)
    }

    private func configure() {
        guard let vm = viewModel else { return }
        catImageView.image = nil
        currentScale = 1.0
        catImageView.transform = .identity

        ImageDownloader.shared.downloadImage(from: vm.imageUrl.absoluteString) { [weak self] image in
            DispatchQueue.main.async {
                self?.catImageView.image = image
            }
        }
    }


    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }

        if gesture.state == .changed {
            var scale = gesture.scale
            scale = max(minScale / currentScale, min(scale, maxScale / currentScale))
            view.transform = view.transform.scaledBy(x: scale, y: scale)
            currentScale *= scale
            gesture.scale = 1.0
        } else if gesture.state == .ended {
            if currentScale > 1.0 {
                UIView.animate(withDuration: 0.2) {
                    view.transform = .identity
                }
                currentScale = 1.0
            }
        }
    }
}
