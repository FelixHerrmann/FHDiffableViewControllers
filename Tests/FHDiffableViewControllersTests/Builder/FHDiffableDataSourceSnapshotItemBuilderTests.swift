//
//  FHDiffableDataSourceSnapshotItemBuilderTests.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 04.01.22.
//

import XCTest
@testable import FHDiffableViewControllers

final class FHDiffableDataSourceSnapshotItemBuilderTests: XCTestCase {
    
    func testSingleItem() {
        let items = _buildItems {
            0
        }
        XCTAssertEqual(items, [0])
    }
    
    func testMultipleItems() {
        let items = _buildItems {
            1
            2
            3
            4
        }
        XCTAssertEqual(items, [1, 2, 3, 4])
    }
    
    func testAllBuildMethods() {
        let items = _buildItems {
            
            // buildArray
            for i in 0...2 {
                i
            }
            
            // buildOptional
            let optional: Int? = 3
            if let unwrappedOptional = optional {
                unwrappedOptional
            }
            
            // buildEither
            if .random() {
                4
            } else {
                4
            }
        }
        
        XCTAssertEqual(items, [0, 1, 2, 3, 4])
    }
}

extension FHDiffableDataSourceSnapshotItemBuilderTests {
    
    private func _buildItems<T: Hashable>(@FHDiffableDataSourceSnapshotItemBuilder<T> builder: () throws -> [T]) rethrows -> [T] {
        return try builder()
    }
}

