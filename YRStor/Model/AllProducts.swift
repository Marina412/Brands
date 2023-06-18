//
//  AllProudects.swift
//  YRStor
//
//  Created by marina on 04/06/2023.
//

import Foundation

struct AllProudects: Codable {
    var products: [Product]?
}
struct Product: Codable {
    var id: Int?
    var title, bodyHTML, vendor, productType: String?
    var tags:String?
    var variants: [Variant]?
    var image: ProductImage?
    var images: [ProductImage]?
    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case tags,variants,  images, image
       
    }
}
struct ProductImage: Codable {
    var src: String?
         enum CodingKeys: String, CodingKey {
             case src
         }
}
struct Variant: Codable {
    var price: String?
    enum CodingKeys: String, CodingKey {
        case  price
    }
}
