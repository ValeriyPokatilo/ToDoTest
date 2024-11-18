//
//  ListInteractor.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation

protocol ListInteractorProtocol: AnyObject {
    var presenter: ListPresenterProtocol? { get set }
    func getTasks()
}

final class ListInteractor: ListInteractorProtocol {
    
    weak var presenter: ListPresenterProtocol?
    
    func getTasks() {
        let tasks = DataManager.shared.getTasks()
        presenter?.didGetTasks(tasks: tasks)
    }
}
