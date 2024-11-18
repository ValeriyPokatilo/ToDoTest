//
//  ListPresenter.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation

protocol ListPresenterProtocol: AnyObject {
    var view: ListViewProtocol? { get set }
    var interactor: ListInteractorProtocol? { get set }
    func getTasks()
    func didGetTasks(tasks: [Task])
    func didLoadTasks()
    func showAlert(error: Error)
}

final class ListPresenter: ListPresenterProtocol {

    var view: ListViewProtocol?
    var interactor: (any ListInteractorProtocol)?

    func getTasks() {
        interactor?.getTasks()
    }
    
    func didGetTasks(tasks: [Task]) {
        view?.showTasks(tasks: tasks)
    }
    
    func didLoadTasks() {
        
    }
    
    func showAlert(error: Error) {
        view?.showAlert(error: error)
    }
}
