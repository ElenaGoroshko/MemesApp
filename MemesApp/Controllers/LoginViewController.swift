//
//  LoginViewController.swift
//  MemesApp
//
//  Created by Elena Goroshko on 1/3/18.
//  Copyright © 2018 Elena Goroshko. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var ibTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DataManager.instance.getEmail() != nil {
            ibTextField.text = DataManager.instance.getEmail()
            DataManager.instance.loadMemes()
            showMemes()
        } else {
            ibTextField.text = ""
        }
    }
    @IBAction func startPressed(_ sender: UIButton) {
        guard let email = validationEmail(email: ibTextField.text) else {
            self.showAlertError(message: "Введите корректний eMail.")
            return
        }
        DataManager.instance.setEmail(email: email)
        showMemes()
    }
    private func validationEmail(email: String?) -> String? {
        guard let email = email,
                 email.contains("@")
        else {
            return nil
        }
        return email
    }
    private func showMemes () {
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "ShowMemes") as? MemesCollectionViewController
            else { return }
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
