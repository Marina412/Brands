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
    var order_id: Int
    var currency: String
    var current_total_price: String
    var line_items: [ProductItems]
}
struct ProductItems: Codable{
    var product_id : Int
    var title: String
    var price: String
    var quantity: Int
    var vendor: String
}

