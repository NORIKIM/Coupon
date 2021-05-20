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
    
    override func viewWillAppear(_ animated: Bool) {
        couponlist = db.readDB(select: category)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        couponlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        let today = dateFormat.string(from: Date())
        let date = dateFormat.string(from: couponlist[indexPath.row].expireDate)
        
        if today > date {
            let expireLB = UILabel(frame: CGRect(x: cell.frame.width / 2, y: cell.frame.height / 2, width: 30, height: 10))
            expireLB.text = "만료"
            expireLB.font = UIFont.systemFont(ofSize: 13)
            expireLB.textColor = UIColor.red
            cell.addSubview(expireLB)
            //            cell.backgroundColor = UIColor.systemGray5
        }
        
        cell.textLabel?.text = couponlist[indexPath.row].shop
        cell.detailTextLabel?.text = date
        
        return cell
    }
    
    // 선택한 셀 정보를 수정페이지로 전달
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let coupon = couponlist[index]
        
        let couponInfoView = self.storyboard?.instantiateViewController(withIdentifier: "information") as! InformationViewController
        couponInfoView.coupon = Coupon(id: coupon.id, category: coupon.category, shop: coupon.shop, price: coupon.price, expireDate: coupon.expireDate, content: coupon.content, contentPhoto: coupon.contentPhoto)
        self.navigationController?.pushViewController(couponInfoView, animated: true)
    }
    
    // 셀 편집 활성화
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 셀 편집에 대한 동작
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let data = db.readDB(select: "전체")
        let select = data[index].id
        
        if editingStyle == .delete {
            db.delete(cell: select) // select == id
            couponlist.remove(at: index)
            
            var expireCoupon = UserDefaults.standard.object(forKey: "couponIndex") as! [Int]
            for idx in 0 ..< expireCoupon.count {
                if select == expireCoupon[idx] {
                    expireCoupon.remove(at: idx)
                    UserDefaults.standard.set(expireCoupon, forKey: "couponIndex")
                }
            }
            self.list.reloadData()
        }
        
    }
}
