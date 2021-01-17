//
//  ViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/09/24.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let db = Database().readDB(select: "전체")
    var dbRowCount = 0
    var expireCoupon = [Coupon]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nearExpire()
        
        if expireCoupon.count > 1 {
            pageControl.numberOfPages = expireCoupon.count
        }
        setCouponScreen()
        scrollView.delegate = self
    }

    func setCouponScreen() {
        var frame = CGRect.zero
        for idx in 0 ..< expireCoupon.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(idx)
            frame.size = scrollView.frame.size
            
            let couponInfoLB = UILabel(frame: CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            couponInfoLB.textAlignment = .center
            couponInfoLB.text = "\(expireCoupon[idx].category) \n \(expireCoupon[idx].shop) \n \(expireCoupon[idx].expireDate)"
            couponInfoLB.numberOfLines = 3
            
            self.scrollView.addSubview(couponInfoLB)
        }
        
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(expireCoupon.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    func nearExpire() {
        print("near")
        expireCoupon.append(db[0])
        /*if db.count == 0 {
            nearestExpireCoupon!.setTitle("등록된 쿠폰이 없습니다.:)", for: .normal)
        } else if db.count == 1 {
            let firstCoupon = db[0].shop
            nearestExpireCoupon.setTitle(firstCoupon, for: .normal)
        } else {
            // 기간이 기존<신규 인지 비교(신규가 더 임박하냐?)
            if db[dbRowCount].expireDate.compare(db[db.count-1].expireDate) == .orderedDescending {
                dbRowCount = db.count - 1
                nearestExpireCoupon.setTitle(db[dbRowCount].shop, for: .normal)
            } else { // 기존=신규
                
            }
        }*/
        
    }
    
    // ListView에 선택한 카테고리의 타이틀을 listView로 넘겨줌
    @IBAction func category(_ sender: UIButton) {
        let listView = self.storyboard?.instantiateViewController(withIdentifier: "listView") as! ListViewController
        
        if let select = sender.currentTitle {
            listView.category = select
        }
        
        self.navigationController?.pushViewController(listView, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}

