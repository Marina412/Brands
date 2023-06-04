//
//  AllProducts.swift
//  YRStor
//
//  Created by Huda kamal  on 03/06/2023.
//

import Foundation
struct AllProudects : Decodable{
    let products: [Product]
}
struct Product: Codable {
    var id: Int?
    var title, bodyHTML, vendor, productType: String?
    var tags:String?
    var image: ProductImage?
    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case tags, image
    }
}
struct ProductImage: Codable {
    var src: String?
    enum CodingKeys: String, CodingKey {
        case  src
    }
}

//// MARK: - Product
//struct Product  : Decodable{
//    let id: Int
//    let title, body_html, vendor: String
////    let productType: ProductType
////    let status: Status
////    let publishedScope: PublishedScope
//
//    let variants: [Variant]?
////    let options: [Option]
//    let images: [Image]?
//    let image: Image?
//}
//
//// MARK: - Image
//struct Image : Decodable {
//    let id, productID, position: Int?
//    let createdAt, updatedAt: Date?
//  //  let alt: NSNull
//    let width, height: Int?
//    let src: String?
//  //  let variantIDS: [Any?]
//  //  let adminGraphqlAPIID: String
//}
//
//// MARK: - Option
////struct Option :Decodable{
////    let id, productID: Int
////    let name: Name
////    let position: Int
////    let values: [String]
////}
//
//enum Name {
//    case color
//    case size
//}
//
//enum ProductType {
//    case accessories
//    case shoes
//    case tShirts
//}
//
//enum PublishedScope {
//    case global
//}
//
//enum Status {
//    case active
//}
//
//// MARK: - Variant
//struct Variant : Decodable{
//    let id, product_id: Int?
//    let title, price : String?
//}
//
//enum FulfillmentService {
//    case manual
//}
//
//enum InventoryManagement {
//    case shopify
//}
//
//enum InventoryPolicy {
//    case deny
//}
//
//enum Option2 {
//    case beige
//    case black
//    case blue
//    case burgandy
//    case gray
//    case lightBrown
//    case red
//    case white
//    case yellow
//}
//
//enum WeightUnit {
//    case kg
//}
