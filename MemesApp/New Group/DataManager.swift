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
import KeychainSwift

class DataManager {
    static let instance = DataManager()

    let getURL = "https://api.imgflip.com/get_memes"
    var gottenMemes: [Meme] = []
    var favoriteMemes: [Meme] = []
    var bufferImages: [String: UIImage] = [:]
    var keyChain = KeychainSwift()
    
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
                    guard let meme = Meme(json: jsonObject) else { continue }
                    self?.gottenMemes.append(meme)
                }
                HUD.hide()
                sender.collectionView?.reloadData()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    func getImage(indexPath: IndexPath, collectionView: UICollectionView) {
        let meme = self.gottenMemes[indexPath.item]
        Alamofire.request(meme.url).responseData { response in
            guard let data = response.data else { return }            
            guard let image = UIImage(data: data) else { return }
            let memeImage = MemeImage(id: meme.id, image: image)
            self.bufferImages[meme.id] = memeImage.image
            //notification
            NotificationCenter.default.post(name: .GetMemeImage, object: nil,
                                            userInfo: ["indexPath": indexPath] )
        }
    }
    func delFavoriteMeme (meme: Meme) {
        for (index, memeTmp) in self.favoriteMemes.enumerated() where meme.id == memeTmp.id {
                self.favoriteMemes.remove(at: index)
                return
        }
    }
}
