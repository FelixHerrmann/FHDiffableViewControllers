//
//  FHDiffableTableViewController.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 09.06.20.
//

import UIKit

/// A subclass of `UITableViewController` with diffable data source.
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
/// class TableViewController: FHDiffableTableViewController<Section, Item> {
///
///     override var cellProvider: UITableViewDiffableDataSource<Section, Item>.CellProvider {
///         return { tableView, indexPath, item in
///             let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
///             cell.textLabel?.text = item.title
///             return cell
///         }
///     }
///
///     override func viewDidLoad() {
///         super.viewDidLoad()
///
///         tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
open class FHDiffableTableViewController<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: UITableViewController {
    
    
    // MARK: - Typealias
    
    /// A typealias for `UITableViewDiffableDataSource` with the identifier types.
    public typealias FHDataSource = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for `NSDiffableDataSourceSnapshot` with the identifier types.
    public typealias FHSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for ``FHDiffableDataSourceSnapshotSection`` with the identifier types.
    public typealias FHSection = FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for ``FHDiffableDataSourceSnapshotSectionBuilder`` with the identifier types.
    public typealias FHSectionBuilder = FHDiffableDataSourceSnapshotSectionBuilder<SectionIdentifierType, ItemIdentifierType>
    
    
    // MARK: - Private Properties
    
    private lazy var _dataSource: FHDataSource = FHDataSource(tableView: tableView, cellProvider: cellProvider)
    
    
    // MARK: - Public Properties
    
    /// The cell provider which creates the cells.
    ///
    /// Override this property to configure a custom cell.
    ///
    /// There is no default implementation for this property.
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
    /// Override this property only if a custom `UITableViewDiffableDataSource` should be applied.
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
    /// This is the equivalent for `reloadData()` or `performBatchUpdates(_:)`.
    /// There is also ``applySnapshot(animatingDifferences:sectionBuilder:completion:)`` with a result builder.
    ///
    /// - Note: For a different animation modify the `defaultRowAnimation` property on ``dataSource``.
    /// - Important: All sections and all items per section must be unique.
    ///
    /// - Parameters:
    ///   - sections: The sections to generate a snapshot for the ``dataSource``.
    ///   - animatingDifferences: If `true`, the system animates the updates to the table view. If `false`, the system doesn’t animate the updates to the table view.
    ///   - completion: An optional closure to execute when the animations are complete. The system calls this closure from the main queue.
    open func applySnapshot(_ sections: [FHSection], animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = FHSnapshot()
        
        snapshot.appendSections(sections.map(\.sectionIdentifier))
        sections.forEach { snapshot.appendItems($0.itemIdentifiers, toSection: $0.sectionIdentifier) }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    /// This method applies a new snapshot build from a result builder to the table view.
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
    /// - Note: For a different animation modify the `defaultRowAnimation` property on ``dataSource``.
    /// - Important: All sections and all items per section must be unique.
    ///
    /// - Parameters:
    ///   - animatingDifferences: If `true`, the system animates the updates to the table view. If `false`, the system doesn’t animate the updates to the table view.
    ///   - sectionBuilder: The section builder to generate a snapshot for the ``dataSource``.
    ///   - completion: An optional closure to execute when the animations are complete. The system calls this closure from the main queue.
    open func applySnapshot(animatingDifferences: Bool = true, @FHSectionBuilder sectionBuilder: () throws -> [FHSection], completion: (() -> Void)? = nil) rethrows {
        applySnapshot(try sectionBuilder(), animatingDifferences: animatingDifferences, completion: completion)
    }
}
