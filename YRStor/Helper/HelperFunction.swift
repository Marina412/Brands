//
//  HelperFunction.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import Foundation
import UIKit
class HelperFunctions{
    static func circleImage(image : UIImageView){
        image.layer.cornerRadius = image.frame.height / 2
        image.clipsToBounds = true
    }
    
    static func productPriceEXchange(curencyType:String , allProducts:[Product],rates:Rates)->[Product]{
        var filteredProducts : [Product] = []
        switch curencyType{
        case Constant.EGYPT_CURRENCY:
            filteredProducts = allProducts.map({item in
                var x = item
                x.variants?[0].price = String (format: "%.3f", (Double(item.variants?[0].price ?? "0") ?? 0) * (rates.EGP ?? 1) )
                return x
            })
        case Constant.AMERICAN_CURRENCY:
            filteredProducts = allProducts
            
        case Constant.EUROPE_CURRENCY:
            filteredProducts = allProducts.map({item in
                var x = item
                x.variants?[0].price = String(format: "%.3f", (Double(item.variants?[0].price ?? "0") ?? 0) * (rates.EUR ?? 1) )
                return x
            })
        case Constant.SAR_CURRENCY:
            filteredProducts = allProducts.map({item in
                var x = item
                x.variants?[0].price = String( format: "%.3f",(Double(item.variants?[0].price ?? "0") ?? 0) * (rates.SAR ?? 1) )
                return x
            })
        case Constant.UAE_CURRENCY:
            filteredProducts = allProducts.map({item in
                var x = item
                x.variants?[0].price = String(format: "%.3f", (Double(item.variants?[0].price ?? "0") ?? 0) * (rates.AED ?? 1) )
                return x
            })
        default:
            print("")
        }
        return filteredProducts
    }
    
//    static func orderToParameters(order:Order)->[String: Any]{
//        var lineItems :[[String:Any]] = [[:]]
//        order.line_items?.forEach{
//            item in
//            lineItems.append(
//                [
//                    "product_id": item.product_id ??  "",
//                    "title": item.title ??  "",
//                    "price": item.price ??  "",
//                    "quantity": item.quantity ??  "",
//                    "sku": item.sku ??  ""
//                ])
//        }
//        return ["order":[
//            "created_at": order.created_at ?? "",
//            "currency": order.currency ?? "",
//            "current_total_price": order.current_total_price ?? "",
//            "email": order.email ?? "",
//            "note":  order.note ?? "",
//            "reference": order.reference ?? "",
//            "line_items": [
//                lineItems
//            ]
//        ]
//        ]
//        
//    }
    
    //    func showAlertsWithOkBtn(message:String){
    //        let alert = UIAlertController(title: "Shopify", message: message, preferredStyle: .alert)
    //        alert.addAction(UIAlertAction(title: "OK", style: .default))
    //        present(alert, animated: true)
    //    }
}
