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
        keyChain.set(email, forKey: "user")//sdwebimage
    }
    func getEmail () -> String? {
        return keyChain.get("user")
    }
    func clearEmail () {
        keyChain.clear()
        self.favoriteMemes.removeAll()
    }
    func saveMemes(withName name: String) {
        let fileUrl = pathInDocument(withComponent: name)
      //  debugPrint(fileUrl)
        var str = ""
        for (i, meme) in favoriteMemes.enumerated() {
            str += "\(meme.id)|\(meme.name)|\(meme.url)|"
        }
        do {
            try str.write(to: fileUrl, atomically: true, encoding: .utf8)
        } catch {
            debugPrint("error")
        }
        debugPrint(str)
    }
    
    func loadMemes(withName name: String) {
        favoriteMemes = []
        let fileUrl = pathInDocument(withComponent: name)
        debugPrint(fileUrl)
        
        var str = ""
        
        do {
            try str = String(contentsOf: fileUrl, encoding: .utf8)
        } catch {
            debugPrint("error")
        }
        debugPrint(str)
        var id = ""
        var name = ""
        var url = ""
        
        var j = str.startIndex
        var i = str.startIndex
        while i < str.endIndex {
            j = i
            while j < str.endIndex {
                if str[j] != "|" {
                    id.append(str[j])
                    j = str.index(after: j)
                } else {
                    break
                }
                
            }
            j = str.index(after: j)
            while j < str.endIndex {
                if str[j] != "|" {
                    name.append(str[j])
                    j = str.index(after: j)
                } else {
                    break
                }
                
            }
            j = str.index(after: j)
            while j < str.endIndex {
                if str[j] != "|" {
                    url.append(str[j])
                    j = str.index(after: j)
                } else {
                    break
                }
            }
            j = str.index(after: j)
            let meme = Meme(id: id, name: name, url: url)
            debugPrint(meme)
            favoriteMemes.append(meme)
            id = ""
            name = ""
            url = ""
            i = j
        }
        NotificationCenter.default.post(name: .AddFavoriteMeme, object: nil)
    }
}
/*
 @IBAction private func savePressed(_ sender: Any) {
    hideKeyboard()
    guard let filename = filenameInputField.text, !filename.isEmpty else {
        showErrorAlert(withMessage: "You should provide filename")
        return
    }
    let content = contentInputField.text ?? ""
    createFile(withName: filename, content: content)
    showAlert(title: "File saved", message: "")
 }
 
 @IBAction private func loadPressed(_ sender: Any) {
    hideKeyboard()
    guard let filename = filenameInputField.text, !filename.isEmpty else {
        showErrorAlert(withMessage: "Can't load without name")
        return
    }
    loadFile(withName: filename)
    showAlert(title: "File loaded", message: "")
 }
 private func createFile(withName name: String, content: String) {
    let fileUrl = Utils.pathInDocument(withComponent: name)
    do {
        try content.write(to: fileUrl, atomically: true, encoding: .utf8)
    } catch {
        debugPrint("Error writing to file!")
    }
 }
 
 private func loadFile(withName name: String) {
    let fileUrl = Utils.pathInDocument(withComponent: name)
    do {
        let contentData = try String(contentsOf: fileUrl, encoding: .utf8)
        contentInputField.text = contentData
    } catch {
        showErrorAlert(withMessage: "File not found")
    }
 }

 @objc private func hideKeyboard() {
    view.endEditing(true)
 }
 
 private func saveImage(withName name: String) {
    let imageUrl = Utils.pathInDocument(withComponent: name)
    guard let image = imageView.image else { return }
    let imageData = UIImagePNGRepresentation(image)
    FileManager.default.createFile(atPath: imageUrl.path, contents: imageData)
 }
 
 private func loadImage(withName name: String) {
    let imageUrl = Utils.pathInDocument(withComponent: name)
    if FileManager.default.fileExists(atPath: imageUrl.path) {
        imageView.image = UIImage(contentsOfFile: imageUrl.path)
    } else {
        debugPrint("File doesn't exists")
        imageView.image = nil
    }
 }

 */
