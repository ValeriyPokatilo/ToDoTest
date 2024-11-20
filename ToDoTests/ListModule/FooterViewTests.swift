//
//  FooterViewTests.swift
//  ToDoTests
//
//  Created by Valeriy P on 20.11.2024.
//

import XCTest
@testable import ToDo

final class FooterViewTests: XCTestCase {
    
    private var footerView: FooterView!
    
    override func setUp() {
        super.setUp()
        footerView = FooterView()
    }
    
    override func tearDown() {
        footerView = nil
        super.tearDown()
    }
    
    func testConfigureCountLabel() {
        // Given
        let testCases: [(count: Int, expected: String)] = [
            (0, "0 задач"),
            (1, "1 задача"),
            (2, "2 задачи"),
            (4, "4 задачи"),
            (5, "5 задач"),
            (11, "11 задач"),
            (21, "21 задача"),
            (22, "22 задачи"),
            (25, "25 задач"),
            (101, "101 задача"),
            (111, "111 задач"),
            (114, "114 задач"),
        ]
        
        // When / Then
        testCases.forEach { testCase in
            footerView.configure(with: testCase.0)
            XCTAssertEqual(footerView.countLabel.text, testCase.1)
        }
    }
}
