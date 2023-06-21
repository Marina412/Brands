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
    var curencyType :String = "USD"
    var rates = Rates()
    init(repo: RepoProtocol) {
        self.repo = repo
    }
    func updateQuantity(draftOrder: Drafts, draftId : String){
        repo.editShoppingCartInDatabase(draftOrder: draftOrder, draftId: draftId)
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
}
