//
//  PayForOrdersTableViewController.swift
//  lunchAppStaff
//
//  Created by Enrico Persico on 9/14/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PayForOrdersTableViewController: UITableViewController {
       
    var selectedOrder: Order!
    var orders = [Order]()

    struct Order {
        var id: String
        var user: String
        var occurred_at: NSDate
        var items: [Item]
    }
    
    struct Item {
        var name: String
        var cost: Double
        var quantity: Int
        var options: [Option]
    }
    
    struct Option {
        var name: String
        var selection: String
    }
    
    var timer: Timer?
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrders()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in self.getOrders()})
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    func getOrders() {
        orders.removeAll()
        Firestore.firestore().collection("orders").whereField("status", isEqualTo: "Awaiting Payment").getDocuments { (snapshot, error) in
        if let err = error {
            print(err)
            let networkError = self.storyboard?.instantiateViewController(withIdentifier: "networkError")
            networkError?.modalPresentationStyle = .fullScreen
            self.present(networkError!, animated: true, completion: nil)
        } else {
            for document in (snapshot?.documents)! {
                let id = document.documentID
                let data = document.data()
                let user = data["user"] as! String
                let occurred_at = (data["occurred_at"] as! Timestamp).dateValue() as NSDate
                let items = data["items"] as! [[String: Any]]
                var newItems = [Item]()
                for item in items {
                    let newName = item["name"] as! String
                    let newCost = item["cost"] as! Double
                    let newQuantity = item["quantity"] as! Int
                    
                    var newOptions = [Option]()
                    let options = item["options"] as! [[String: Any]]
                    for option in options {
                        let newOptionName = option["name"] as! String
                        let newOptionSelection = option["selection"] as! String
                        let newOption = Option(name: newOptionName, selection: newOptionSelection)
                        newOptions.append(newOption)
                    }
                    
                    let newItem = Item(name: newName, cost: newCost, quantity: newQuantity, options: newOptions)
                    newItems.append(newItem)
                }
                let newOrder = Order(id: id, user: user, occurred_at: occurred_at, items: newItems)
                self.orders.append(newOrder)
            }
            self.orders.sort { (lhs: Order, rhs: Order) in
                return lhs.occurred_at.timeIntervalSince1970 > rhs.occurred_at.timeIntervalSince1970
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        }
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payForOrder", for: indexPath) as! OrdersTableViewCell
        
        let order = orders[indexPath.row]
        cell.order = order
        cell.idLbl.text = String(order.id.prefix(5))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm a MM/dd/yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let occurred_atAsTime = order.occurred_at as Date
        let occurred_atAsString = dateFormatter.string(from: occurred_atAsTime)
        cell.orderTime.text = occurred_atAsString
        
        return cell
    }
       
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OrdersTableViewCell
        selectedOrder = cell.order
        performSegue(withIdentifier: "PayForOrdersTableToOrderDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let controller: PayForOrderDetailsViewController
        controller = segue.destination as! PayForOrderDetailsViewController
        controller.order = selectedOrder
    }
}
