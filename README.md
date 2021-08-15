# FHDiffableViewControllers

<p align="left">
<a href="https://github.com/FelixHerrmann/FHDiffableViewControllers/releases"><img alt="GitHub version" src="https://img.shields.io/github/v/release/FelixHerrmann/FHDiffableViewControllers"></a>
<a href="https://github.com/FelixHerrmann/FHDiffableViewControllers/blob/master/LICENSE"><img alt="GitHub license" src="https://img.shields.io/github/license/FelixHerrmann/FHDiffableViewControllers"></a>
<a href="https://twitter.com/intent/tweet?text=Wow:&url=https%3A%2F%2Fgithub.com%2FFelixHerrmann%2FFHDiffableViewControllers"><img alt="Twitter" src="https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2FFelixHerrmann%2FFHDiffableViewControllers"></a>
</p>

UITableViewController and UICollectionViewController based on a DiffableDataSource.


## Requirements
- macOS 10.15+ (Catalyst)
- iOS 13.0+
- tvOS 13.0+


## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

Add the following to the dependencies of your `Package.swift`:

```swift
.package(url: "https://github.com/FelixHerrmann/FHDiffableViewControllers.git", from: "x.x.x")
```

### Manual

Download the files in the [Sources](https://github.com/FelixHerrmann/FHDiffableViewControllers/tree/master/Sources) folder and drag them into you project.


## Usage

If you are using Swift Package Manager, you have to import FHDiffableViewControllers to your file with `import FHDiffableViewControllers`. You can also import it globally with `@_exported import FHDiffableViewControllers`. (e.g. in `AppDelegate.swift`)

Now you can inherit your view controller class from `FHDiffableTableViewController` and `FHDiffableCollectionViewController`. 

<br>

But first we need a `SectionIdentifier` and `ItemIdentifier` which will be used for the generic types. Both types have to conform to `Hashable`.

```swift
enum Section {
    case main, detail
}

struct Item: Hashable {
    var title: String
}
```
> It is recommend to conform the item to `Identifiable` because the app crashes if there are duplicates in the data source!

<br>

These classes can be subclassed like that:

```swift
class ViewController: FHDiffableTableViewController<Section, Item> {
    
    override var cellProvider: UITableViewDiffableDataSource<Section, Item>.CellProvider {
        return { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell?.textLabel?.text = item.title
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        applySnapshot([
            FHSection(
                sectionIdentifier: .main,
                itemIdentifiers: [
                    Item(title: "First Item"),
                    Item(title: "Second Item")
                ]
            ),
            FHSection(
                sectionIdentifier: .detail,
                itemIdentifiers: [
                    Item(title: "Third Item")
                ]
            )
        ], animatingDifferences: false)
    }
}
```

> The cellProvider must be overwritten because the default implementation raises a fatal error.
> Do not forget to register the cell before you call `applySnapshot(_:)` the first time!

<br>

The cell selection can be implemented like that:

```swift
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = dataSource.itemIdentifier(for: indexPath)
    /*do your actions with the selected item*/
}
```

### Customize Header and Footer Views (collection view only)

In order to use custom header or footer views, the `supplementaryViewProvider` property must be overwritten.

```swift 
override var supplementaryViewProvider: UICollectionViewDiffableDataSource<Section, Item>.SupplementaryViewProvider? {
    return { collectionView, kind, indexPath in
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "customHeader", for: indexPath) as? CustomHeader
        switch self.dataSource.snapshot().sectionIdentifiers[indexPath.section] {
        case .main:
            headerView?.backgroundColor = .systemGreen
        case .detail:
            headerView?.backgroundColor = .systemPink
        }
        return headerView
    }
}
```

Do not forget to register the supplementary view before you call `applySnapshot(_:)` the first time!

```swift
collectionView.register(CustomHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "customHeader")
```

### Custom Data Source

In case you want to change the behavior of the title creation or you want to use section index titles and other features you have to subclass the appropriate data source. For the table view it could look something like that:

```swift
class CustomDataSource: UITableViewDiffableDataSource<Section, Item> {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch snapshot().sectionIdentifiers[section] {
        case .main:
            return "Main"
        case .detail:
            return "Detail"
        }
    }
}
```

> Use `UICollectionViewDiffableDataSource` for collection view.

So that it can be used in our view controller we have to create a lazy var of this and override the `dataSource` property with it.

```swift
lazy var customDataSource = CustomDataSource(tableView: tableView, cellProvider: cellProvider)

override var dataSource: UITableViewDiffableDataSource<Section, Item> {
    return customDataSource
}
```

### Custom `applySnapshot(_:)`

You are not forced to use `applySnapshot(_:)` in combination with `FHDiffableDataSourceSection` array to apply snapshots to your `dataSource`. You can override the `applySnapshot(_:)` to change its behavior, create your own `applySnapshot()` method or do it manually as follows:

```swift
var snapshot = FHSnapshot()
snapshot.appendSections([.main, .detail])
snapshot.appendItems([Item(title: "Main Item")], toSection: .main)
snapshot.appendItems([Item(title: "Detail Item")], toSection: .detail)
dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
```


## License

FHConstraints is available under the MIT license. See the [LICENSE](https://github.com/FelixHerrmann/FHDiffableViewControllers/blob/master/LICENSE) file for more info.
