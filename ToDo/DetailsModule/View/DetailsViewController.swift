//
//  DetailsViewController.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

protocol DetailsViewProtocol: AnyObject {
    var presenter: DetailsPresenterProtocol? { get set }
    func showTask(task: Task)
}

final class DetailsViewController: UIViewController, DetailsViewProtocol {
    
    var presenter: DetailsPresenterProtocol?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.numberOfLines = 1
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        configureAppearance()
        configureLayout()
        
        presenter?.showTask()
    }
    
    private func addViews() {
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(descriptionLabel)
    }
    
    private func configureAppearance() {
        view.backgroundColor = .black
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func showTask(task: Task) {
        titleLabel.text = task.title
        dateLabel.text = task.date?.toString()
        descriptionLabel.text = task.desc
    }
}
