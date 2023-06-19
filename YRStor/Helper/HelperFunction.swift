//
//  HelperFunction.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import Foundation
import UIKit
import Reachability
class HelperFunctions{
    static func circleImage(image : UIImageView){
        image.layer.cornerRadius = image.frame.height / 2
        image.clipsToBounds = true
    }
    static func priceEXchange(curencyType:String , price:String,rates:Rates)->String{
        var priceEx:String = ""
        switch curencyType{
        case Constant.EGYPT_CURRENCY:
            priceEx = String (format: "%.3f", (Double(price) ?? 0) * (rates.EGP ?? 1) )
        case Constant.AMERICAN_CURRENCY:
            priceEx = price
        case Constant.EUROPE_CURRENCY:
            priceEx = String (format: "%.3f", (Double(price) ?? 0) * (rates.EUR ?? 1) )
        case Constant.SAR_CURRENCY:
            priceEx = String (format: "%.3f", (Double(price) ?? 0) * (rates.SAR ?? 1) )
        case Constant.UAE_CURRENCY:
            priceEx = String (format: "%.3f", (Double(price) ?? 0) * (rates.AED ?? 1) )
        default:
            print("")
        }
        return priceEx
        
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
    
    static func orderToParameters(order:Order)->[String: Any]{
        var lineItems :[[String:Any]] = [[:]]
        order.line_items?.forEach{
            item in
            lineItems.append(
                [
                    "product_id": item.product_id ??  "",
                    "title": item.title ??  "",
                    "price": item.price ??  "",
                    "quantity": item.quantity ??  "",
                    "sku": item.sku ??  ""
                ])
        }
        return ["order":[
            "created_at": order.created_at ?? "",
            "currency": order.currency ?? "",
            "current_total_price": order.current_total_price ?? "",
            "email": order.email ?? "",
            "note":  order.note ?? "",
            "reference": order.reference ?? "",
            "line_items": [
                lineItems
            ]
        ]
        ]
        
    }
    
    static func getTimestamp() ->String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        print(dateString)
        return dateString
    }
    
    static func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            default:
                return false
                
            }
        }
        catch {
            return false
        }
    }
    static func showWorining(completionHandler:@escaping ()->Void)->UIAlertController{
        let alert = UIAlertController(title: "Worning", message: "Please Check Your Connection!!!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("ok worn")
            completionHandler()
        })
        
        let imgTitle = UIImage(systemName:"wifi.slash")
        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imgViewTitle.image = imgTitle
        
        alert.view.addSubview(imgViewTitle)
        alert.addAction(action)
        
        return alert
        
    }
    /*
     
     self.present( HelperFunctions.showWorining(completionHandler: {
     action in
     if action == "ok"{
     }
     else{
     }
     }), animated: true, completion: nil)
     */
    
    
    static func formFavModelToProduct(shopCartProduct:FavProduct)->[OrderProductItems]{
        var orderProductItems : [OrderProductItems] = []
        orderProductItems.removeAll()
        shopCartProduct.lineItems?.forEach{
                lineItem in
                orderProductItems.append(OrderProductItems(
                    price: lineItem.productPrice,product_id: Int(lineItem.productId ?? "0"),quantity: lineItem.quantity, title:lineItem.productTitle,sku:lineItem.productImage
                ))
            }
        return orderProductItems
        }
       
    static func shopBagCount(itemCount:Int,plusOrMinus:String)->Int{
        var countRes:Int!
        switch plusOrMinus{
        case "plus":
            var count = UserDefaults.standard.integer(forKey: "shopBagCount") 
             UserDefaults.standard.setValue(count + itemCount, forKey: "shopBagCount")
            countRes = count + itemCount
        case "minus":
            var count = UserDefaults.standard.integer(forKey: "shopBagCount")
             UserDefaults.standard.setValue(count - itemCount, forKey: "shopBagCount")
            countRes = count - itemCount
        default:
            print("")
        }
        return countRes 
 }
   
    }
    

