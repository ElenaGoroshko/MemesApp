//
//  DataManager.swift
//  MemesApp
//
//  Created by Elena Goroshko on 12/20/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PKHUD

class DataManager {
    static let instance = DataManager()

    let getURL = "https://api.imgflip.com/get_memes"
    var gottenMemes: [Meme] = []
    var favoriteMemes: [Meme] = []
    
    private init() {
        
    }
    func getMemes(sender: UICollectionViewController) {
        HUD.show(.progress)
        Alamofire.request(getURL).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let jsonObj = JSON(value)
                let jsonData = jsonObj["data"]
                let jsonMemes = jsonData["memes"]
                guard let jsonArr = jsonMemes.array else { return }
                for jsonObject in jsonArr {
                    guard var meme = Meme(json: jsonObject) else { continue }
                    self?.gottenMemes.append(meme)
                }
                HUD.hide()
                sender.collectionView?.reloadData()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    func getImage(index: Int, collectionView: UICollectionView) {
        var meme = self.gottenMemes[index]
        guard let url = URL(string: meme.url) else {return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: imageData)!
            DispatchQueue.main.async { [unowned self, index] in
                meme.setImage(image: image)
                debugPrint(meme)
                self.gottenMemes[index] = meme
            }
        }
    }
}
