//
//  CollectionViewController.swift
//  FHDiffableViewControllers
//
//  Created by Felix Herrmann on 02.01.22.
//

import UIKit
import FHDiffableViewControllers

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
