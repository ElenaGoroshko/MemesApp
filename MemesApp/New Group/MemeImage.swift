//
//  MemeImage.swift
//  MemesApp
//
//  Created by Elena Goroshko on 12/27/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit
//import SwiftyJSON

struct MemeImage {
    let id: String
    let image: UIImage
    
    init (id: String, image: UIImage) {
        self.id = id
        self.image = image
    }
}
