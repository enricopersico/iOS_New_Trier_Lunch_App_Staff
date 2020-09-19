//
//  AccountViewController.swift
//  lunchAppStaff
//
//  Created by Enrico Persico on 9/14/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var userId: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId.text = UserDefaults.standard.string(forKey: "user")
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        func backToLogin(alertAction: UIAlertAction) {
            UserDefaults.standard.set(false, forKey: "signedIn")
            let signOut = self.storyboard?.instantiateViewController(withIdentifier: "notSignedIn")
            signOut!.modalPresentationStyle = .fullScreen
            self.present(signOut!, animated: false, completion: nil)
        }
        
        let signOutAlert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertController.Style.alert)
        var defaultAction = UIAlertAction(title: "Sign Out", style: .default, handler: backToLogin)
        signOutAlert.addAction(defaultAction)
        defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        signOutAlert.addAction(defaultAction)
        self.present(signOutAlert, animated: true, completion: nil)
    }
}
