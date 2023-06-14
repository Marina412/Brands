//
//  FavViewModel.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import Foundation

class FavViewModel {
    
    let repo : RepoProtocol
    init(repo: RepoProtocol) {
        self.repo = repo
    }
    var bindResult : (()->()) = {}
    var viewModelResult :FavProducts!{
        didSet{
            bindResult()
        }
    }
    var bindResultProducts : (()->()) = {}
    var favProductResult : AllProudects!{
        didSet{
            bindResultProducts()
        }
    }
   
    func saveFavProductToDatabase(favProduct : FavProduct){
        repo.saveFavProductToDatabase(favProduct: favProduct)
    }
  
    func deleteFavListInDatabase(draftId : String ){
        repo.deleteFavProductListInDatabase(draftId: draftId)
    }
    func getAllFav(){
        repo.getAllFav { favArr in
            guard let AllFav = favArr else{return}
            self.viewModelResult = AllFav
        }
    }
    
    func getFavProducts(ids : String){
        repo.getAllFavProducts(ids: ids) { res in
            guard let allFavProducts = res else {return}
            self.favProductResult = allFavProducts
        }
    }
}
