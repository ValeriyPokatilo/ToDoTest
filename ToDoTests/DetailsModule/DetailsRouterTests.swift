//
//  DetailsRouterTests.swift
//  ToDoTests
//
//  Created by Valeriy P on 20.11.2024.
//

import XCTest
@testable import ToDo

final class DetailsRouterTests: XCTestCase {

    func testCreateDetailsModule_ReturnsViewController() {
        // Given
        
        // When
        let controller = DetailsRouter.createDetailsModule(with: nil, updateBlock: {})
        
        // Then
        XCTAssertTrue(controller is DetailsViewController)
    }
    
    func testGoBack_PopToList() {
        // Given
        let router = DetailsRouter()
        let navigationController = ListRouter.createListModule()
        let controller = DetailsRouter.createDetailsModule(with: nil, updateBlock: {})
        
        // When
        router.goBack(from: controller as! DetailsViewProtocol)
        
        // Then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.topViewController is ListViewController)
    }
}
