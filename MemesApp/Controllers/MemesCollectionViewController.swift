//
//  MemesCollectionViewController.swift
//  MemesApp
//
//  Created by Elena Goroshko on 12/20/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit
import KeychainSwift

private let reuseIdentifier = "Cell"

class MemesCollectionViewController: UICollectionViewController {
    private let gridedDelegate = GriddedContentCollectionVIewDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        gridedDelegate.countItem = 2.0
        navigationItem.hidesBackButton = true
        collectionView?.delegate = gridedDelegate
        self.collectionView!.register(MemeCollectionViewCell.nib,
                                      forCellWithReuseIdentifier: MemeCollectionViewCell.reuseID)
        collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        addObservers()
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "AddMemes") as? AddMemesCollectionViewController else {return}
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        DataManager.instance.clearEmail()
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return DataManager.instance.favoriteMemes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.reuseID,
                                                            for: indexPath) as? MemeCollectionViewCell else {fatalError("Error")}
        let meme = DataManager.instance.favoriteMemes[indexPath.item]
        let image = DataManager.instance.bufferImages[meme.id] ?? #imageLiteral(resourceName: "placeholder-image")
        cell.update(name: meme.name, image: image )
   
        return cell
    }

}

// MARK: - Notification
extension MemesCollectionViewController {
    func addObservers () {
        NotificationCenter.default.addObserver(self, selector: #selector(addFavoriteMeme(_:)),
                                               name: .AddFavoriteMeme, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(delFavoriteMeme(_:)),
                                               name: .DelFavoriteMeme, object: nil)
    }

    @objc func addFavoriteMeme (_ notification: Notification) {
       // debugPrint(DataManager.instance.favoriteMemes)
        gridedDelegate.countItem = 2.0
        DataManager.instance.saveMemes()
        self.collectionView?.reloadData()
    }

    @objc func delFavoriteMeme (_ notification: Notification) {
        gridedDelegate.countItem = 2.0
        DataManager.instance.saveMemes()
        self.collectionView?.reloadData()
    }
}
// MARK: - GestureRecognizer
extension MemesCollectionViewController {
    @objc func tap (_ sender: UIGestureRecognizer) {
        let p = sender.location(in: self.collectionView)
        guard let indexPafh = self.collectionView?.indexPathForItem(at: p) else {return}
        let meme = DataManager.instance.favoriteMemes[indexPafh.item]
        
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetails") as? MemeDetailsViewController else {return}
        destVC.meme = meme
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
