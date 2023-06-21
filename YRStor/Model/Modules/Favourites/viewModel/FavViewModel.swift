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
    
    func getAllFav(){
        repo.getAllFav { favArr in
            guard let favArr else{return}
            self.viewModelResult = favArr
        }
    }
    
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
