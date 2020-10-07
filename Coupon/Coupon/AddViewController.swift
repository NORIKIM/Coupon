//
//  AddViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/09/26.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var convenienceStoreButton: UIButton!
    
    var categoryButton = [UIButton]()
    var category = ""
    @IBOutlet weak var content: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryButton = [cafeButton,restaurantButton,shoppingButton,convenienceStoreButton]
    }
    

    // 참고 : https://zeddios.tistory.com/406
    // NSTextAttachment
    func couponContent() {
        
    }
    @IBAction func selectCategory(_ sender: UIButton) {
        for button in categoryButton {
            if sender.tag == button.tag {
                button.isSelected = true
                button.tintColor = .systemYellow
            } else {
                button.isSelected = false
                button.tintColor = .lightGray
            }
        }        
    }
    
    
}
