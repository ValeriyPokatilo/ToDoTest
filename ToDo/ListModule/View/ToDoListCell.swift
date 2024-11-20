//
//  ToDoListCell.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

fileprivate enum Constant {
    static let horizontalOffset: CGFloat = 20
    static let verticalOffset: CGFloat = 12
    static let labelsLeadingOffset: CGFloat = 52
    static let titleLeadingOffset: CGFloat = 8
    static let interlineOffset: CGFloat = 6
    static let iconSize: CGFloat = 24
}

final class ToDoListCell: UITableViewCell {
    
    var didSelectEdit: EmptyBlock?
    var didSelectShare: EmptyBlock?
    var didSelectDelete: EmptyBlock?
    var didToggleCheckmark: EmptyBlock?
    
    static let id = "ToDoListCellId"
    
    let iconView: UIImageView = {
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
    
    func configure(with task: Task) {
        if task.completed {
            iconView.image = UIImage(systemName: "checkmark.circle")
            iconView.tintColor = .yellow
            titleLabel.layer.opacity = 0.5
            let attributedText = NSAttributedString(
                string: task.title.emptyIfNil,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
            )
            titleLabel.attributedText = attributedText
            descriptionLabel.layer.opacity = 0.5
        } else {
            iconView.tintColor = .gray
            iconView.image = UIImage(systemName: "circle")
            titleLabel.text = task.title
        }
        
        descriptionLabel.text = task.desc
        dateLabel.text = task.date.toString
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
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.verticalOffset),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.horizontalOffset),
            iconView.heightAnchor.constraint(equalToConstant: Constant.iconSize),
            iconView.widthAnchor.constraint(equalToConstant: Constant.iconSize),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.verticalOffset),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constant.titleLeadingOffset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.horizontalOffset),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constant.interlineOffset),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.labelsLeadingOffset),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.horizontalOffset),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constant.interlineOffset),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.labelsLeadingOffset),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.verticalOffset),
        ])
    }
    
    @objc private func handleTap() {
        didToggleCheckmark?()
    }
}

extension ToDoListCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
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
