//
//  Orders.swift
//  YRStor
//
//  Created by marina on 09/06/2023.
//

import Foundation
struct Orders: Codable{
    var orders: [Order]
}
struct Order: Codable{
    var created_at: String?
    var currency: String?
    var email: String?
    var current_total_price: String?
    var line_items: [OrderProductItems]?
    var reference:String?//pay type
    var note: String?//adress
}
struct OrderProductItems: Codable{
    var price: String?
    var product_id: Int?
    var quantity: Int?
    var title: String?
    var sku : String?
}

//{
//    "order":{
//            "created_at": "Fri, 16 Jun 2023 09:13:52",
//            "currency": "EUR",
//            "current_total_price": 10,
//            "email": "marina@gmail.com",
//            "line_items": [
//                {
//                    "product_id":555555,
//                    "title":"item.title",
//                    "price":50,
//                    "quantity":5,
//                    "sku":"item.productImage"
//                }
//            ]
//            ,
//            "shipping_address": {
//               "address1": "Zagazig"
//            }
//    }
