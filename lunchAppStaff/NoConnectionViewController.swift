//
//  NoConnectionViewController.swift
//  lunchAppStaff
//
//  Created by Enrico Persico on 9/14/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit

class NoConnectionViewController: UIViewController {
    @IBAction func retryPressed(_ sender: Any) {
        var vc: UIViewController
        if UserDefaults.standard.bool(forKey: "signedIn") {
            vc = storyboard!.instantiateViewController(withIdentifier: "signedIn")
        }
        else {
            vc = storyboard!.instantiateViewController(withIdentifier: "notSignedIn")
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}
