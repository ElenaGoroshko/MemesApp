//
//  AddMemesCollectionViewController.swift
//  MemesApp
//
//  Created by Elena Goroshko on 12/20/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let gridedDelegate = GriddedContentCollectionVIewDelegate()

class AddMemesCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = gridedDelegate
        self.collectionView!.register(MemeCollectionViewCell.nib, forCellWithReuseIdentifier: MemeCollectionViewCell.reuseID)
        DataManager.instance.getMemes(sender: self)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return DataManager.instance.gottenMemes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.reuseID,
                                                            for: indexPath) as? MemeCollectionViewCell else {fatalError("Error")}
        let meme = DataManager.instance.gottenMemes[indexPath.item]
        
        cell.update(name: meme.name, image: meme.image)
        
        return cell
    }

}
