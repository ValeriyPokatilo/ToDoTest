//
//  FooterView.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

final class FooterView: UIView {
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let iconView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "square.and.pencil")
        icon.image = image
        icon.tintColor = .yellow
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configureAppearance()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with count: Int) {
        countLabel.text = "\(count) \(String.taskCount)"
    }
    
    private func addViews() {
        addSubview(countLabel)
        addSubview(iconView)
    }
    
    private func configureAppearance() {
        countLabel.text = "0 \(String.taskCount)"
        backgroundColor = .darkGray
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 28),
            iconView.widthAnchor.constraint(equalToConstant: 68)
        ])
    }
}
