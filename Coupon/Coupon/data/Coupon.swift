//
//  Coupon.swift
//  Coupon
//
//  Created by 김지나 on 2020/09/26.
//  Copyright © 2020 김지나. All rights reserved.
//

import Foundation
import UIKit

class Coupon {
    var id: Int
    var category: String
    var shop: String
    var price: String?
    var expireDate: Date
    var content: String?
    var contentPhoto: UIImage?
    
    init(id: Int, category: String, shop: String, price: String?, expireDate: Date, content: String?, contentPhoto: UIImage?) {
        self.id = id
        self.category = category
        self.shop = shop
        self.price = price
        self.expireDate = expireDate
        self.content = content
        self.contentPhoto = contentPhoto
    }
}
