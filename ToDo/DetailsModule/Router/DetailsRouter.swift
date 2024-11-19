//
//  DetailsRouter.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

protocol DetailsRouterProtocol: AnyObject {
    static func createDetailsModule(with task: Task?, updateBlock: @escaping EmptyBlock) -> UIViewController
    func goBack(from view: DetailsViewProtocol)
}

final class DetailsRouter: DetailsRouterProtocol {
    static func createDetailsModule(with task: Task?, updateBlock: @escaping EmptyBlock) -> UIViewController {
        let controller: DetailsViewProtocol = DetailsViewController()
        let presenter: DetailsPresenterProtocol = DetailsPresenter()
        let interactor: DetailsInteractorProtocol = DetailsInteractor()
        let router: DetailsRouterProtocol = DetailsRouter()
        
        controller.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = controller
        presenter.task = task
        presenter.updateBlock = updateBlock
        interactor.presenter = presenter
        
        return controller as? UIViewController ?? UIViewController()
    }
    
    func goBack(from view: DetailsViewProtocol) {
        guard let controller = view as? UIViewController else {
            fatalError("Invalid view protocol type")
        }
        controller.navigationController?.popViewController(animated: true)
    }
}
