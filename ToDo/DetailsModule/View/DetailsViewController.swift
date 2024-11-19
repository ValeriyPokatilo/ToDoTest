//
//  DetailsViewController.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

fileprivate enum Constant {
    static let horizontalOffset: CGFloat = 20
    static let topOffset: CGFloat = 8
    static let descriptionTopOffset: CGFloat = 16

}

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
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
        descriptionTextView.delegate = self
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.topOffset),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.horizontalOffset),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.horizontalOffset),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Constant.topOffset),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.horizontalOffset),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.horizontalOffset),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constant.descriptionTopOffset),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.horizontalOffset),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.horizontalOffset),
        ])
    }
    
    func showTask(task: Task) {
        titleTextField.text = task.title
        dateLabel.text = task.date.toString
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
                presenter?.updateTask(
                    task: task,
                    title: titleTextField.text.emptyIfNil,
                    description: descriptionTextView.text
                )
            } else {
                presenter?.createTask(
                    title: titleTextField.text.emptyIfNil,
                    description: descriptionTextView.text
                )
            }
            return false
        }
        return true
    }
}
