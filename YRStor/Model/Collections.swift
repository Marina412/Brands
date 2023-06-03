//
//  Collections.swift
//  YRStor
//
//  Created by marina on 02/06/2023.
//

import Foundation
struct Collections: Codable {
    var collection_listings: [Collection]?
}
struct Collection: Codable {
    var collectionID: Int?
    var bodyHTML: String?
    var handle: String?
    var collectionImage: CollectionImage?
    var title: String?
    enum CodingKeys: String, CodingKey {
        case collectionID = "collection_id"
        case bodyHTML = "body_html"
        case collectionImage = "image"
        case handle, title
    }
}
struct CollectionImage: Codable {
    var src: String?
}
