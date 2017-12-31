//
//  MemeDetailsViewController.swift
//  MemesApp
//
//  Created by Elena Goroshko on 12/30/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {
    var meme: Meme?
    
    @IBOutlet private weak var ibImage: UIImageView!
    @IBOutlet private weak var ibLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let meme = meme else { fatalError("Error: Meme doesn't exist") }
        let id = meme.id
        ibLabel.text = meme.name
        self.ibImage.image = DataManager.instance.bufferImages[id]
    }

    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        guard let meme = meme else { fatalError("Error: Meme doesn't exist") }
        DataManager.instance.delFavoriteMeme(meme: meme)
        NotificationCenter.default.post(name: .DelFavoriteMeme, object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
