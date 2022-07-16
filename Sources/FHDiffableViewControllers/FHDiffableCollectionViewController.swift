//
//  FHDiffableCollectionViewController.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 10.06.20.
//

import UIKit

/// A subclass of `UICollectionViewController` with diffable data source.
///
/// The most simple subclass could look like the following:
/// ```swift
/// enum Section {
///     case main, detail
/// }
///
/// struct Item: Hashable {
///     var title: String
/// }
///
/// class CollectionViewController: FHDiffableCollectionViewController<Section, Item> {
///
///     override var cellProvider: UITableViewDiffableDataSource<Section, Item>.CellProvider {
///         return { collectionView, indexPath, item in
///             return collectionView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
///         }
///     }
///
///     override var supplementaryViewProvider: UICollectionViewDiffableDataSource<Section, Item>.SupplementaryViewProvider? {
///         return { collectionView, kind, indexPath in
///             switch kind {
///             case UICollectionView.elementKindSectionHeader:
///                 return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
///             default:
///                 return nil
///             }
///         }
///     }
///
///     override func viewDidLoad() {
///         super.viewDidLoad()
///
///         collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
///         collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
///
///         applySnapshot(animatingDifferences: false) {
///             FHSection(.main) {
///                 Item(title: "First Item"),
///                 Item(title: "Second Item")
///             }
///             FHSection(.detail) {
///                 Item(title: "Third Item")
///             }
///         }
///     }
/// }
/// ```
open class FHDiffableCollectionViewController<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: UICollectionViewController {
    
    
    // MARK: - Typealias
    
    /// A typealias for `UICollectionViewDiffableDataSource` with the identifier types.
    public typealias FHDataSource = UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for `NSDiffableDataSourceSnapshot` with the identifier types.
    public typealias FHSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for ``FHDiffableDataSourceSnapshotSection`` with the identifier types.
    public typealias FHSection = FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for ``FHDiffableDataSourceSnapshotSectionBuilder`` with the identifier types.
    public typealias FHSectionBuilder = FHDiffableDataSourceSnapshotSectionBuilder<SectionIdentifierType, ItemIdentifierType>
    
    
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
    /// There is no default implementation for this property.
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
    /// Override this property only if a custom `UICollectionViewDiffableDataSource` should be applied.
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
    /// There is also ``applySnapshot(animatingDifferences:sectionBuilder:completion:)`` with a result builder.
    ///
    /// - Important: All sections and all items per section must be unique.
    ///
    /// - Parameters:
    ///   - sections: The sections to generate a snapshot for the ``dataSource``.
    ///   - animatingDifferences: If `true`, the system animates the updates to the collection view. If `false`, the system doesn’t animate the updates to the collection view.
    ///   - completion: An optional closure to execute when the animations are complete. The system calls this closure from the main queue.
    open func applySnapshot(_ sections: [FHSection], animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = FHSnapshot()
        
        snapshot.appendSections(sections.map(\.sectionIdentifier))
        sections.forEach { snapshot.appendItems($0.itemIdentifiers, toSection: $0.sectionIdentifier) }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    /// This method applies a new snapshot build from a result builder to the collection view.
    ///
    /// This is the equivalent for `reloadData()` or `performBatchUpdates(_:)`.
    ///
    /// ```swift
    /// applySnapshot {
    ///     FHSection(.main) {
    ///         Item(title: "First")
    ///         Item(title: "Second")
    ///     }
    ///     FHSection(.detail) {
    ///         Item(title: "Third")
    ///     }
    /// }
    /// ```
    ///
    /// - Important: All sections and all items per section must be unique.
    ///
    /// - Parameters:
    ///   - animatingDifferences: If `true`, the system animates the updates to the collection view. If `false`, the system doesn’t animate the updates to the collection view.
    ///   - sectionBuilder: The section builder to generate a snapshot for the ``dataSource``.
    ///   - completion: An optional closure to execute when the animations are complete. The system calls this closure from the main queue.
    open func applySnapshot(animatingDifferences: Bool = true, @FHSectionBuilder sectionBuilder: () throws -> [FHSection], completion: (() -> Void)? = nil) rethrows {
        applySnapshot(try sectionBuilder(), animatingDifferences: animatingDifferences, completion: completion)
    }
}
