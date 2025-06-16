import UIKit

class AttributeCell: UITableViewCell {
    static let reuseIdentifier = "AttributeCell"

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let progres = UIProgressView(progressViewStyle: .default)
    private let stackView = UIStackView()

    private var progressConstraints: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = .darkGray
        valueLabel.numberOfLines = 0

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        progres.removeFromSuperview()
        NSLayoutConstraint.deactivate(progressConstraints)
        progressConstraints.removeAll()
    }

    func configure(model: Attribute) {
        titleLabel.text = model.title
        valueLabel.text = model.value

        if model.type == .progres {
            progres.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(progres)
            progres.progressTintColor = .systemGreen
            progres.trackTintColor = .lightGray

            if let value = Float(model.value), (0...5).contains(value) {
                progres.progress = value / 5.0
            } else {
                progres.progress = 5
            }

            progressConstraints = [
                progres.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
                progres.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                progres.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                progres.heightAnchor.constraint(equalToConstant: 4),
                progres.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ]
            NSLayoutConstraint.activate(progressConstraints)
        } else {
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        }
    }
}
