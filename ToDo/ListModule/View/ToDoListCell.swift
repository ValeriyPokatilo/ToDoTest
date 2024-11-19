//
//  ToDoListCell.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

final class ToDoListCell: UITableViewCell {
    
    var didSelectEdit: EmptyBlock?
    var didSelectShare: EmptyBlock?
    var didSelectDelete: EmptyBlock?
    var didToggleCheckmark: EmptyBlock?
    
    private let iconView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = .white
        label.layer.opacity = 0.5
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
        addViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Task) {
        descriptionLabel.text = model.description
        if let date = model.date {
            dateLabel.text = date.toString()
        }
        
        if model.completed {
            iconView.image = UIImage(systemName: "checkmark.circle")
            iconView.tintColor = .yellow
            titleLabel.layer.opacity = 0.5
            let attributedText = NSAttributedString(
                string: model.title ?? "",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
            )
            titleLabel.attributedText = attributedText
            descriptionLabel.layer.opacity = 0.5
        } else {
            iconView.tintColor = .gray
            iconView.image = UIImage(systemName: "circle")
            titleLabel.text = model.title
        }
    }
    
    private func configureAppearance() {
        backgroundColor = .black
        selectionStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        iconView.addGestureRecognizer(tapGesture)
        iconView.isUserInteractionEnabled = true
        
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    private func addViews() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    @objc private func handleTap() {
        didToggleCheckmark?()
    }
}

extension ToDoListCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(
                title: .edit,
                image: UIImage(systemName: "pencil")
            ) { [weak self] _ in
                self?.didSelectEdit?()
            }
            
            let shareAction = UIAction(
                title: .share,
                image: UIImage(systemName: "square.and.arrow.up")
            ) { [weak self] _ in
                self?.didSelectShare?()
            }
            
            let deleteAction = UIAction(
                title: .delete, image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) {[weak self] _ in
                self?.didSelectDelete?()
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}
