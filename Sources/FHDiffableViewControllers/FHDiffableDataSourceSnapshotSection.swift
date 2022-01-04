//
//  FHDiffableDataSourceSnapshotSection.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 09.06.20.
//

/// A representation of the **UITableView** or **UICollectionView** sections data.
public struct FHDiffableDataSourceSnapshotSection<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable> {
    
    /// The identifier of the section.
    public var sectionIdentifier: SectionIdentifierType
    
    /// The identifiers from the section items.
    public var itemIdentifiers: [ItemIdentifierType]
    
    
    /// Instantiates an instance of **FHDiffableDataSourceSnapshotSection**.
    /// - Parameters:
    ///   - sectionIdentifier: The identifier of the section.
    ///   - itemIdentifiers: The identifiers from the section items.
    public init(_ sectionIdentifier: SectionIdentifierType, items itemIdentifiers: [ItemIdentifierType]) {
        self.sectionIdentifier = sectionIdentifier
        self.itemIdentifiers = itemIdentifiers
    }
}
