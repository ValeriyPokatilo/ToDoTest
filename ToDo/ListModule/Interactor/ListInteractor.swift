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
        if isFirstLaunch() {
            loaFromJson()
        } else {
            loadFromCoreData()
        }
    }
    
    private func loadFromCoreData() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let result = CoreDataManager.shared.fetchTasks(searchText: nil)
            
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.presenter?.didGetTasks(tasks: tasks)
                case .failure(let error):
                    self?.presenter?.showAlert(error: error)
                }
            }
        }
    }
    
    private func loaFromJson() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let apiString = "https://dummyjson.com/todos"
            guard let url = URL(string: apiString) else {
                return
            }
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    self?.presenter?.showAlert(error: error)
                    return
                }
                
                if let data = data {
                    let dummyData = try? JSONDecoder().decode(DummyData.self, from: data)

                    dummyData?.todos.forEach {
                        CoreDataManager().createElement(title: $0.todo, description: "", completed: $0.completed)
                    }
                    
                    self?.getTasks()
                }
            }
            
            task.resume()
        }
    }
    
    private func isFirstLaunch() -> Bool {
        let hasLaunchedKey = "hasLaunchedBefore"
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: hasLaunchedKey) {
            return false
        } else {
            userDefaults.set(true, forKey: hasLaunchedKey)
            return true
        }
    }
}