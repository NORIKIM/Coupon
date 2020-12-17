//
//  PhotoZoomViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/12/17.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit

class PhotoZoomViewController: UIViewController {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.image = image
    }
    
    @IBAction func photoZoom(_ sender: Any) {
        photo.isUserInteractionEnabled = true
        photo.transform = photo.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale)
        pinchGesture.scale = 1.0
    }
}
