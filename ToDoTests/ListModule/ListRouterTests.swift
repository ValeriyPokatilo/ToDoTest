//
//  ListRouterTests.swift
//  ToDoTests
//
//  Created by Valeriy P on 20.11.2024.
//

import XCTest
@testable import ToDo

final class ListRouterTests: XCTestCase {
    func testCreateListModule_ReturnsNavigationController() {
        // Given
        
        // When
        let navigationController = ListRouter.createListModule()
        
        // Then
        XCTAssertTrue(navigationController.topViewController is ListViewController)
    }
    
    func testShowDetails_PushesDetailsController() {
        // Given
        let router = ListRouter()
        let navigationController = ListRouter.createListModule()
        let view = navigationController.topViewController as! ListViewProtocol
        
        // When
        router.showDetails(view: view, task: Task(), updateBlock: {})
        
        // Then
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.topViewController is DetailsViewController)
    }
}
