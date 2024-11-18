//
//  DetailsRouter.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

protocol DetailsRouterProtocol: AnyObject {
    static func createDetailsModule(with task: Task) -> UIViewController
}

final class DetailsRouter: DetailsRouterProtocol {
    static func createDetailsModule(with task: Task) -> UIViewController {
        let controller: DetailsViewProtocol = DetailsViewController()
        let presenter: DetailsPresenterProtocol = DetailsPresenter()
        let interactor: DetailsInteractorProtocol = DetailsInteractor()
        let router: DetailsRouterProtocol = DetailsRouter()
        
        controller.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = controller
        interactor.task = task
        interactor.presenter = presenter
        
        return controller as? UIViewController ?? UIViewController()
    }
}
