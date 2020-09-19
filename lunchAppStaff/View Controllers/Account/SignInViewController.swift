//
//  SignInViewController.swift
//  lunchAppStaff
//
//  Created by Enrico Persico on 9/14/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SignInViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signInBtnClicked(_ sender: Any) {
        let _: Void = Firestore.firestore().collection("users").whereField("type", isEqualTo: "staff").whereField("username", isEqualTo: username.text!).whereField("password", isEqualTo: password.text!).getDocuments { (snapshot, error) in
        if let err = error {
            print(err)
        } else {
            if (snapshot?.documents)!.count == 1 {
                UserDefaults.standard.set(true, forKey: "signedIn")
                UserDefaults.standard.set(self.username.text!, forKey: "user")
                self.performSegue(withIdentifier: "signIn", sender: self)
            }
            else {
                let signInAlert = UIAlertController(title: "Wrong Username/Password", message: "Please reenter your username and password.", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                signInAlert.addAction(defaultAction)
                self.present(signInAlert, animated: true, completion: nil)
            }
        }
        }
    }
}

