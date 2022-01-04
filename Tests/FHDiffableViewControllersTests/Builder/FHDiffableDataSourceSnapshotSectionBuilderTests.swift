//
//  FHDiffableDataSourceSnapshotSectionBuilderTests.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 04.01.22.
//

import XCTest
@testable import FHDiffableViewControllers

final class FHDiffableDataSourceSnapshotSectionBuilderTests: XCTestCase {
    
    func testSingleSection() {
        let sections = _buildSections {
            FHDiffableDataSourceSnapshotSection(0, items: [0, 1])
        }
        XCTAssertEqual(sections, [FHDiffableDataSourceSnapshotSection(0, items: [0, 1])])
    }
    
    func testMultipleSections() {
        let sections = _buildSections {
            FHDiffableDataSourceSnapshotSection(1, items: [0, 1])
            FHDiffableDataSourceSnapshotSection(2, items: [0, 1])
            FHDiffableDataSourceSnapshotSection(3, items: [0, 1])
            FHDiffableDataSourceSnapshotSection(4, items: [0, 1])
        }
        XCTAssertEqual(sections, [
            FHDiffableDataSourceSnapshotSection(1, items: [0, 1]),
            FHDiffableDataSourceSnapshotSection(2, items: [0, 1]),
            FHDiffableDataSourceSnapshotSection(3, items: [0, 1]),
            FHDiffableDataSourceSnapshotSection(4, items: [0, 1]),
        ])
    }
    
    func testAllBuildMethods() {
        let sections = _buildSections {

            // buildArray
            for i in 0...2 {
                FHDiffableDataSourceSnapshotSection(i, items: [0, 1])
            }

            // buildOptional
            let optional: Int? = 3
            if let unwrappedOptional = optional {
                FHDiffableDataSourceSnapshotSection(unwrappedOptional, items: [0, 1])
            }

            // buildEither
            if .random() {
                FHDiffableDataSourceSnapshotSection(4, items: [0, 1])
            } else {
                FHDiffableDataSourceSnapshotSection(4, items: [0, 1])
            }
        }

        XCTAssertEqual(sections, [
            FHDiffableDataSourceSnapshotSection(0, items: [0, 1]),
            FHDiffableDataSourceSnapshotSection(1, items: [0, 1]),
            FHDiffableDataSourceSnapshotSection(2, items: [0, 1]),
            FHDiffableDataSourceSnapshotSection(3, items: [0, 1]),
            FHDiffableDataSourceSnapshotSection(4, items: [0, 1]),
        ])
    }
}

extension FHDiffableDataSourceSnapshotSectionBuilderTests {
    
    private func _buildSections<T: Hashable, U: Hashable>(@FHDiffableDataSourceSnapshotSectionBuilder<T, U> builder: () throws -> [FHDiffableDataSourceSnapshotSection<T, U>]) rethrows -> [FHDiffableDataSourceSnapshotSection<T, U>] {
        return try builder()
    }
}

