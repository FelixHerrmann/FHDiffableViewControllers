#if !os(macOS)

import UIKit
import FHExtensions

/// A subclass of **UITableViewController** with diffable data source.
public class FHDiffableTableViewController<SectionIdentifierType, ItemIdentifierType>: UITableViewController where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    // MARK: - Public Classes
    
    /// A subclass of **UITableViewDiffableDataSource**, where the section title will be displayed if the snapshot contains more then one section.
    public class FHDataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>  {
        public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let sectionIdentifiers = snapshot().sectionIdentifiers
            guard let sectionIdenifier = sectionIdentifiers[safe: section], sectionIdentifiers.count > 1 else {
                return nil
            }
            return "\(sectionIdenifier)"
        }
    }
    
    
    // MARK: - Typealias
    
    /// A typealias for an **NSDiffableDataSourceSnapshot** type.
    public typealias FHSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for an **FHDiffableDataSourceSnapshotSection** array type.
    public typealias FHSnapshotData = [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>]
    
    
    // MARK: - Private Properties
    
    private var _cellProvicer: ((UITableView, IndexPath, ItemIdentifierType) -> UITableViewCell?) = { (tableView, indexPath, itemIdentifier) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        cell.textLabel?.text = "\(itemIdentifier)"
        return cell
    }
    
    private lazy var _dataSource: FHDataSource = FHDataSource(tableView: tableView, cellProvider: cellProvider)
    
    
    // MARK: - Public Properties
    
    /// The data source for the table view.
    ///
    /// Override this property only if you want to apply your custom **UITableViewDiffableDataSource**. For cell configuration overried the `cellProvider` property.
    ///
    ///     lazy var customDataSource = CustomDataSource(tableView: tableView, cellProvider: cellProvider)
    ///
    ///     override var dataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
    ///         return customDataSource
    ///     }
    ///
    /// - important: You need to use a lazy var for it to work properly!
    public var dataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
        return _dataSource
    }
    
    /// The cell provider which creates the cells.
    ///
    /// Override this property to configure your custom cell the way you want.
    ///
    /// The default implementation just shows the description in the textLabel.
    ///
    ///     override var cellProvider: ((UITableView, IndexPath, ItemIdentifierType) -> UITableViewCell?) {
    ///         return { (tableView, indexPath, itemIdentifier) in
    ///             let cell = tableView.dequeueReusableCell(withIdentifier: /*your identifier*/, for: indexPath) as? CustomCell
    ///             cell?.textLabel?.text = itemIdentifier.text
    ///             /*customize your cell here*/
    ///             return cell
    ///         }
    ///     }
    ///
    /// - important: Do not forget to register the reuseable cell before the first snapshot is applied!
    ///
    ///       tableView.register(CustomCell.self, forCellReuseIdentifier: /*your identifier*/) // e.g. in viewDidLoad()
    public var cellProvider: ((UITableView, IndexPath, ItemIdentifierType) -> UITableViewCell?) {
        return _cellProvicer
    }
    
    
    // MARK: - Public Methods
    
    /// This method applys a new snapshot to the table view.
    ///
    /// This is the equivalent for `reloadData()` or `performBatchUpdates(_:)`
    ///
    /// With the `animatingDifferences`parameter you can disable the updating animation. If you want to have a different one you have to change this property:
    ///
    ///     dataSource.defaultRowAnimation = .automatic
    ///
    /// If you do not want to use **FHSnapshotData** you can write your own `applySnapshot()` method like that:
    ///
    ///     func applySnapshot() {
    ///         var snapshot = FHSnapshot()
    ///         snapshot.appendSections([/*your sections*/])
    ///         snapshot.appendItems([/*your items*/], toSection: /*your section*/) // do that for every section
    ///         dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    ///     }
    ///
    /// - Parameters:
    ///   - snapshotData: The data snapshot for the table view.
    ///   - animatingDifferences: A boolean value to deactive the animation. Default value is `true`.
    ///   - completion: The completion block for when the update is finished. Default value is `nil`.
    public func applySnapshot(_ snapshotData: FHSnapshotData, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = FHSnapshot()
        
        snapshot.appendSections(snapshotData.map({ $0.sectionIdentifier }))
        snapshotData.forEach { (section) in
            snapshot.appendItems(section.itemIdentifiers, toSection: section.sectionIdentifier)
        }
        dataSource.defaultRowAnimation = .automatic
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    
    // MARK: - Overrides
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
    }
}

#endif
