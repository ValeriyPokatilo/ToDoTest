//
//  ToDoListCellTests.swift
//  ToDoTests
//
//  Created by Valeriy P on 20.11.2024.
//

import XCTest
@testable import ToDo

final class ToDoListCellTests: XCTestCase {
    
    private var cell: ToDoListCell!
    
    override func setUp() {
        super.setUp()
        cell = ToDoListCell()
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    func testConfigureIcon_CompletedTask() {
        // Given
        let task = Task(context: CoreDataManager().context)
        task.completed = true
        
        // When
        cell.configure(with: task)
        
        // Then
        XCTAssertEqual(cell.iconView.image, UIImage(systemName: "checkmark.circle"))
        XCTAssertEqual(cell.iconView.tintColor, UIColor.yellow)
    }
    
    func testConfigureIcon_UncompletedTask() {
        // Given
        let task = Task(context: CoreDataManager().context)
        task.completed = false
        
        // When
        cell.configure(with: task)
        
        // Then
        XCTAssertEqual(cell.iconView.image, UIImage(systemName: "circle"))
        XCTAssertEqual(cell.iconView.tintColor, UIColor.gray)
    }
}
