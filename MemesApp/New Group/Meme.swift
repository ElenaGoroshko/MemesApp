//
//  Meme.swift
//  MemesApp
//
//  Created by Elena Goroshko on 12/20/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit
import SwiftyJSON
struct  Meme {

    let id: String
    let name: String
    let url: String

    init (id: String, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
    init? (json: JSON) {
        guard let id = json["id"].string,
            let name = json["name"].string,
            let urlStr = json["url"].string else { return nil }
        
        self.id = id
        self.name = name
        self.url = urlStr
    }

}
