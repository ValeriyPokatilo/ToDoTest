//
//  ListRouter.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

protocol ListRouterProtocol {
    static func createListModule() -> UINavigationController
}

final class ListRouter: ListRouterProtocol {
    static func createListModule() -> UINavigationController {
        let controller: ListViewProtocol = ListViewController()
        let presenter: ListPresenterProtocol = ListPresenter()
        let interactor: ListInteractorProtocol = ListInteractor()
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        guard let viewController = controller as? UIViewController else {
            return UINavigationController()
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
