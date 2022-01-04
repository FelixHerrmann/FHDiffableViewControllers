//
//  FHDiffableTableViewControllersTests.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 15.08.21.
//

import XCTest
@testable import FHDiffableViewControllers

final class FHDiffableTableViewControllersTests: XCTestCase {
    
    func testSnapshot() {
        let tableViewController = TableViewController()
        tableViewController.applySnapshot([
            TableViewController.FHSection(0, items: ["a", "b"]),
            TableViewController.FHSection(1, items: ["c", "d"]),
        ], animatingDifferences: false)
        
        XCTAssertEqual(tableViewController.dataSource.itemIdentifier(for: [0, 0]), "a")
        XCTAssertEqual(tableViewController.dataSource.itemIdentifier(for: [0, 1]), "b")
        XCTAssertEqual(tableViewController.dataSource.itemIdentifier(for: [1, 0]), "c")
        XCTAssertEqual(tableViewController.dataSource.itemIdentifier(for: [1, 1]), "d")
        
        XCTAssertEqual(tableViewController.dataSource.snapshot().sectionIdentifiers[0], 0)
        XCTAssertEqual(tableViewController.dataSource.snapshot().sectionIdentifiers[1], 1)
    }
}
