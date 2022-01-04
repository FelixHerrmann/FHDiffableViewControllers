//
//  FHDiffableDataSourceSnapshotSectionBuilder.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 04.01.22.
//

/// Build the sections for a ``FHDiffableTableViewController`` or ``FHDiffableCollectionViewController``.
@resultBuilder
public enum FHDiffableDataSourceSnapshotSectionBuilder<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable> {
    
    public static func buildExpression(_ expression: FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>) -> [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>] {
        return [expression]
    }
    
    public static func buildBlock(_ components: [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>]...) -> [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>] {
        return components.flatMap { $0 }
    }
    
    public static func buildArray(_ components: [[FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>]]) -> [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>]?) -> [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>] {
        return component ?? []
    }
    
    public static func buildEither(first component: [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>]) -> [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>] {
        return component
    }
    
    public static func buildEither(second component: [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>]) -> [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>] {
        return component
    }
}
