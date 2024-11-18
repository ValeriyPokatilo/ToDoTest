//
//  ListViewController.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

protocol ListViewProtocol: AnyObject {
    var presenter: ListPresenterProtocol? { get set }
    func showTasks(tasks: [Task])
    func showAlert(error: Error)
    func shareTask(shareText: String)
}

final class ListViewController: UIViewController, ListViewProtocol {
    
    var presenter: ListPresenterProtocol?
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private var footerView = FooterView()
    
    private let cellId = "cell"
    
    private var taskList = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        configureAppearance()
        configureLayout()
                
        presenter?.getTasks()
    }
    
    private func addViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(footerView)
    }
    
    private func configureAppearance() {
        title = .tasks
        view.backgroundColor = .darkGray
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
    
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .gray
        tableView.register(ToDoListCell.self, forCellReuseIdentifier: cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .black
        searchBar.placeholder = .search
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func showTasks(tasks: [Task]) {
        taskList = tasks
        footerView.configure(with: tasks.count)
        tableView.reloadData()
    }
    
    func showAlert(error: Error) {
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        presenter?.showDetails(task: task)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoListCell()
        let task = taskList[indexPath.row]
        
        cell.didSelectEdit = { [weak self] in
            self?.presenter?.showDetails(task: task)
        }
        
        cell.didSelectShare = { [weak self] in
            self?.presenter?.shareTask(task: task)
        }
        
        cell.didSelectDelete = { [weak self] in
            guard let self else {
                return
            }
            self.presenter?.deleteTask(task: task) {
                self.taskList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.footerView.configure(with: self.taskList.count)
            }
        }
        
        cell.configure(with: taskList[indexPath.row])
        return cell
    }
    
    func shareTask(shareText: String) {
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}
