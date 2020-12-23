//
//  PhotoZoomViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/12/17.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit

class PhotoZoomViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.image = image
        scrollViewSet()
    }
    
    // 확대할 뷰
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photo
    }
    
    func scrollViewSet() {
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
    }
}
