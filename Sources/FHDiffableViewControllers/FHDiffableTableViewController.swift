import UIKit
import FHExtensions

/// A subclass of **UITableViewController** with diffable data source.
open class FHDiffableTableViewController<SectionIdentifierType, ItemIdentifierType>: UITableViewController where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    
    // MARK: - Classes
    
    /// A subclass of **UITableViewDiffableDataSource**, where the section title will be displayed if the snapshot contains more then one section.
    open class FHDataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>  {
        
        open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let sectionIdentifiers = snapshot().sectionIdentifiers
            guard let sectionIdenifier = sectionIdentifiers[safe: section], sectionIdentifiers.count > 1 else {
                return nil
            }
            return "\(sectionIdenifier)"
        }
    }
    
    
    // MARK: - Typealias
    
    /// A typealias for **NSDiffableDataSourceSnapshot** with the identifier types.
    public typealias FHSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for **FHDiffableDataSourceSnapshotSection** with the identifier types.
    public typealias FHSection = FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>
    
    
    // MARK: - Private Properties
    
    private var _cellProvicer: FHDataSource.CellProvider = { (tableView, indexPath, itemIdentifier) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        cell.textLabel?.text = "\(itemIdentifier)"
        return cell
    }
    
    private lazy var _dataSource: FHDataSource = FHDataSource(tableView: tableView, cellProvider: cellProvider)
    
    
    // MARK: - Public Properties
    
    /// The cell provider which creates the cells.
    ///
    /// Override this property to configure a custom cell.
    ///
    /// The default implementation just shows the description in the `textLabel`.
    ///
    /// ```swift
    /// override var cellProvider: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider {
    ///     return { (tableView, indexPath, itemIdentifier) in
    ///         let cell = tableView.dequeueReusableCell(withIdentifier: /*your identifier*/, for: indexPath) as? CustomCell
    ///         /*customize your cell here*/
    ///         return cell
    ///     }
    /// }
    /// ```
    ///
    /// - Important: Do not forget to register the reuseable cell before the first snapshot is applied!
    ///
    ///       tableView.register(CustomCell.self, forCellReuseIdentifier: /*your identifier*/) // e.g. in viewDidLoad()
    open var cellProvider: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider {
        return _cellProvicer
    }
    
    /// The data source for the table view.
    ///
    /// Override this property only if a custom **UITableViewDiffableDataSource** should be applied.
    /// For cell configuration overried the ``cellProvider`` property.
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
    
    /// This method applys a new snapshot to the table view.
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
        sections.forEach { (section) in
            snapshot.appendItems(section.itemIdentifiers, toSection: section.sectionIdentifier)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    
    // MARK: - Overrides
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
    }
}
