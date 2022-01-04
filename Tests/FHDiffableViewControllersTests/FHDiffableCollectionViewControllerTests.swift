//
//  FHDiffableCollectionViewControllerTests.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 04.01.22.
//

import XCTest
@testable import FHDiffableViewControllers

final class FHDiffableCollectionViewControllerTests: XCTestCase {
    
    func testSnapshot() {
        let collectionViewController = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewController.applySnapshot([
            CollectionViewController.FHSection(0, items: ["a", "b"]),
            CollectionViewController.FHSection(1, items: ["c", "d"]),
        ], animatingDifferences: false)
        
        XCTAssertEqual(collectionViewController.dataSource.itemIdentifier(for: [0, 0]), "a")
        XCTAssertEqual(collectionViewController.dataSource.itemIdentifier(for: [0, 1]), "b")
        XCTAssertEqual(collectionViewController.dataSource.itemIdentifier(for: [1, 0]), "c")
        XCTAssertEqual(collectionViewController.dataSource.itemIdentifier(for: [1, 1]), "d")
        
        XCTAssertEqual(collectionViewController.dataSource.snapshot().sectionIdentifiers[0], 0)
        XCTAssertEqual(collectionViewController.dataSource.snapshot().sectionIdentifiers[1], 1)
    }
}
