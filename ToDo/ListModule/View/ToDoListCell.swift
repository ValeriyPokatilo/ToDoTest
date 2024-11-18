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
    
    private let icon: UIImageView = {
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
            icon.image = UIImage(systemName: "checkmark.circle")
            icon.tintColor = .yellow
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
            icon.tintColor = .gray
            icon.image = UIImage(systemName: "circle")
            titleLabel.text = model.title
        }
    }
    
    private func configureAppearance() {
        backgroundColor = .black
        selectionStyle = .none
        
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    private func addViews() {
        addSubview(icon)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(dateLabel)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
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
