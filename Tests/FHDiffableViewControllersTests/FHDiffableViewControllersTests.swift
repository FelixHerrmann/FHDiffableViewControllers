import XCTest
@testable import FHDiffableViewControllers

final class TableViewController: FHDiffableTableViewController<Int, String> {
    
    override var cellProvider: UITableViewDiffableDataSource<Int, String>.CellProvider {
        return { tableView, indexPath, string in
            return tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "testCell")
    }
}

final class CollectionViewController: FHDiffableCollectionViewController<Int, String> {
    
    override var cellProvider: UICollectionViewDiffableDataSource<Int, String>.CellProvider {
        return { collectionView, indexPath, string in
            return collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "testCell")
    }
}

final class FHDiffableViewControllersTests: XCTestCase {
    
    func testTableView() {
        let tableViewController = TableViewController()
        tableViewController.applySnapshot([
            .init(sectionIdentifier: 0, itemIdentifiers: ["a", "b"]),
            .init(sectionIdentifier: 1, itemIdentifiers: ["c", "d"])
        ], animatingDifferences: false)
        
        let a = tableViewController.dataSource.itemIdentifier(for: [0, 0])
        let d = tableViewController.dataSource.itemIdentifier(for: [1, 1])
        XCTAssertEqual(a, "a")
        XCTAssertEqual(d, "d")
    }
    
    func testCollectionView() {
        let collectionViewController = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewController.applySnapshot([
            .init(sectionIdentifier: 0, itemIdentifiers: ["a", "b"]),
            .init(sectionIdentifier: 1, itemIdentifiers: ["c", "d"])
        ], animatingDifferences: false)
        
        let a = collectionViewController.dataSource.itemIdentifier(for: [0, 0])
        let d = collectionViewController.dataSource.itemIdentifier(for: [1, 1])
        XCTAssertEqual(a, "a")
        XCTAssertEqual(d, "d")
    }
}
