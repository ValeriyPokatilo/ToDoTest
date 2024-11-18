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
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let result = CoreDataManager.shared.fetchTasks(searchText: nil)
            
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.presenter?.didGetTasks(tasks: tasks)
                case .failure(let error):
                    fatalError()
                }
            }
        }
    }
}
