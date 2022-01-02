//
//  FHDiffableTableViewController.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 09.06.20.
//

import UIKit

/// A subclass of **UITableViewController** with diffable data source.
open class FHDiffableTableViewController<SectionIdentifierType, ItemIdentifierType>: UITableViewController where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    
    // MARK: - Typealias
    
    /// A typealias for **UITableViewDiffableDataSource** with the identifier types.
    public typealias FHDataSource = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for **NSDiffableDataSourceSnapshot** with the identifier types.
    public typealias FHSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for **FHDiffableDataSourceSnapshotSection** with the identifier types.
    public typealias FHSection = FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>
    
    
    // MARK: - Private Properties
    
    private lazy var _dataSource: FHDataSource = FHDataSource(tableView: tableView, cellProvider: cellProvider)
    
    
    // MARK: - Public Properties
    
    /// The cell provider which creates the cells.
    ///
    /// Override this property to configure a custom cell.
    ///
    /// There is no default implemenation for this property.
    /// It will raise a fatal error if you don't override it like the following:
    ///
    /// ```swift
    /// override var cellProvider: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider {
    ///     return { tableView, indexPath, itemIdentifier in
    ///         let cell = tableView.dequeueReusableCell(withIdentifier: /*your identifier*/, for: indexPath) as? CustomCell
    ///         /*customize your cell here*/
    ///         return cell
    ///     }
    /// }
    /// ```
    ///
    /// - Important: Do not forget to register the reusable cell before the first snapshot is applied!
    open var cellProvider: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider {
        fatalError("Implement the cellProvider in your subclass")
    }
    
    /// The data source for the table view.
    ///
    /// Override this property only if a custom **UITableViewDiffableDataSource** should be applied.
    /// For cell configuration override the ``cellProvider`` property.
    ///
    /// ```swift
    /// lazy var customDataSource = CustomDataSource(tableView: tableView, cellProvider: cellProvider)
    ///
    /// override var dataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
    ///     return customDataSource
    /// }
    /// ```
    ///
    /// - Important: You need to use a lazy var for it to work properly!
    open var dataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
        return _dataSource
    }
    
    
    // MARK: - Public Methods
    
    /// This method applies a new snapshot to the table view.
    ///
    /// This is the equivalent for `reloadData()` or `performBatchUpdates(_:)`
    ///
    /// For a different animation this property needs to be modified:
    ///
    /// ```swift
    /// dataSource.defaultRowAnimation = .automatic
    /// ```
    ///
    /// - Parameters:
    ///   - sections: The sections for the table view.
    ///   - animatingDifferences: A boolean value to deactivate the animation. Default value is `true`.
    ///   - completion: The completion block for when the update is finished. Default value is `nil`.
    open func applySnapshot(_ sections: [FHSection], animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = FHSnapshot()
        
        snapshot.appendSections(sections.map(\.sectionIdentifier))
        sections.forEach { snapshot.appendItems($0.itemIdentifiers, toSection: $0.sectionIdentifier) }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
}
