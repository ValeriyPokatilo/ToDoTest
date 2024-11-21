//
//  DetailsPresenterTests.swift
//  ToDoTests
//
//  Created by Valeriy P on 20.11.2024.
//

import XCTest
@testable import ToDo

final class DetailsMockView: DetailsViewProtocol {
    var presenter: DetailsPresenterProtocol?
    
    var titleTest: String?
    var descriptionTest: String?
    
    func showTask(task: Task) {
        titleTest = task.title
        descriptionTest = task.desc
    }
}

final class DetailsPresenterTests: XCTestCase {
    var view: DetailsMockView!
    var task: Task!
    var presenter: DetailsPresenterProtocol!

    override func setUp() {
        task = Task(context: CoreDataManager().context)
        task.title = "Foo"
        task.desc = "Bar"
        view = DetailsMockView()
        presenter = DetailsPresenter()
        presenter.view = view
    }

    override func tearDown() {
        view = nil
        task = nil
        presenter = nil
    }
    
    func testShowTask() {
        // Given
        presenter.task = task
        
        // When
        presenter.showTask()
        
        // Then
        XCTAssertEqual(view.titleTest, task.title)
        XCTAssertEqual(view.descriptionTest, task.desc)
    }
}
