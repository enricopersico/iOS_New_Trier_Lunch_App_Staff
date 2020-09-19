//
//  ScannedViewController.swift
//  lunchAppStaff
//
//  Created by Enrico Persico on 9/17/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ScannedViewController: UIViewController {
    
    var id: String!

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Firestore.firestore().collection("orders").document(id).getDocument { (document, error) in
            if let err = error {
                print(err)
                let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
                networkError?.modalPresentationStyle = .fullScreen
                self.present(networkError!, animated: true, completion: nil)
            } else {
                if let document = document, document.exists {
                    let data = document.data()!
                    if (data["status"] as! String) == "Complete" {
                        document.reference.updateData(["status": "Discarded"])
                        self.label.text = "Order Found! Look for code: " + String(self.id.prefix(5))
                        self.image.image = UIImage(systemName: "checkmark.circle")
                        self.image.tintColor = UIColor.systemGreen
                    }
                    else if (data["status"] as! String) == "Unprepared" || (data["status"] as! String) == "Awaiting Payment" {
                        self.label.text = "Order is still being prepared"
                        self.image.image = UIImage(systemName: "clock")
                        self.image.tintColor = UIColor.systemYellow
                    }
                    else if (data["status"] as! String) == "Discarded" {
                        self.label.text = "Order has already been picked up"
                        self.image.image = UIImage(systemName: "doc.plaintext")
                        self.image.tintColor = UIColor.systemYellow
                    } else {
                        
                    }
                } else {
                    self.label.text = "Order not Found!"
                    self.image.image = UIImage(systemName: "xmark.circle")
                    self.image.tintColor = UIColor.systemRed
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
