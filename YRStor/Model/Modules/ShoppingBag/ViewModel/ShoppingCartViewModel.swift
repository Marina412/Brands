//
//  ShoppingCartViewModel.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 16/06/2023.
//

import Foundation
class ShoppingCartViewModel{
    var draft = Drafts(draftOrder: FavProduct())
    var resDraft : FavProduct?
    var products : [LineItems] = []
    var draftId = ""
    var productIds : [String] = []
    let defaults = UserDefaults.standard
    var cartProductsDetails : [Product] = []
    var product : LineItems = LineItems()
    
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
        let products = draftOrder.draftOrder.lineItems?.reduce(into: [LineItems]()) { result, item in
            if let index = result.firstIndex(where: { $0.productId == item.productId }) {
                result[index].quantity += item.quantity
            } else {
                result.append(item)
            }
        }
        print("line items before filter \(draftOrder.draftOrder.lineItems)")
        print("line items after filter \(products)")
        var newDraft = draftOrder
        newDraft.draftOrder.lineItems = products
        
        repo.editShoppingCartInDatabase(draftOrder: newDraft, draftId: draftId)
    }
    func deleteFavListInDatabase(draftId : String , indexPath : Int? ,  completion : (()->())?){
        repo.deleteFavProductListInDatabase(draftId: draftId, completion: { [weak self] in
//            guard let index = indexPath else {return}
//            self?.resDraft.lineItems?[index]
            completion?()
            
            
        })
    
    }
    
}
