//
//  ListRouter.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

protocol ListRouterProtocol {
    static func createListModule() -> UINavigationController
    func showDetails(view: ListViewProtocol, task: Task?, updateBlock: @escaping EmptyBlock)
}

final class ListRouter: ListRouterProtocol {
    static func createListModule() -> UINavigationController {
        let controller: ListViewProtocol = ListViewController()
        let presenter: ListPresenterProtocol = ListPresenter()
        let interactor: ListInteractorProtocol = ListInteractor()
        let router: ListRouterProtocol = ListRouter()
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        guard let viewController = controller as? UIViewController else {
            return UINavigationController()
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    func showDetails(view: ListViewProtocol, task: Task?, updateBlock: @escaping EmptyBlock) {
        let controller = DetailsRouter.createDetailsModule(with: task, updateBlock: updateBlock)
        
        guard let list = view as? UIViewController else {
            fatalError("Invalid View Protocol type")
        }
        
        list.navigationController?.pushViewController(controller, animated: true)
    }
}
