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
    var category: String
    var shop: String
    var price: String?
    var expireDate: Date
    var content: String?
    var cnotentPhoto: UIImage?
    
    init(category: String, shop: String, price: String?, expireDate: Date, content: String?, cnotentPhoto: UIImage?) {
        self.category = category
        self.shop = shop
        self.price = price
        self.expireDate = expireDate
        self.content = content
        self.cnotentPhoto = cnotentPhoto
    }
}

class Cafe: Coupon {
    
}

class Restaurant: Coupon {
    
}

class Shopping: Coupon {
    
}

class ConvenienceStore: Coupon {
    
}
