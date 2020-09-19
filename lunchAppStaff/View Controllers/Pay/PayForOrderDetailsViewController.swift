//
//  PayForOrderDetailsViewController.swift
//  lunchAppStaff
//
//  Created by Enrico Persico on 9/16/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PayForOrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var order: PayForOrdersTableViewController.Order!
    var items: [PayForOrdersTableViewController.Item]!
    
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var studentIdLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var costLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let items = order.items
        var cartTotal: Double = 0
        for item in items {
            cartTotal += item.cost
        }
        idLbl.text = String(order.id.prefix(5))
        studentIdLbl.text = "Student ID: " + order.user
        costLbl.text = String(format: "$%.2f", cartTotal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = order.items
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentItem") as! PaymentItems

        let items = order.items
        let item = items[indexPath.row]
        cell.name.text = item.name
        cell.cost.text = String(format: "$%.2f", item.cost)
        cell.quantity.text = "X" + String(item.quantity)
        
        return cell
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        Firestore.firestore().collection("orders").document(order.id).getDocument { (document, error) in
        if let err = error {
            print(err)
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
        } else {
            if let document = document, document.exists {
                let data = document.data()!
                if (data["status"] as! String) == "Awaiting Payment" {
                    document.reference.updateData(["status": "Complete"])
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    let userSelectionAlert = UIAlertController(title: "Oops!", message: "Looks like someone authorized this payment right before you!", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    userSelectionAlert.addAction(defaultAction)
                    self.present(userSelectionAlert, animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: false)
                }
            } else {print("Document doesn't exist")}
        }
        }
    }
}
