//
//  FHDiffableDataSourceSnapshotItemBuilder.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 04.01.22.
//

/// Build the items for a ``FHDiffableDataSourceSnapshotSection``.
@resultBuilder
public enum FHDiffableDataSourceSnapshotItemBuilder<ItemIdentifierType: Hashable> {
    
    public static func buildExpression(_ expression: ItemIdentifierType) -> [ItemIdentifierType] {
        return [expression]
    }
    
    public static func buildBlock(_ components: [ItemIdentifierType]...) -> [ItemIdentifierType] {
        return components.flatMap { $0 }
    }
    
    public static func buildArray(_ components: [[ItemIdentifierType]]) -> [ItemIdentifierType] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [ItemIdentifierType]?) -> [ItemIdentifierType] {
        return component ?? []
    }
    
    public static func buildEither(first component: [ItemIdentifierType]) -> [ItemIdentifierType] {
        return component
    }
    
    public static func buildEither(second component: [ItemIdentifierType]) -> [ItemIdentifierType] {
        return component
    }
}
