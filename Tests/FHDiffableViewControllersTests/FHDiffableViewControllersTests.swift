//
//  FHDiffableViewControllersTests.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 15.08.21.
//

import XCTest
@testable import FHDiffableViewControllers

final class FHDiffableViewControllersTests: XCTestCase {
    
    func testTableView() {
        let tableViewController = TableViewController()
        tableViewController.applySnapshot([
            TableViewController.FHSection(0, items: ["a", "b"]),
            TableViewController.FHSection(1, items: ["c", "d"])
        ], animatingDifferences: false)
        
        let a = tableViewController.dataSource.itemIdentifier(for: [0, 0])
        let d = tableViewController.dataSource.itemIdentifier(for: [1, 1])
        XCTAssertEqual(a, "a")
        XCTAssertEqual(d, "d")
    }
    
    func testCollectionView() {
        let collectionViewController = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewController.applySnapshot([
            CollectionViewController.FHSection(0, items: ["a", "b"]),
            CollectionViewController.FHSection(1, items: ["c", "d"])
        ], animatingDifferences: false)
        
        let a = collectionViewController.dataSource.itemIdentifier(for: [0, 0])
        let d = collectionViewController.dataSource.itemIdentifier(for: [1, 1])
        XCTAssertEqual(a, "a")
        XCTAssertEqual(d, "d")
    }
}
