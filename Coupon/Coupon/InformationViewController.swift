//
//  InformationViewController.swift
//  Coupon
//
//  Created by 김지나 on 2021/02/17.
//  Copyright © 2021 김지나. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var shopName: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var expireDate: UITextField!
    @IBOutlet weak var contentImg: UIImageView!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var contentTitle: UILabel!
    
    var coupon: Coupon?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        category.delegate = self
        shopName.delegate = self
        price.delegate = self
        expireDate.delegate = self
        
        let photoGesture = UITapGestureRecognizer(target: self, action: #selector(photoZoom))
        contentImg.isUserInteractionEnabled = true
        contentImg.addGestureRecognizer(photoGesture)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        let expireDateForm = dateFormat.string(from: coupon!.expireDate)
        
        category.text = coupon?.category
        shopName.text = coupon?.shop
        price.text = coupon?.price
        expireDate.text = expireDateForm
        
        // 이미지 No, 내용 No
        if coupon?.contentPhoto == nil && coupon?.content == "" {
            contentImg.isHidden = true
            contentView.isHidden = true
            contentTitle.isHidden = true
        }
        // 이미지 No, 내용 Yes
        else if coupon?.contentPhoto == nil && coupon?.content != "" {
            contentImg.isHidden = true
            let y = contentView.frame.origin.y
            contentView.frame.origin.y = y - 30
            contentView.text = coupon?.content
        }
        // 이미지 Yes, 내용 No
        else if coupon?.contentPhoto != nil && coupon?.content == "" {
            contentImg.image = coupon?.contentPhoto
            contentView.isHidden = true
        }
        // 이미지 Yes, 내용 Yes
        else {
            contentImg.image = coupon?.contentPhoto
            contentView.text = coupon?.content
        }
    }
    
    @objc func photoZoom() {
        let photoZoomView = self.storyboard?.instantiateViewController(withIdentifier: "photoZoom") as! PhotoZoomViewController
        photoZoomView.image = contentImg.image
        self.navigationController?.pushViewController(photoZoomView, animated: true)
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
