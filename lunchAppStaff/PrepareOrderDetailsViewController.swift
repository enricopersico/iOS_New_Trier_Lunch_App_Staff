//
//  PrepareOrderDetailsViewController.swift
//  lunchAppStaff
//
//  Created by Enrico Persico on 9/16/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PrepareOrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var order: PayForOrdersTableViewController.Order!
    var items: [PayForOrdersTableViewController.Item]!
    var cells = [UITableViewCell]()
    
    var currentCell: String = "name/quantity"
    var optionIndex: Int = 0
    var itemIndex: Int = 0
    var cellCount = 0
    
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        idLbl.text = String(order.id.prefix(5))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = order.items
        cellCount = 0
        for item in items {
            cellCount += item.options.count + 2
        }
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cells.count == cellCount {return cells[indexPath.row]} else {
            let cell = UITableViewCell()
            let items = order.items
            let item = items[itemIndex]
            let options = item.options
            let label = cell.textLabel!
            label.textColor = UIColor.systemBlue
            if currentCell == "name/quantity" {
                label.text = "X" + String(item.quantity) + "\t" + item.name
                label.font = label.font.withSize(40)
                currentCell = "Options:"
            } else if currentCell == "Options:" {
                label.text = "Options:"
                label.font = label.font.withSize(30)
                optionIndex = 0
                currentCell = "list of options"
            } else if currentCell == "list of options" {
                if optionIndex == options.count {
                    currentCell = "name/quantity"
                    itemIndex += 1
                } else {
                    let option = options[optionIndex]
                    label.text = option.name + ": " + option.selection
                    label.font = label.font.withSize(30)
                    optionIndex += 1
                }
            }
            cells.append(cell)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentCell == "name/quantity" {return 90} else {return 50}
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
                    if (data["status"] as! String) == "Unprepared" {
                        document.reference.updateData(["status": "Awaiting Payment"])
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
