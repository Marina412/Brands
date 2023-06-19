//
//  FavsForCustomer.swift
//  YRStor
//
//  Created by Huda kamal  on 19/06/2023.
//

import Foundation

let defaults = UserDefaults.standard

class CustomerHelper {

    static func getFavForCustomers(favs : [FavProduct])-> [FavProduct]?{
        var favProducts : [FavProduct] = []
        let email = defaults.string(forKey: "email")
        for fav in favs {
            if(fav.email == email && fav.favOrShopping == Constant.IS_FAV){
                favProducts.append(fav)
            }
        }
        return favProducts
        
    }
    
    static func getCustomerCart(drafts : [FavProduct])-> FavProduct?{
        var customerDraft : FavProduct!
        let email = defaults.string(forKey: "email")
        for draft in drafts {
            if(draft.email == email && draft.favOrShopping == Constant.IS_SHOPPING_CART){
                customerDraft = draft
            }
        }
        return customerDraft
        
    }
    
}
