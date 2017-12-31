//
//  MemeCollectionViewCell.swift
//  MemesApp
//
//  Created by Elena Goroshko on 12/20/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: MemeCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: MemeCollectionViewCell.self), bundle: nil)

    @IBOutlet private weak var ibImage: UIImageView!
    @IBOutlet private weak var ibLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func update(name: String, image: UIImage) {
        ibLabel.text = name
        ibImage.image = image
    }
}
