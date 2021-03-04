//
//  ListViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/12/17.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var list: UITableView!
    var couponlist: [Coupon] = []
    let db = Database.shared
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        couponlist = db.readDB(select: category)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        couponlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        let date = dateFormat.string(from: couponlist[indexPath.row].expireDate)
        
        cell.textLabel?.text = couponlist[indexPath.row].shop
        cell.detailTextLabel?.text = date
        
        return cell
    }
}
