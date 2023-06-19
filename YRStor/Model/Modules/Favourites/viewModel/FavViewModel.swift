//
//  FavViewModel.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import Foundation

class FavViewModel {
    
    let defaults = UserDefaults.standard
    var customerFavList : [FavProduct] = []
    var productIds : [String] = []
    var favProductsDetails: [Product] = []
    var product : LineItems = LineItems()
    
    var curencyType :String = "USD"
    var rates = Rates()
    
    let repo : RepoProtocol
    init(repo: RepoProtocol) {
        self.repo = repo
        currencySetUp()
    }
    var bindResult : (()->()) = {}
    var viewModelResult :FavProducts?{
        didSet{
            bindResult()
        }
    }
    var bindResultProducts : (()->()) = {}
    var favProductResult : AllProudects?{
        didSet{
            bindResultProducts()
        }
    }
    func currencySetUp(){
        curencyType =  UserDefaults.standard.string(forKey: Constant.CURRENCY) ?? "USD"
        repo.getCurrency{
            [weak self] res in
            guard let self else { return }
            guard let res else {return}
            self.rates = res
        }
    }
    func getAllFav(){
        repo.getAllFav { favArr in
            guard let favArr else{return}
            var productPrice = HelperFunctions.priceEXchange(curencyType: self.curencyType, price: favArr.draftOrders[0].lineItems?[0].productPrice ?? "0", rates: self.rates)
 
            var AllFav = favArr
            AllFav.draftOrders[0].lineItems?[0].productPrice = productPrice
            self.viewModelResult = AllFav
        }
    }
//    func getAllFav(){
//        repo.getAllFav { favArr in
//            guard let AllFav = favArr else{return}
//            self.viewModelResult = AllFav
//        }
//    }
    func deleteFavListInDatabase(draftId : String , indexPath : Int? ,  completion : (()->())?){
        repo.deleteFavProductListInDatabase(draftId: draftId, completion: { [weak self] in
            guard let index = indexPath else {return}
            //self?.customerFavList.remove(at: index)
            completion?()
            
            
        })
        
    }
    
    func getFavProducts(ids : String){
        repo.getAllFavProducts(ids: ids) { res in
            guard let allFavProducts = res else {return}
            self.favProductResult = allFavProducts
        }
    }
    
    func saveFavProductToDatabase(favProduct : FavProduct){
            repo.saveFavProductToDatabase(favProduct: favProduct)
        }
}
