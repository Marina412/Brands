//
//  FavProduct.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import Foundation

struct FavProducts: Decodable {
    let draftOrders: [FavProduct]

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_orders"
    }
}
struct FavProduct : Decodable{
    var draftId :Int?
    var email : String?
    var lineItems : [LineItems]?
    var image : String?
    
    enum CodingKeys: String, CodingKey{
        case draftId = "id"
        case email = "email"
        case lineItems = "line_items"
    }
}

struct LineItems :Decodable{
    var productId : String?
    var productTitle : String?
    var productPrice : String?
    var quantity : String?
    
    enum CodingKeys: String, CodingKey{
        case productId = "sku"
        case productTitle = "title"
        case productPrice = "price"
    }
}
