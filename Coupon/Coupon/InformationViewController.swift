//
//  InformationViewController.swift
//  Coupon
//
//  Created by 김지나 on 2021/02/17.
//  Copyright © 2021 김지나. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    @IBOutlet weak var categoryLB: UILabel!
    @IBOutlet weak var shopNameLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var expireDateLB: UILabel!
    @IBOutlet weak var contentImg: UIImageView!
    @IBOutlet weak var contentView: UITextView!
    
    var coupon: Coupon?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
