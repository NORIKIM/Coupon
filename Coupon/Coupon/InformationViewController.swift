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

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일 hh:mm a"
        let expireDate = dateFormat.string(from: coupon!.expireDate)
        
        categoryLB.text = coupon?.category
        shopNameLB.text = coupon?.shop
        priceLB.text = coupon?.price
        expireDateLB.text = expireDate
        
        if coupon?.contentPhoto == nil {
            contentImg.isHidden = true
            let y = contentView.frame.origin.y
            contentView.frame.origin.y = y - 30
            contentView.text = coupon?.content
        }  else if coupon?.content == "" {
            contentView.isHidden = true
        } else if coupon?.contentPhoto != nil && coupon?.content != "" {
            contentImg.image = coupon?.contentPhoto
            contentView.text = coupon?.content
        }
    }

}
