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
            .init(sectionIdentifier: 0, itemIdentifiers: ["a", "b"]),
            .init(sectionIdentifier: 1, itemIdentifiers: ["c", "d"])
        ], animatingDifferences: false)
        
        let a = tableViewController.dataSource.itemIdentifier(for: [0, 0])
        let d = tableViewController.dataSource.itemIdentifier(for: [1, 1])
        XCTAssertEqual(a, "a")
        XCTAssertEqual(d, "d")
    }
    
    func testCollectionView() {
        let collectionViewController = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewController.applySnapshot([
            .init(sectionIdentifier: 0, itemIdentifiers: ["a", "b"]),
            .init(sectionIdentifier: 1, itemIdentifiers: ["c", "d"])
        ], animatingDifferences: false)
        
        let a = collectionViewController.dataSource.itemIdentifier(for: [0, 0])
        let d = collectionViewController.dataSource.itemIdentifier(for: [1, 1])
        XCTAssertEqual(a, "a")
        XCTAssertEqual(d, "d")
    }
}
