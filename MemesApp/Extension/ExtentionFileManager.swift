//
//  ExtentionFileManager.swift
//  MemesApp
//
//  Created by Elena Goroshko on 1/9/18.
//  Copyright © 2018 Elena Goroshko. All rights reserved.
//

import Foundation
extension FileManager {
    func directoryExists (atPath path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    }
}
