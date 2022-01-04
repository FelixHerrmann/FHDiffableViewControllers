//
//  FHDiffableDataSourceSnapshotSection.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 09.06.20.
//

/// A representation of the **UITableView** or **UICollectionView** sections data.
public struct FHDiffableDataSourceSnapshotSection<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: Hashable {
    
    /// The identifier of the section.
    public var sectionIdentifier: SectionIdentifierType
    
    /// The identifiers from the section items.
    public var itemIdentifiers: [ItemIdentifierType]
    
    /// Instantiates an instance of ``FHDiffableDataSourceSnapshotSection``.
    /// - Parameters:
    ///   - sectionIdentifier: The identifier of the section.
    ///   - itemIdentifiers: The identifiers from the section's items.
    public init(_ sectionIdentifier: SectionIdentifierType, items itemIdentifiers: [ItemIdentifierType]) {
        self.sectionIdentifier = sectionIdentifier
        self.itemIdentifiers = itemIdentifiers
    }
}


// MARK: - Item Builder

extension FHDiffableDataSourceSnapshotSection {
    
    /// A typealias for ``FHDiffableDataSourceSnapshotItemBuilder`` with the item identifier type.
    public typealias FHItemBuilder = FHDiffableDataSourceSnapshotItemBuilder<ItemIdentifierType>
    
    /// Instantiates an instance of ``FHDiffableDataSourceSnapshotSection`` with a result builder.
    /// - Parameters:
    ///   - sectionIdentifier: The identifier of the section.
    ///   - itemBuilder: A builder to build the item identifiers for the section.
    public init(_ sectionIdentifier: SectionIdentifierType, @FHItemBuilder itemBuilder: () throws -> [ItemIdentifierType]) rethrows {
        self.init(sectionIdentifier, items: try itemBuilder())
    }
}
