//
//  ViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/09/24.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit
// 이거
class ViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let db = Database().readDB(select: "전체")
    let userDefaults = UserDefaults.standard
    let userDefaultsKey = "couponIndex"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCouponScreen()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setCouponScreen()
    }
    
    func findExpireCoupon() -> Void {
        if db.count == 1 {
            userDefaults.set([db.count - 1], forKey: userDefaultsKey)
            return
        } else {
            var couponIndexArr = userDefaults.object(forKey: userDefaultsKey) as! [Int]
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .long
            let baseDate = dateformatter.string(from: db[couponIndexArr[0]].expireDate)
            let addedDate = dateformatter.string(from: db[db.count-1].expireDate)
            
            if baseDate > addedDate {
                userDefaults.set([db.count - 1], forKey: userDefaultsKey)
                return
            } else if baseDate == addedDate {
                couponIndexArr.append(db.count - 1)
                userDefaults.set(couponIndexArr, forKey: userDefaultsKey)
                return
            }
        }
    }
    
    func clearScrollView() {
        let scrollSubviews = self.scrollView.subviews
        for subview in scrollSubviews {
            subview.removeFromSuperview()
        }
    }
    
    // 임박한 쿠폰 보여주기
    func setCouponScreen() {
        guard let scroll = self.scrollView else {return}
        let scrollwidth = scroll.frame.width
        let scrollheight = scroll.frame.height
        let couponIndexArr = userDefaults.object(forKey: userDefaultsKey) as? [Int] ?? [Int]()
        
        if couponIndexArr.count == 1 || couponIndexArr.count == 0 {
            pageControl.numberOfPages = 0
        } else {
            pageControl.numberOfPages = couponIndexArr.count
        }
        
        if couponIndexArr.count == 0 {
            let couponInfoLB = UILabel(frame: CGRect(x: 0 , y: 0 , width: scrollwidth, height: scrollheight))
            couponInfoLB.textAlignment = .center
            couponInfoLB.numberOfLines = 3
            couponInfoLB.text = "등록된 쿠폰이 없습니다"
            self.scrollView.addSubview(couponInfoLB)
        } else {
            clearScrollView()
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy년 MM월 dd일 hh:mm a"

            for idx in 0 ..< couponIndexArr.count {
                let date = dateFormat.string(from: db[couponIndexArr[idx]].expireDate)
                let couponInfoLB = UILabel(frame: CGRect(x: CGFloat(idx) * scrollwidth , y: 0 , width: scrollwidth, height: scrollheight))
                couponInfoLB.textAlignment = .center
                couponInfoLB.text = "\(db[couponIndexArr[idx]].category) \n \(db[couponIndexArr[idx]].shop) \n \(date)"
                couponInfoLB.numberOfLines = 3
                self.scrollView.addSubview(couponInfoLB)
            }
            scrollView.delegate = self
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    // ListView에 선택한 카테고리의 타이틀을 listView로 넘겨줌
    @IBAction func category(_ sender: UIButton) {
        let listView = self.storyboard?.instantiateViewController(withIdentifier: "listView") as! ListViewController
        
        if let select = sender.currentTitle {
            listView.category = select
        }
        
        self.navigationController?.pushViewController(listView, animated: true)
    }
}

