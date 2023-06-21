//
//  ShoppingCellViewModel.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 16/06/2023.
//

import Foundation
class ShoppingCellViewModel{
    
    var stepperAction : ((Double )->())?
    let repo : RepoProtocol
    init(repo: RepoProtocol) {
        self.repo = repo
    }
    func updateQuantity(draftOrder: Drafts, draftId : String){
        repo.editShoppingCartInDatabase(draftOrder: draftOrder, draftId: draftId)
    }

}
