//
//  FavsForCustomer.swift
//  YRStor
//
//  Created by Huda kamal  on 19/06/2023.
//

import Foundation

let defaults = UserDefaults.standard
var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))

class CustomerHelper {

    static func getFavForCustomers(favs : [FavProduct])-> FavProduct?{
        var favProducts : FavProduct = FavProduct()
        let email = defaults.string(forKey: "email")
        for fav in favs {
            if(fav.email == email && fav.favOrShopping == Constant.IS_FAV){
                favProducts = fav
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
    
    static func checkCustomerCart(){
        let email = cartViewModel.defaults.string(forKey: "email")
        var draftId : String = ""
        var isNew = false
        var isExists = false
        var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
        favViewModel.getAllFav()
        favViewModel.bindResult = {() in
            let res = favViewModel.viewModelResult
            guard var allDrafts = res?.draftOrders else {return}
            if allDrafts.count == 0 {
                self.addNewCart()
            }
            else{
                for draft in allDrafts{
                    if(draft.email == email && draft.favOrShopping == Constant.IS_SHOPPING_CART){
                        cartViewModel.resDraft = draft
                        isExists = true
                        
                    }
                    else{
                        isNew = true
                    }
                }
                if(isExists){
                    
                    putInCart(draft: cartViewModel.resDraft ?? FavProduct())
                }
                if(isNew && isExists == false){
                    self.addNewCart()
                }
                
            }
        }
        
    }
    
    
   static func putInCart(draft : FavProduct){
        var newDraft = draft
        cartViewModel.draftId = String(draft.draftId ?? 0)
        var newProduct = cartViewModel.product
        newDraft.lineItems?.append(newProduct)
        var draft = Drafts(draftOrder: newDraft)
        cartViewModel.editShoppingCart(draftOrder:draft, draftId: cartViewModel.draftId ?? "")
        print("edit existing draftOrder  \(draft.draftOrder.lineItems?.count)")
        
    }
    
    
   static func addNewCart(){
        
        let email = cartViewModel.defaults.string(forKey: "email")
        var lineItems = [cartViewModel.product]
        var draft = FavProduct(email: email,lineItems: lineItems,favOrShopping: Constant.IS_SHOPPING_CART)
        cartViewModel.saveShoppingCartInDatabase(favProduct: draft)
        cartViewModel.bindResult = {() in
            let res = cartViewModel.viewModelResult
            guard let draftOrder = res else {return}
        }
        
        
    }
    
}
