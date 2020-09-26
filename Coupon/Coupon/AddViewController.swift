//
//  AddViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/09/26.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    var category = ""
    @IBOutlet weak var content: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // 참고 : https://zeddios.tistory.com/406
    // NSTextAttachment
    func couponContent() {
        
    }
    @IBAction func selectCategory(_ sender: UIButton) {
        sender.tintColor = .systemYellow
        category = String((sender.currentTitle?.dropFirst())!)
    }
}
