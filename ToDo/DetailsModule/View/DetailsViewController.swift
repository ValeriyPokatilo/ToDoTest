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
        
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.font = .systemFont(ofSize: 34, weight: .bold)
        titleTextField.textColor = .white
        titleTextField.returnKeyType = .continue
        return titleTextField
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
    
    private let descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = .black
        descriptionTextView.returnKeyType = .go
        return descriptionTextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        configureAppearance()
        configureLayout()
        
        presenter?.showTask()
    }
    
    private func addViews() {
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
    }
    
    private func configureAppearance() {
        view.backgroundColor = .black
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
        descriptionTextView.delegate = self
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func showTask(task: Task) {
        titleTextField.text = task.title
        dateLabel.text = task.date?.toString()
        descriptionTextView.text = task.desc
    }
}

extension DetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        descriptionTextView.becomeFirstResponder()
        return true
    }
}

extension DetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if let task = presenter?.task {
                presenter?.updateTask(task: task, title: titleTextField.text ?? "", description: descriptionTextView.text)
            } else {
                presenter?.createTask(title: titleTextField.text ?? "", description: descriptionTextView.text)
            }
            return false
        }
        return true
    }
}
