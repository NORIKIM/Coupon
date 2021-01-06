//
//  ViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/09/24.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func category(_ sender: UIButton) {
        let listView = self.storyboard?.instantiateViewController(withIdentifier: "listView") as! ListViewController
        
        if let select = sender.currentTitle {
            listView.category = select
        }
        
        self.navigationController?.pushViewController(listView, animated: true)
    }
}

