//
//  AddMemesCollectionViewController.swift
//  MemesApp
//
//  Created by Elena Goroshko on 12/20/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AddMemesCollectionViewController: UICollectionViewController {
    private let gridedDelegate = GriddedContentCollectionVIewDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        gridedDelegate.countItem = 3.0
        collectionView?.delegate = gridedDelegate
        self.collectionView!.register(MemeCollectionViewCell.nib,
                                      forCellWithReuseIdentifier: MemeCollectionViewCell.reuseID)
        DataManager.instance.getMemes(sender: self)
        collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
       
        addObservers()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.instance.gottenMemes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.reuseID,
                                                            for: indexPath) as? MemeCollectionViewCell else {fatalError("Error")}
        let meme = DataManager.instance.gottenMemes[indexPath.item]

        let image: UIImage = DataManager.instance.bufferImages[meme.id] ?? #imageLiteral(resourceName: "placeholder-image")
        if  DataManager.instance.bufferImages[meme.id] == nil {
            DataManager.instance.getImage(indexPath: indexPath, collectionView: collectionView)
        }
        cell.update(name: meme.name, image: image)
        return cell
    }

}

// MARK: - Notification
extension AddMemesCollectionViewController {

    @objc func getMemeImage(_ notification: Notification) {
        guard let indexPath = notification.userInfo?["indexPath"] as? IndexPath
        else {
            debugPrint("Error: Notification doesn't exist indexPath")
            return
        }
        collectionView?.reloadItems(at: [indexPath])
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(getMemeImage(_:)),
                                               name: .GetMemeImage, object: nil)
    }
}
// MARK: - Tap
extension AddMemesCollectionViewController {
    @objc func tap (_ sender: UIGestureRecognizer) {
        let p = sender.location(in: self.collectionView)
        guard let indexPafh = self.collectionView?.indexPathForItem(at: p) else {return}
        let meme = DataManager.instance.gottenMemes[indexPafh.item]
        DataManager.instance.favoriteMemes.append(meme)
        NotificationCenter.default.post(name: .AddFavoriteMeme, object: nil)
        self.navigationController?.popViewController(animated: true)        
    }
}
