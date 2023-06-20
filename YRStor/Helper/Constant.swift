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
    static  var POST_ORDERS_URL = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/orders.json?"
    
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
    static let  GET_ORDERS_URL =
          "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/orders.json?status=any"
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
    static let EGYPT_CURRENCY = "EGP"
    static let AMERICAN_CURRENCY = "USD"
    static let EUROPE_CURRENCY = "EUR"
    static let SAR_CURRENCY = "SAR"
    static let UAE_CURRENCY = "AED"
    static let  CURRENCY_EXCHANGE_API_URL = "https://api.apilayer.com/exchangerates_data/latest?base=USD&symbols=EGP,USD,EUR,SAR,AED&apikey="
    static let CURRENCY_EXCHANGE_API_KEY = "0uxDuSoR0i4382UVae3zEGwS2hvoM2R4"
    
    
    static let PAY_Method = "payMethod"
    static let CUPON_NUMBER = "cuponNumber"
    static let CUPON_CODE = "cuponCode"
    static let EMAIL = "email"
    
    static let COUNTRIES  = ["Choose Country","Egypt","United Kingdom","United States","Saudi Arabia","United Arab Emirates","Italy"]
    
    static let CITIES_EGYPT  = ["Choose City","Cairo","Alexandria","luxor","Aswan","Giza","Ismailia","Zagazig","Mansoura","Damietta"]
    static let  CITIES_UK = ["Choose City","London","Liverpool","Bristol","Manchester","Brighton","Preston","Derby","Cambridge","Oxford"]
    static let CITIES_US = ["Choose City","Austin","New York","Seattle","San Francisco","Los Angeles","Miami","Atlanta","Orlando","Chicago"]
    static let CITIES_SAR  = ["Choose City","Riyadh","Jaddah","Dammam","Mecca","Taif","Hail","Al Madinah Al Munawwarah","Al Khobar","Najran"]
    static let CITIES_UAE = ["Choose City","Dubai","Ajman","Hatta","Abu Dhabi","Ras Khaimah","Fujairah","Khor Fakkan","Jebel Ali","Liwa Oasis"]
    static let CITIES_ITALY  = ["Choose City","Rome","Venice","Florence","Milan","Verona","Pisa","Perugia","Trento","Lecce"]
    
    
}


