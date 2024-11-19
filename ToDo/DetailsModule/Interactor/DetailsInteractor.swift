//
//  DetailsInteractor.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation

protocol DetailsInteractorProtocol: AnyObject {
    var presenter: DetailsPresenterProtocol? { get set }
    func createTask(title: String, description: String, completion: @escaping EmptyBlock)
    func updateTask(task: Task, title: String, description: String, completion: @escaping EmptyBlock)
}

final class DetailsInteractor: DetailsInteractorProtocol {
    weak var presenter: DetailsPresenterProtocol?
    
    func createTask(title: String, description: String, completion: @escaping EmptyBlock) {
        CoreDataManager.shared.saveElement(title: title, description: description, completed: false) {
            completion()
        }
    }
    
    func updateTask(task: Task, title: String, description: String, completion: @escaping EmptyBlock) {
        CoreDataManager.shared.saveElement(task: task, title: title, description: description) {
            completion()
        }
    }
}
