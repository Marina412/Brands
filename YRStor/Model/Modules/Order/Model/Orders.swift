//
//  Orders.swift
//  YRStor
//
//  Created by marina on 09/06/2023.
//
import Foundation
struct Orders: Codable{
    var orders: [Order]
    enum CodingKeys: String, CodingKey {
        case orders
    }
}
struct Order: Codable {
    var createdAt: String?
    var currencyType: String?
    var currentTotalPrice: String?
    var userEmail: String?
    var address: String?//ad
    var payType: String?//pay///////
    var lineItems: [OrderLineItems]?
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case currencyType = "currency"
        case currentTotalPrice = "current_total_price"
        case userEmail = "email"
        case address = "note"
        case payType = "tags"
        case lineItems = "line_items"
    }
}
struct OrderLineItems: Codable {
    var productPrice: String?
    var productID: Int?
    var productQuantity: Int?
    var image: String?
    var productTitle: String?
    enum CodingKeys: String, CodingKey {
        case productPrice = "price"
        case productID = "product_id"
        case productQuantity = "quantity"
        case image = "sku"
        case  productTitle = "title"
    }
}
struct PostOrders: Codable {
    var order: Order?
    enum CodingKeys: String, CodingKey {
        case order
    }
}
extension Encodable{
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
