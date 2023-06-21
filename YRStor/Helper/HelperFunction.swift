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
    static func currencySetUp()->Rates{
        var rates = Rates()
        Repo(networkManager: NetworkManager()).getCurrency{
            res in
            guard let res else {return}
            rates = res
        }
        return rates
    }
    static func priceEXchange(price:String)->String{
        var priceEx:String = ""
        var curencyType =  UserDefaults.standard.string(forKey: Constant.CURRENCY) ?? "USD"
        var rates = currencySetUp()
        print(rates)
        switch curencyType{
        case Constant.EGYPT_CURRENCY:
            priceEx = String (format: "%.2f", (Double(price) ?? 0) * (rates.EGP ?? 1) ) + " " + Constant.EGYPT_CURRENCY
        case Constant.AMERICAN_CURRENCY:
            priceEx = price + " " + Constant.AMERICAN_CURRENCY
        case Constant.EUROPE_CURRENCY:
            priceEx = String (format: "%.2f", (Double(price) ?? 0) * (rates.EUR ?? 1) ) + " " + Constant.EUROPE_CURRENCY
        case Constant.SAR_CURRENCY:
            print(price)
            priceEx = String (format: "%.2f", (Double(price) ?? 0) * (rates.SAR ?? 1) ) + " " + Constant.SAR_CURRENCY
            print(priceEx)
        case Constant.UAE_CURRENCY:
            priceEx = String (format: "%.2f", (Double(price) ?? 0) * (rates.AED ?? 1) ) + " " + Constant.UAE_CURRENCY
        default:
            print("")
        }
        return priceEx
        
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


    

