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
    func showTask()
}

final class DetailsPresenter: DetailsPresenterProtocol {
    
    weak var view: DetailsViewProtocol?
    var interactor: DetailsInteractorProtocol?
    var router: DetailsRouterProtocol?
    
    func showTask() {
        if let task = interactor?.task {
            view?.showTask(task: task)
        }
    }
}
