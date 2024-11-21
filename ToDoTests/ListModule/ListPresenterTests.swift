//
//  ListPresenterTests.swift
//  ToDoTests
//
//  Created by Valeriy P on 20.11.2024.
//

import XCTest
@testable import ToDo

final class ListMockView: ListViewProtocol {
    var presenter: ListPresenterProtocol?
    
    var taskList: [Task] = []
    
    func showTasks(tasks: [Task]) {
        //
    }
    
    func showAlert(title: String) {
        //
    }
    
    func shareTask(shareText: String) {
        //
    }
    
    func setSearchText(text: String) {
        //
    }
}

final class MockNetworkService: NetworkServiceProtocol {
    var dummyTasks: [DummyTask]!
    
    init() {}
    
    convenience init(dummyTasks: [DummyTask]) {
        self.init()
        self.dummyTasks = dummyTasks
    }
    
    func getTasks(completion: @escaping (Result<[DummyTask]?, any Error>) -> Void) {
        completion(.success(dummyTasks))
    }
}

final class ListPresenterTests: XCTestCase {
    
    var view: ListViewProtocol!
    var presenter: ListPresenter!
    var networkService: NetworkServiceProtocol!
    var dummyTasks = [DummyTask]()
    
    override func setUp() {
        super.setUp()
        dummyTasks = [DummyTask(id: 1, todo: "Foo", completed: true, userId: 2)]
        view = ListMockView()
        networkService = MockNetworkService(dummyTasks: dummyTasks)
        presenter = ListPresenter()
    }
    
    override func tearDown() {
        dummyTasks = []
        view = nil
        networkService = nil
        presenter = nil
        super.tearDown()
    }
    
    func testGetTasks_Success() {
        // Given
        var catchTasks: [DummyTask]? = []
        
        // When
        networkService.getTasks(completion: { result in
            switch result {
            case .success(let tasks):
                catchTasks = tasks
            case .failure(let error):
                print(error)
            }
        })
        
        // Then
        XCTAssertNotEqual(catchTasks?.count, 0)
        XCTAssertEqual(catchTasks?.count, dummyTasks.count)
    }
}
