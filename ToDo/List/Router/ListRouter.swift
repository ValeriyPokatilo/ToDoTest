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
        let controller = ListViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
}
