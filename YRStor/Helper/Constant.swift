//
//  Constant.swift
//  Shopify
//
//  Created by marina on 31/05/2023.
//

import Foundation
struct Constant{
    var collectionId = 0
    static let ALL_PRODUCTS_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2022-01/products.json?"
    
    static let PRODUCTS_BY_CATEGORY_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2022-01/collections/447457460531/products.json"
    
    static let PRODUCTS_BY_ID_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2022-01/products.json?ids="
    
    
    static let COLECTIONS_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2022-01/collection_listings.json"
    
    var productByCollectionIdUrl :String{
        return "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2022-01/collections/\(collectionId)/products.json"
        
    }
    
    static let ACCESSORIES = "ACCESSORIES"
    static let SHOES = "SHOES"
    static let T_SHIRTS = "T-SHIRTS"
    
    static let WOMEN = "women"
    static let MEN = "men"
    static let KID = "kid"
    static let SALE = "sale"
    
    static let ON_SALE_COLLECTION_ID = 447457984819
    static let MEN_COLLECTION_ID = 447457984819
    static let WOMEN_COLLECTION_ID = 447457919283
    static let KID_COLLECTION_ID = 447457853747
    
}
