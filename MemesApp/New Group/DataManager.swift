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
    var email: String = ""

    private var keyChain = KeychainSwift()
    private var fileManager = FileManager.default

    private var directoryUrl: URL {
        guard let path = FileManager.default.urls(for: .documentDirectory,
                                                  in: .userDomainMask).first else {
            fatalError("Something strange")
        }
        return path
    }
    private var directoryUrlImages: URL {
        guard let path = FileManager.default.urls(for: .documentDirectory,
                                                  in: .userDomainMask).first,
              let email = getEmailWithoutChar()
        else {
            fatalError("Something strange")
        }
        return path.appendingPathComponent(email)
    }

    private func pathInImage(withComponent component: String) -> URL {

        if fileManager.directoryExists(atPath: directoryUrlImages.path) {
            return directoryUrlImages.appendingPathComponent(component)
        } else {
            fatalError("Something strange")
        }
    }

    private func pathInDocument(withComponent component: String) -> URL {
        return directoryUrl.appendingPathComponent(component)
    }

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

    func setEmail (email: String) {
        keyChain.set(email, forKey: "user")

      //  let path = String( describing: pathInDocument(withComponent: email))
       // debugPrint(path, " ", fileManager.fileExists(atPath: path))
        if fileManager.fileExists(atPath: pathInDocument(withComponent: email).path) {
            loadMemes()
            if !fileManager.directoryExists(atPath: directoryUrlImages.path) {
                createDirEmaile()
            }
            loadImages()
        }

    }
//    func getEmail () -> String? {
//        return keyChain.get("user")
//    }
    func getEmailWithoutChar()  -> String? {
        guard var str = keyChain.get("user") else {return nil}
        var i = str.startIndex
        (str, i) = parsing(sourse: str, separator: "@", startIndex: i, stopIndex: str.endIndex)
        return str
    }
    func clearEmail () {
        keyChain.clear()
        self.favoriteMemes.removeAll()
    }

    func saveMemes() {
        guard let name = getEmailWithoutChar() else {return}
        let fileUrl = pathInDocument(withComponent: name)
        debugPrint(fileUrl)
        var str = ""
        for meme in favoriteMemes {
            str += "\(meme.id)|\(meme.name)|\(meme.url)|"
        }
        do {
            try str.write(to: fileUrl, atomically: true, encoding: .utf8)
        } catch {
            debugPrint("Error: File don't be write.")
        }
      //  debugPrint(str)
    }
    
    func loadMemes() {
        favoriteMemes = []
        guard let nameFile = getEmailWithoutChar() else {return}
        let fileUrl = pathInDocument(withComponent: nameFile)
        debugPrint(fileUrl)
        
        var str = ""
        
        do {
            try str = String(contentsOf: fileUrl, encoding: .utf8)
        } catch {
            debugPrint("Error: File don't be read.")
        }
       // debugPrint(str)
        var id = ""
        var name = ""
        var url = ""
        
        var j = str.startIndex
        var i = str.startIndex
        while i < str.endIndex {
            (id, j) = parsing(sourse: str, separator: "|", startIndex: j, stopIndex: str.endIndex)
            (name, j) = parsing(sourse: str, separator: "|", startIndex: j, stopIndex: str.endIndex)
            (url, j) = parsing(sourse: str, separator: "|", startIndex: j, stopIndex: str.endIndex)
            
            let meme = Meme(id: id, name: name, url: url)
            favoriteMemes.append(meme)
            
            id = ""
            name = ""
            url = ""
            i = j
        }
        NotificationCenter.default.post(name: .AddFavoriteMeme, object: nil)
    }
    func parsing(sourse: String, separator: Character, startIndex: String.Index,
                 stopIndex: String.Index) -> (String, String.Index) {
        var i = startIndex
        var str = ""
        while i < stopIndex, sourse[i] != separator {
            if sourse[i] != separator {
                str.append(sourse[i])
            }
           i = sourse.index(after: i)
        }
        return (str, sourse.index(after: i))
    }
    func createDirEmaile() {
        guard let eMail = getEmailWithoutChar() else { return }
        let url = directoryUrl.appendingPathComponent(eMail)
        if fileManager.directoryExists(atPath: String(describing: url)) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: false)
            } catch {
                debugPrint("Error: Can't create directory")
            }
        }
    }

     func saveImages() {
        if fileManager.directoryExists(atPath: directoryUrlImages.path) {
            createDirEmaile()
        }
        for meme in favoriteMemes {
            let imageUrl = pathInImage(withComponent: meme.id)
            guard let image = bufferImages[meme.id] else {
                debugPrint("Error: The image don't exist")
                return
            }
            let imageData = UIImagePNGRepresentation(image)
            if !fileManager.createFile(atPath: imageUrl.path, contents: imageData) {
                debugPrint(imageUrl.path)
                debugPrint("Error: The fileImage doesn't created")
            }
        }
    }
     func loadImages() {
        if fileManager.directoryExists(atPath: directoryUrlImages.path) {
            for meme in favoriteMemes {
                let imageUrl = pathInImage(withComponent: meme.id)
                if fileManager.fileExists(atPath: imageUrl.path) {
                    bufferImages[meme.id] = UIImage(contentsOfFile: imageUrl.path)
                } else {
                    debugPrint("Error: The fileImage doesn't exists")
                    debugPrint(meme.id + " " + imageUrl.path)
                }
            }
            NotificationCenter.default.post(name: .LoadImage, object: nil)
        } else {
            
            debugPrint("Error: The didImage doesn't exists")
        }
    }
}
