//
//  TableViewController.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 02.01.22.
//

import UIKit
import FHDiffableViewControllers

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
