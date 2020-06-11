import UIKit

/// A subclass of **UICollectionViewController** with diffable data source.
open class FHDiffableCollectionViewController<SectionIdentifierType, ItemIdentifierType>: UICollectionViewController where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    // MARK: - Enums
    
    /// The type of layout you want to initialize your collection view with.
    public enum LayoutType {
        
        /// Creates  a default **UICollectionViewCompositionalLayout**. This is intended to be used for test purposes.
        case `default`
        
        /// Use a **UICollectionViewFlowLayout**.
        case flow(UICollectionViewFlowLayout)
        
        /// Use a **UICollectionViewCompositionalLayout**.
        case compositional(UICollectionViewCompositionalLayout)
        
        /// Use your custom **UICollectionViewLayout**.
        case custom(UICollectionViewLayout)
        
    }
    
    
    // MARK: - Typealias
    
    /// A typealias for **UICollectionViewDiffableDataSource** type.
    public typealias FHDataSource = UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for **NSDiffableDataSourceSnapshot** type.
    public typealias FHSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
    
    /// A typealias for **FHDiffableDataSourceSnapshotSection** array type.
    public typealias FHSnapshotData = [FHDiffableDataSourceSnapshotSection<SectionIdentifierType, ItemIdentifierType>]
    
    
    // MARK: - Initializers
    
    /// Initializes a **FHDiffableCollectionViewController** and configures the collection view with the provided layout.
    ///
    /// - Parameters:
    ///     - layoutType: The type of layout the collection view should use.
    ///
    /// - Returns: An initialized **FHDiffableCollectionViewController** object.
    public init(layout layoutType: LayoutType = .default) {
        switch layoutType {
        case .default:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(0)), subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            let section = NSCollectionLayoutSection(group: group)
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(32)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            headerItem.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [headerItem]
            let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
            super.init(collectionViewLayout: compositionalLayout)
        case .flow(let flowLayout):
            super.init(collectionViewLayout: flowLayout)
        case .compositional(let compositionalLayout):
            super.init(collectionViewLayout: compositionalLayout)
        case .custom(let layout):
            super.init(collectionViewLayout: layout)
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Private Properties
    
    private var _cellProvider: FHDataSource.CellProvider = { (collectionView, indexPath, itemIdentifier) in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
        cell.backgroundColor = .systemTeal
        cell.layer.cornerRadius = 8
        return cell
    }
    
    private var _supplementaryViewProvider: FHDataSource.SupplementaryViewProvider = { (collectionView, kind, indexPath) in
        let reuseableHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "defaultHeader", for: indexPath)
        reuseableHeaderView.backgroundColor = .systemIndigo
        return reuseableHeaderView
    }
    
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
    /// The default implementation just shows an empty cell.
    ///
    ///     override var cellProvider: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider {
    ///         return { (collectionView, indexPath, itemIdentifier) in
    ///             let cell = collectionView.dequeueReusableCell(withIdentifier: /*your identifier*/, for: indexPath) as? CustomCell
    ///             /*customize your cell here*/
    ///             return cell
    ///         }
    ///     }
    ///
    /// - important: Do not forget to register the reuseable cell before the first snapshot is applied!
    ///
    ///       collectionView.register(CustomCell.self, forCellReuseIdentifier: /*your identifier*/) // e.g. in viewDidLoad()
    open var cellProvider: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider {
        return _cellProvider
    }
    
    /// The supplementary view provider which creates the supplementary views.
    ///
    /// Override this property to configure a custom supplementary view.
    ///
    /// The default implementation just shows an empty section header.
    ///
    ///     override var supplementaryViewProvider: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.SupplementaryViewProvider {
    ///         return { (collectionView, kind, indexPath) in
    ///             let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: /*your identifier*/, for: indexPath) as? CustomReuseableView
    ///             /*customize your supplementary view here*/
    ///             return supplementaryView
    ///         }
    ///     }
    ///
    /// - important: Do not forget to register the reuseable view before the first snapshot is applied!
    ///
    ///       collectionView.register(CustomReuseableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: /*your identifier*/) // e.g. in viewDidLoad()
    open var supplementaryViewProvider: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.SupplementaryViewProvider {
        return _supplementaryViewProvider
    }
    
    /// The data source for the collection view.
    ///
    /// Override this property only if a custom **UICollectionViewDiffableDataSource** should be applied.
    /// For cell configuration overried the `cellProvider` property.
    /// For supplementary view configuration override the `supplementaryViewProvider` property.
    ///
    ///     lazy var customDataSource: CustomDataSource = {
    ///         let dataSource = CustomDataSource(collectionView: collectionView, cellProvider: cellProvider)
    ///         dataSource.supplementaryViewProvider = supplementaryViewProvider
    ///         return dataSource
    ///     }()
    ///
    ///     override var dataSource: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
    ///         return customDataSource
    ///     }
    ///
    /// - important: You need to use a lazy var for it to work properly!
    open var dataSource: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
        return _dataSource
    }
    
    
    // MARK: - Public Methods
    
    /// This method applys a new snapshot to the collection view.
    ///
    /// This is the equivalent for `reloadData()` or `performBatchUpdates(_:)`
    ///
    /// With the `animatingDifferences`parameter the update animation can be disabled.
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
    ///   - snapshotData: The data snapshot for the collection view.
    ///   - animatingDifferences: A boolean value to deactive the animation. Default value is `true`.
    ///   - completion: The completion block for when the update is finished. Default value is `nil`.
    open func applySnapshot(_ snapshotData: FHSnapshotData, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = FHSnapshot()
        
        snapshot.appendSections(snapshotData.map({ $0.sectionIdentifier }))
        snapshotData.forEach { (section) in
            snapshot.appendItems(section.itemIdentifiers, toSection: section.sectionIdentifier)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    
    // MARK: - Overrides
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "defaultCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "defaultHeader")
    }
}
