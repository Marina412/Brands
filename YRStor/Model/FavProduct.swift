//
//  FavProduct.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import Foundation

struct FavProducts: Decodable,Encodable {
    var draftOrders: [FavProduct]

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_orders"
    }
}
struct FavProduct :Decodable,Encodable{
    var draftId :Int?
    var email : String?
    var lineItems : [LineItems]?
    var image : String?
    var favOrShopping : String?
        var totalPrice: String?
    
    enum CodingKeys: String, CodingKey{
        case draftId = "id"
        case email = "email"
        case lineItems = "line_items"
        case favOrShopping = "note"
        case totalPrice = "total_price"
    }
}

struct LineItems :Decodable,Encodable{
    var productId : String?
    var productTitle : String?
    var productPrice : String?
    var quantity :Int = 1
    var productImage : String?
    var isFav  = false 

    enum CodingKeys: String, CodingKey{
        case productId = "sku"
        case productTitle = "title"
        case productPrice = "price"
        case quantity = "quantity"

    }
}

struct Drafts: Decodable,Encodable{
    var draftOrder: FavProduct
    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}
