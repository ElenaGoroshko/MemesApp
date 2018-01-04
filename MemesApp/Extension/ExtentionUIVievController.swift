//
//  ExtentionUIVievController.swift
//  MemesApp
//
//  Created by Elena Goroshko on 1/3/18.
//  Copyright © 2018 Elena Goroshko. All rights reserved.
//

import UIKit
extension UIViewController {
    func showAlertError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
