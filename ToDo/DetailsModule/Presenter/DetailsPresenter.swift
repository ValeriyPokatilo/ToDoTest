//
//  DetailsPresenter.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation
 
protocol DetailsPresenterProtocol: AnyObject {
    var view: DetailsViewProtocol? { get set }
    var interactor: DetailsInteractorProtocol? { get set }
    var router: DetailsRouterProtocol? { get set }
    var task: Task? { get set }
    var updateBlock: EmptyBlock? { get set }
    func showTask()
    func createTask(title: String, description: String)
    func updateTask(task: Task, title: String, description: String)
}

final class DetailsPresenter: DetailsPresenterProtocol {
    
    weak var view: DetailsViewProtocol?
    var interactor: DetailsInteractorProtocol?
    var router: DetailsRouterProtocol?
    var task: Task?
    var updateBlock: EmptyBlock?

    func showTask() {
        if let task {
            view?.showTask(task: task)
        }
    }
    
    func createTask(title: String, description: String) {
        interactor?.createTask(title: title, description: description) { [weak self] in
            if let view = self?.view {
                self?.router?.goBack(from: view)
                self?.updateBlock?()
            }
        }
    }
    
    func updateTask(task: Task, title: String, description: String) {
        interactor?.updateTask(task: task, title: title, description: description) { [weak self] in
            if let view = self?.view {
                self?.router?.goBack(from: view)
                self?.updateBlock?()
            }
        }
    }
}
