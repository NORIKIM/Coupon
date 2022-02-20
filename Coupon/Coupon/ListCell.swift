//
//  ListCell.swift
//  Coupon
//
//  Created by 김지나 on 2022/01/20.
//  Copyright © 2022 김지나. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var shopNameLb: UILabel!
    @IBOutlet weak var expirationDateLb: UILabel!
    @IBOutlet weak var endDateLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
