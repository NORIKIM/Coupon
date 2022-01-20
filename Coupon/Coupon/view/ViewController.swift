//
//  ViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/09/24.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let db = Database.shared
    var data = [Coupon]()

    override func viewDidLoad() {
        super.viewDidLoad()
        data = db.readDB(select: "전체")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        data = db.readDB(select: "전체")
    }

}

