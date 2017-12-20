//
//  Meme.swift
//  MemesApp
//
//  Created by Elena Goroshko on 12/20/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit
struct Meme {
    /*
     "id": "61579",
     "name": "One Does Not Simply",
     "url": "http://i.imgflip.com/1bij.jpg",
     "width": 568,
     "height": 335
 */
    let id: String
    let name: String
    let url: String
    let image: UIImage

    init (id: String, name: String, url: String, image: UIImage) {
        self.id = id
        self.name = name
        self.url = url
        self.image = image
    }
}
