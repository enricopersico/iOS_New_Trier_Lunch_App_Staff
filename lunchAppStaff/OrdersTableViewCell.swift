//
//  OrdersTableViewCell.swift
//  lunchAppStaff
//
//  Created by Enrico Persico on 9/15/20.
//  Copyright © 2020 Enrico Persico. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    
    var order: PayForOrdersTableViewController.Order!
}
