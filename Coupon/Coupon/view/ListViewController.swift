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
    @IBOutlet weak var noResultLb: UILabel!
    
    var couponlist: [Coupon] = []
    let db = Database.shared
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        couponlist = db.readDB(select: "전체")
        list.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        couponlist = db.readDB(select: "전체")
        list.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        couponlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListCell
        let index = indexPath.row
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        let date = dateFormat.string(from: couponlist[indexPath.row].expireDate)
        
        if couponlist.count != 0 {
            noResultLb.isHidden = true
        } else {
            noResultLb.isHidden = false
        }
        
        // 쿠폰 날짜 체크하여 만료 확인
        if Date().dateCompare(fromDate: couponlist[indexPath.row].expireDate) == "Past" {
            cell.endDateLb.isHidden = false
        } else {
            cell.endDateLb.isHidden = true
        }
        
        cell.shopNameLb.text = couponlist[index].shop
        cell.expirationDateLb.text = date
        if let price = couponlist[index].price {
            if price.isEmpty == false {
                cell.priceLb.text = "\(price)원"
            }
        }
        
        
        
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
            
//            var expireCoupon = UserDefaults.standard.object(forKey: "couponIndex") as! [Int]
//            for idx in 0 ..< expireCoupon.count {
//                if select == expireCoupon[idx] {
//                    expireCoupon.remove(at: idx)
//                    UserDefaults.standard.set(expireCoupon, forKey: "couponIndex")
//                }
//            }
            if couponlist.count != 0 {
                noResultLb.isHidden = true
            } else {
                noResultLb.isHidden = false
            }
            self.list.reloadData()
        }
        
    }
}

extension Date {
    public func dateCompare(fromDate: Date) -> String {
            var strDateMessage:String = ""
            let result:ComparisonResult = self.compare(fromDate)
            switch result {
            case .orderedAscending:
                strDateMessage = "Future"
                break
            case .orderedDescending:
                strDateMessage = "Past"
                break
            case .orderedSame:
                strDateMessage = "Same"
                break
            default:
                strDateMessage = "Error"
                break
            }
            return strDateMessage
        }
}
