//
//  ViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/09/24.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let db = Database.shared
    var data = [Coupon]()
    let userDefaults = UserDefaults.standard
    let userDefaultsKey = "couponIndex"

    override func viewDidLoad() {
        super.viewDidLoad()
        data = db.readDB(select: "전체")
        setCouponScreen()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "save"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        data = db.readDB(select: "전체")
        setCouponScreen()
    }
    
    // 쿠폰이 추가되면 디비를 다시 읽어온 후 쿠폰 유효기간 확인
    @objc func refresh() {
        data = db.readDB(select: "전체")
        findExpireCoupon()
    }
    
    func findExpireCoupon() -> Void {
        let maxID = db.getID()
        
        if data.count == 1 {
            userDefaults.set([1], forKey: userDefaultsKey)
            return
        } else {
            var couponIndexArr = userDefaults.object(forKey: userDefaultsKey) as! [Int]
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyyMMdd"
            let baseDate = dateformatter.string(from: data[couponIndexArr[0]].expireDate)
            let addedDate = dateformatter.string(from: data[data.count-1].expireDate)
            
            if baseDate > addedDate {
                userDefaults.set([maxID], forKey: userDefaultsKey)
                return
            } else if baseDate == addedDate {
                couponIndexArr.append(maxID)
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
    
    // 임박한 쿠폰 보여주는 뷰 세팅
    func setCouponScreen() {
        let couponIndexArr = userDefaults.object(forKey: userDefaultsKey) as? [Int] ?? [Int]()

        if couponIndexArr.count == 1 || couponIndexArr.count == 0 {
            pageControl.numberOfPages = 0
        } else {
            pageControl.numberOfPages = couponIndexArr.count
        }
        
        if couponIndexArr.count == 0 {
            clearScrollView()
            let lb = UILabel()
            lb.textAlignment = .center
            lb.textColor = .white
            let xPosition = self.couponView.frame.width// * CGFloat(1)
            lb.frame = CGRect(x: xPosition, y: 0, width: self.couponView.frame.width, height: self.couponView.frame.height)
            lb.text = "등록된 쿠폰이 없습니다."
            lb.font = UIFont(name: "NanumSquareRoundR", size: 17)
            lb.backgroundColor = .red
            scrollView.contentSize.width = self.couponView.frame.width// * CGFloat(1)
            scrollView.addSubview(lb)
        } else {
            clearScrollView()
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy년 MM월 dd일"
            
            for coupon in 0 ..< couponIndexArr.count {
                let couponData = db.readDB(select: "전체", id: couponIndexArr[coupon])[0]
                let date = dateFormat.string(from: couponData.expireDate)
                
                let lb = UILabel()
                lb.textAlignment = .center
                lb.textColor = .white
                lb.frame = CGRect(x: self.couponView.frame.width * CGFloat(coupon), y: 0, width: self.couponView.frame.width, height: self.couponView.frame.height)
                lb.numberOfLines = 3
                lb.text = "\(couponData.category) \n \(couponData.shop) \n \(date)"
                lb.font = UIFont(name: "NanumSquareRoundR", size: 17)
                
                scrollView.addSubview(lb)
                scrollView.contentSize.width = self.couponView.frame.width * CGFloat(couponIndexArr.count)
            }
        }
        scrollView.delegate = self
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
    
    @IBAction func showCouponInfo(_ sender: UITapGestureRecognizer) {
        let scrollViewCurrentPage = pageControl.currentPage
        let indexData = userDefaults.object(forKey: userDefaultsKey) as? [Int]
        
        if indexData?.count == nil || indexData?.count == 0 {
            sender.isEnabled = true
        } else {
            let currentCouponPagenumber = indexData![scrollViewCurrentPage]
            let currentCoupon = db.readDB(select: "전체", id: currentCouponPagenumber)[0]
            let couponInfoView = self.storyboard?.instantiateViewController(withIdentifier: "information") as! InformationViewController
            
            couponInfoView.coupon = Coupon(id: currentCoupon.id, category: currentCoupon.category, shop: currentCoupon.shop, price: currentCoupon.price, expireDate: currentCoupon.expireDate, content: currentCoupon.content, contentPhoto: currentCoupon.contentPhoto)
            self.navigationController?.pushViewController(couponInfoView, animated: true)
        }
        
        
    }
}

