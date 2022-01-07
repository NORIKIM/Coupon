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
    var sevendays = [Coupon]()

    override func viewDidLoad() {
        super.viewDidLoad()
        deleteExpireCoupon()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "save"), object: nil)
        sevendays = db.sevenDays()
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
        let couponIndexArr = userDefaults.object(forKey: userDefaultsKey) as? [Int]
        
        if data.count == 1 {
            userDefaults.set([1], forKey: userDefaultsKey)
            return
        } else if couponIndexArr?.count == 0 {
            userDefaults.set([maxID], forKey: userDefaultsKey)
        } else {
            guard var couponIdx = userDefaults.object(forKey: userDefaultsKey) as? [Int] else {return}
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyyMMdd"
            
            var baseDate = ""
            if couponIdx.count == 0 {
                baseDate = dateformatter.string(from: data[0].expireDate)
            } else {
                baseDate = dateformatter.string(from: data[couponIdx[0] - 1].expireDate)
            }
            let addedDate = dateformatter.string(from: data[data.count-1].expireDate)
            
            if baseDate > addedDate {
                userDefaults.set([maxID], forKey: userDefaultsKey)
                return
            } else if baseDate == addedDate {
                couponIdx.append(maxID)
                userDefaults.set(couponIdx, forKey: userDefaultsKey)
                return
            }
        }
 
    }
    
    // 쿠폰 유효기간이 지나면 임박쿠폰 리스트에서 삭제
    func deleteExpireCoupon() {
        var couponIndexArr = userDefaults.object(forKey: userDefaultsKey) as? [Int] ?? [Int]()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        let today = dateFormat.string(from: Date())
        
        for coupon in 0 ..< couponIndexArr.count {
            let couponData = db.readDB(select: "전체", id: couponIndexArr[coupon])[0]
            let date = dateFormat.string(from: couponData.expireDate)

            if date < today {
                couponIndexArr.remove(at: coupon)
                userDefaults.set(couponIndexArr, forKey: userDefaultsKey)
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
        scrollView.layer.cornerRadius = 10
        scrollView.layer.borderColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1).cgColor
        scrollView.layer.borderWidth = 1
        
        //let couponIndexArr = userDefaults.object(forKey: userDefaultsKey) as? [Int] ?? [Int]()

        if sevendays.count < 2 {
            pageControl.numberOfPages = 0
        } else {
            pageControl.numberOfPages = sevendays.count
        }
        
        if sevendays.count == 0 {
            clearScrollView()
            let contentLb = UILabel()
            contentLb.textAlignment = .center
            contentLb.textColor = .black
            contentLb.frame = CGRect(x: 0, y: 0, width: self.couponView.frame.width, height: self.couponView.frame.height)
            contentLb.text = "등록된 쿠폰이 없습니다."
            contentLb.font = UIFont(name: "NanumSquareRoundR", size: 17)
            scrollView.contentSize.width = self.couponView.frame.width// * CGFloat(1)
            scrollView.addSubview(contentLb)
        } else {
            clearScrollView()
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy년 MM월 dd일"
            
            for i in 0 ..< sevendays.count {
                let coupon = sevendays[i]
                let expireDate = dateFormat.string(from: coupon.expireDate)
                let couponLb = UILabel(frame: CGRect(x: self.couponView.frame.size.width * CGFloat(i), y: 0, width: self.couponView.frame.size.width, height: self.couponView.frame.size.height))
                couponLb.textAlignment = .center
                couponLb.textColor = .black
                couponLb.numberOfLines = 3
                couponLb.text = "<  \(coupon.category)  > \n \(coupon.shop) \n \(expireDate)"
                couponLb.font = UIFont(name: "NanumSquareRoundR", size: 17)
                
                scrollView.addSubview(couponLb)
                scrollView.contentSize.width = self.couponView.frame.width * CGFloat(sevendays.count)
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

