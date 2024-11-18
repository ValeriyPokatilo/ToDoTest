//
//  ListViewController.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import UIKit

final class ListViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let cellId = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        configureAppearance()
        configureLayout()
    }
    
    private func addViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func configureAppearance() {
        title = .tasks
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.separatorColor = .gray
        tableView.register(ToDoListCell.self, forCellReuseIdentifier: cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .black
        searchBar.placeholder = .search
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoListCell()
        cell.configure(with: ToDoItem(title: "title", description: "description", date: "01/01/2025", completed: indexPath.row % 2 == 0))
        return cell
    }
}
