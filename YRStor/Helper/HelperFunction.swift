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
    static func formFavModelToProduct(shopCartProduct:FavProduct)->[OrderLineItems]{
        var orderProductItems : [OrderLineItems] = []
        orderProductItems.removeAll()
        shopCartProduct.lineItems?.forEach{
                lineItem in
                orderProductItems.append(OrderLineItems(
                    productPrice: lineItem.productPrice,productID: Int(lineItem.productId ?? "0"),productQuantity: lineItem.quantity, image:lineItem.productImage, productTitle:lineItem.productTitle
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
    static func curencyDefualtsFirstTime(){
            if UserDefaults.standard.string(forKey: Constant.CURRENCY) == nil{
                UserDefaults.standard.setValue(Constant.AMERICAN_CURRENCY, forKey: Constant.CURRENCY)
            }
        }
    }
    

