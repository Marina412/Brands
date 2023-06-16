//
//  ShoppingCartViewModel.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 16/06/2023.
//

import Foundation
class ShoppingCartViewModel{
    var draft = Drafts(draftOrder: FavProduct())
    var resDraft : FavProduct!
    var products : [LineItems] = []
    var draftId = ""
    let defaults = UserDefaults.standard
    var repo : RepoProtocol
    var bindResult : (()->()) = {}
    var viewModelResult :FavProduct!{
        didSet{
            bindResult()
        }
    }
    
    init(repo: RepoProtocol) {
        self.repo = repo
    }
    
    func saveShoppingCartInDatabase(favProduct: FavProduct){
        repo.saveShoppingCartInDatabase(apiUrl: Constant.POST_FAV_PRODUCT_URL, favProduct: favProduct) { res in
            guard let draft = res?.draftOrder else {return}
            self.viewModelResult = draft
        }
        
    }
    
    func editShoppingCart(draftOrder: Drafts, draftId : String){
        repo.editShoppingCartInDatabase(draftOrder: draftOrder, draftId: draftId)
    }
    func deleteFavListInDatabase(draftId : String , indexPath : Int? ,  completion : (()->())?){
        repo.deleteFavProductListInDatabase(draftId: draftId, completion: { [weak self] in
//            guard let index = indexPath else {return}
//            self?.resDraft.lineItems?[index]
            completion?()
            
            
        })
    
    }
    
}
