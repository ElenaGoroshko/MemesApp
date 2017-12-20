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

class DataManager {
    static let instance = DataManager()

    let getURL = "https://api.imgflip.com/get_memes"
    var gottenMemes: [Meme] = []
    var favoriteMemes: [Meme] = []
    
    private init() {
        
    }
    func getMemes(sender: UICollectionViewController) {
        Alamofire.request(getURL).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let jsonObj = JSON(value)
                let jsonData = jsonObj["data"]
                let jsonMemes = jsonData["memes"]
                guard let jsonArr = jsonMemes.array else { return }
                for jsonObject in jsonArr {
                    guard let id = jsonObject["id"].string,
                        let name = jsonObject["name"].string,
                        let urlStr = jsonObject["url"].string else { return }
                    guard let url = URL(string: urlStr) else {return }
                    DispatchQueue.global().async {
                        guard let imageData = try? Data(contentsOf: url) else { return }
                        let image = UIImage(data: imageData)!
                        DispatchQueue.main.async { [weak self] in
                            let meme = Meme(id: id, name: name, url: urlStr, image: image)
                            debugPrint(meme)
                            self?.gottenMemes.append(meme)
                            sender.collectionView?.reloadData()
                        }
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
     //       guard let sender = sender as? AddMemesCollectionViewController else { return }
     //       sender.collectionView?.reloadData()
        }
    }
//    func getImage (urlStr: String) -> UIImage? {
//        var imageData: UIImage = UIImage()
//        guard let url = URL(string: urlStr) else {return nil}
//        DispatchQueue.global().async {
//            guard let imageDataTmp = try? Data(contentsOf: url) else { return }
//            imageData = UIImage(data: imageDataTmp)!
//            DispatchQueue.main.async {
//                return imageData
//            }
//        }
////        debugPrint("Error getting image")
//        return imageData
//    }
//    private func loadImage(imageView: UIImageView, imageArray: [String],
//                           indexImage: Int, indicator: UIActivityIndicatorView ) {
//        imageView.image = nil
//        guard indexImage >= 0, indexImage < imageArray.count else { return }
//        let imageStringUrl = imageArray[indexImage]
//        guard let url = URL(string: imageStringUrl) else { return }
//        indicatorStart(indicator: indicator)
//
//        DispatchQueue.global().async { [weak self] in
//            guard let imageData = try? Data(contentsOf: url) else {
//                self?.indicatorStop(indicator: indicator)
//                return
//            }
//            let loadedImage = UIImage(data: imageData)
//            DispatchQueue.main.async { [weak self] in
//                imageView.image = loadedImage
//                self?.indicatorStop(indicator: indicator)
//            }
//        }
//    }

}
