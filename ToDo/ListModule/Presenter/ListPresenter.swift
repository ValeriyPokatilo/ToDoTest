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
    var router: ListRouterProtocol? { get set }
    func getTasks()
    func didGetTasks(tasks: [Task])
    func didLoadTasks()
    func showAlert(error: Error)
    func showDetails(task: Task)
    func deleteTask(task: Task, completion: @escaping EmptyBlock)
    func shareTask(task: Task)
}

final class ListPresenter: ListPresenterProtocol {

    var view: ListViewProtocol?
    var interactor: ListInteractorProtocol?
    var router: ListRouterProtocol?

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
    
    func showDetails(task: Task) {
        guard let view else {
            return
        }
        router?.showDetails(view: view, task: task)
    }
    
    func deleteTask(task: Task, completion: @escaping EmptyBlock) {
        interactor?.deleteTask(task: task, completion: completion)
    }
    
    func shareTask(task: Task) {
        view?.shareTask(shareText: "Задача: \(task.title ?? ""), содержание: \(task.description)")
    }
}
