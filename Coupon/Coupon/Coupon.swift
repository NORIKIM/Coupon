//
//  Coupon.swift
//  Coupon
//
//  Created by 김지나 on 2020/09/26.
//  Copyright © 2020 김지나. All rights reserved.
//

import Foundation

class Coupon {
    var category: String
    var shop: String
    var price: Int?
    var expireDate: Date
    var content: String
    
    init(category: String, shop: String, price: Int?, expireDate: Date, content: String) {
        self.category = category
        self.shop = shop
        self.price = price
        self.expireDate = expireDate
        self.content = content
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
