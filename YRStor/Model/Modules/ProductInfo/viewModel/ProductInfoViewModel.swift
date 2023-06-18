//
//  ProductInfoViewModel.swift
//  YRStor
//
//  Created by Huda kamal  on 18/06/2023.
//

import Foundation

class ProductInfoViewModel{
    
   
    var productImages : [ProductImage]!
    var draftId :String?
    var favProduct : FavProduct?
    var lineItems : [LineItems]?
    let defaults = UserDefaults.standard
    
    var draft : FavProduct = FavProduct()
    
    var repo:RepoProtocol
    
    init(repo: RepoProtocol) {
        
        self.repo = repo
    }
}
