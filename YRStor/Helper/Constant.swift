//
//  Constant.swift
//  Shopify
//
//  Created by marina on 31/05/2023.
//

import Foundation
import Alamofire
struct Constant{
    var collectionId = 0
    var productIds : [Int] = []
    var customerId = 0
    var addressId = 0
    
    
    static let ALL_PRODUCTS_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2022-01/products.json?"
    
    static let PRODUCTS_BY_CATEGORY_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2022-01/collections/447457460531/products.json"
    
    static let PRODUCTS_BY_ID_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2022-01/products.json?ids="
    
    static let GET_CUSTOMERS_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/customers.json?"
    
    
    static let POST_CUSTOMER_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/customers.json"
    
    static let POST_FAV_PRODUCT_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/draft_orders.json"
    
    static let GET_ALL_FAV_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/draft_orders.json"
    
    static let COLECTIONS_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/collection_listings.json"
    
    var PRODUCT_BY_COLLECTION_ID_URL :String{
        return "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/collections/\(collectionId)/products.json"
    }
    var PRODUCT_PRICE_URL :String{
        var concatIdsUrl : String = ""
        for id in productIds{
            concatIdsUrl.append("\(id),")
        }
        concatIdsUrl = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/products.json?ids=" + concatIdsUrl
        return concatIdsUrl
    }
    
    var GET_CUSTOMER_ORDERS_URL: String{
        return "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/customers/\(customerId)/orders.json?"
    }
    var POST_ORDERS_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/orders.json?"
    
    static let POST_ADDRESS_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/customers/"
    
    var DELETE_ADDRESS:String{
        return "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/customers/\(customerId)/addresses/\(addressId).json"
         
    }
    
    static let PUT_FAV_PRODUCT_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/draft_orders/"
       
       static let IS_FAV = "Fav"
       static let IS_SHOPPING_CART = "ShoppingCart"
        
    static let HEADER = HTTPHeader (name: "Content-Type", value :"application/json")
    
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
    
    static let CURRENCY = "currency"
    static let EGYPT_CURRENCY = "Egyptian Pound"
    static let AMERICAN_CURRENCY = "Dollar"
    static let EUROPE_CURRENCY = "Euro"
    static let SAR_CURRENCY = "SAR Riyal"
    static let UAE_CURRENCY = "UAE Dirham"
    static let  CURRENCY_EXCHANGE_API_URL = "https://api.apilayer.com/exchangerates_data/latest?base=EGP&symbols=EGP,USD,EUR,SAR,AED"
    static let CURRENCY_EXCHANGE_API_KEY = "0uxDuSoR0i4382UVae3zEGwS2hvoM2R4"
    
    static let PAY_Method = "payMethod"
    static let CUPON_NUMBER = "cuponNumber"
    static let CUPON_CODE = "cuponCODE"
    
}


