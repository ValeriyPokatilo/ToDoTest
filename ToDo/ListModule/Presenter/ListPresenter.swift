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
    func getTasks(searchText: String?)
    func didGetTasks(tasks: [Task])
    func showAlert(title: String)
    func showDetails(task: Task?, updateBlock: @escaping EmptyBlock)
    func deleteTask(task: Task, completion: @escaping EmptyBlock)
    func shareTask(task: Task)
    func startSpeechRecognition()
    func didRecognizeSpeech(text: String)
}

final class ListPresenter: ListPresenterProtocol {

    var view: ListViewProtocol?
    var interactor: ListInteractorProtocol?
    var router: ListRouterProtocol?
    
    private var timeoutTimer: Timer?

    func getTasks(searchText: String?) {
        interactor?.getTasks(searchText: searchText)
    }
    
    func didGetTasks(tasks: [Task]) {
        view?.showTasks(tasks: tasks)
    }
    
    func showAlert(title: String) {
        view?.showAlert(title: title)
    }
    
    func showDetails(task: Task?, updateBlock: @escaping EmptyBlock) {
        guard let view else {
            return
        }
        router?.showDetails(view: view, task: task) {
            updateBlock()
        }
    }
    
    func deleteTask(task: Task, completion: @escaping EmptyBlock) {
        interactor?.deleteTask(task: task, completion: completion)
    }
    
    func shareTask(task: Task) {
        view?.shareTask(shareText: "Задача: \(task.title ?? ""), содержание: \(task.description)")
    }
    
    func startSpeechRecognition() {
        interactor?.startSpeechRecognition()
        
        timeoutTimer?.invalidate()
        timeoutTimer = Timer.scheduledTimer(
            timeInterval: 5.0,
            target: self,
            selector: #selector(stopOnTimeout),
            userInfo: nil,
            repeats: false
        )
    }
    
    func didRecognizeSpeech(text: String) {
        view?.setSearchText(text: text)
    }
    
    @objc private func stopOnTimeout() {
        interactor?.stopSpeechRecognition()
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
}
