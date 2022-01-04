//
//  FHDiffableCollectionViewController.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 10.06.20.
//

import UIKit

/// A subclass of **UICollectionViewController** with diffable data source.
open class FHDiffableCollectionViewController<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: UICollectionViewController {
    
    
    // MARK: - Typealias
    
    /// A typealias for **UICollectionViewDiffableDataSource** with the identifier types.
    public typealias FHDataSource = UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for **NSDiffableDataSourceSnapshot** with the identifier types.
    public typealias FHSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for **FHDiffableDataSourceSnapshotSection** with the identifier types.
    public typealias FHSection = FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>
    
    
    // MARK: - Private Properties
    
    private lazy var _dataSource: FHDataSource = {
        let dataSource = FHDataSource(collectionView: collectionView, cellProvider: cellProvider)
        dataSource.supplementaryViewProvider = supplementaryViewProvider
        return dataSource
    }()
    
    
    // MARK: - Public Properties
    
    /// The cell provider which creates the cells.
    ///
    /// Override this property to configure a custom cell.
    ///
    /// There is no default implemenation for this property.
    /// It will raise a fatal error if you don't override it like the following:
    ///
    /// ```swift
    /// override var cellProvider: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider {
    ///     return { collectionView, indexPath, itemIdentifier in
    ///         let cell = collectionView.dequeueReusableCell(withIdentifier: /*your identifier*/, for: indexPath) as? CustomCell
    ///         /*customize your cell here*/
    ///         return cell
    ///     }
    /// }
    /// ```
    ///
    /// - Important: Do not forget to register the reusable cell before the first snapshot is applied!
    open var cellProvider: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider {
        fatalError("Implement the cellProvider in your subclass")
    }
    
    /// The supplementary view provider which creates the supplementary views.
    ///
    /// Override this property to configure a custom supplementary view.
    ///
    /// The default implementation returns `nil`.
    ///
    /// ```swift
    /// override var supplementaryViewProvider: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.SupplementaryViewProvider? {
    ///     return { collectionView, kind, indexPath in
    ///         let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: /*your identifier*/, for: indexPath) as? CustomReusableView
    ///         /*customize your supplementary view here*/
    ///         return supplementaryView
    ///     }
    /// }
    /// ```
    ///
    /// - Important: Do not forget to register the reusable view before the first snapshot is applied!
    open var supplementaryViewProvider: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.SupplementaryViewProvider? {
        return nil
    }
    
    /// The data source for the collection view.
    ///
    /// Override this property only if a custom **UICollectionViewDiffableDataSource** should be applied.
    /// For cell configuration override the ``cellProvider`` property.
    /// For supplementary view configuration override the ``supplementaryViewProvider`` property.
    ///
    /// ```swift
    /// lazy var customDataSource: CustomDataSource = {
    ///     let dataSource = CustomDataSource(collectionView: collectionView, cellProvider: cellProvider)
    ///     dataSource.supplementaryViewProvider = supplementaryViewProvider
    ///     return dataSource
    /// }()
    ///
    /// override var dataSource: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
    ///     return customDataSource
    /// }
    /// ```
    ///
    /// - Important: You need to use a lazy var for it to work properly!
    open var dataSource: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
        return _dataSource
    }
    
    
    // MARK: - Public Methods
    
    /// This method applies a new snapshot to the collection view.
    ///
    /// This is the equivalent for `reloadData()` or `performBatchUpdates(_:)`.
    ///
    /// - Parameters:
    ///   - sections: The sections for the collection view.
    ///   - animatingDifferences: A boolean value to deactivate the animation. Default value is `true`.
    ///   - completion: The completion block for when the update is finished. Default value is `nil`.
    open func applySnapshot(_ sections: [FHSection], animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = FHSnapshot()
        
        snapshot.appendSections(sections.map(\.sectionIdentifier))
        sections.forEach { snapshot.appendItems($0.itemIdentifiers, toSection: $0.sectionIdentifier) }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
}
