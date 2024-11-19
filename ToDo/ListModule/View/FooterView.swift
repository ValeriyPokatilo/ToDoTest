//
//  FooterView.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

fileprivate enum Constant {
    static let verticalOffset: CGFloat = 8
    static let buttonHeight: CGFloat = 28
    static let buttonWidth: CGFloat = 68
}

final class FooterView: UIView {
    
    var onCreateTap: EmptyBlock?
    
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
        countLabel.text = getTasksString(for: count)
    }
    
    private func addViews() {
        addSubview(countLabel)
        addSubview(iconView)
    }
    
    private func configureAppearance() {
        backgroundColor = .systemGray5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        iconView.addGestureRecognizer(tapGesture)
        iconView.isUserInteractionEnabled = true
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: Constant.verticalOffset),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.verticalOffset),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconView.heightAnchor.constraint(equalToConstant: Constant.buttonHeight),
            iconView.widthAnchor.constraint(equalToConstant: Constant.buttonWidth)
        ])
    }
    
    @objc private func handleTap() {
        onCreateTap?()
    }
    
    private func getTasksString(for count: Int) -> String {
        let remainder100 = count % 100
        let remainder10 = count % 10
        
        let word: String
        if remainder100 >= 11 && remainder100 <= 19 {
            word = "задач"
        } else if remainder10 == 1 {
            word = "задача"
        } else if remainder10 >= 2 && remainder10 <= 4 {
            word = "задачи"
        } else {
            word = "задач"
        }
        
        return "\(count) \(word)"
    }
}
