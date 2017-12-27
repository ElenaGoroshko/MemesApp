//
//  GriddedContentCollectionVIewDelegate.swift
//  MemesApp
//
//  Created by Elena Goroshko on 12/20/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

class GriddedContentCollectionVIewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
// MARK: UICollectionViewDelegate
    let minimumItemSpacing: CGFloat = 3
    var sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    var countItem: CGFloat = 2.0

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        if collectionView.dataSource as MemesCollectionViewController {
//            countItem = 2.0
//        } else {
//            countItem = 3.0
//        }
        let paddingSpase = sectionInsets.left + sectionInsets.right + (minimumItemSpacing * (countItem - 1))
        let widthItem = (collectionView.bounds.width - paddingSpase) / countItem
        return CGSize(width: widthItem, height: widthItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

}
