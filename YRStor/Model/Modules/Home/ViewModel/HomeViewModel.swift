//
//  HomeViewModel.swift
//  Shopify
//
//  Created by marina on 31/05/2023.
//

import Foundation
class HomeViewModel{
    let repo:RepoProtocol
    let defaults = UserDefaults.standard
    var brands:[Collection]=[]
    var cupons:[String]!
    init(repo:RepoProtocol) {
        self.repo = repo
        self.cupons = defaults.stringArray(forKey: "SavedArray")
    }
    func getAllCategoriesFromApi(completion: @escaping ()->()){
        repo.getAllCollections { [weak self] collectionsResult in
           // guard let self else { return }
            guard let collectionsResult else {return}
            for brand in collectionsResult[4...15] {
                self?.brands.append(brand)
            }
            completion()
        }
    }
    
    func removeItemFromCupon(index:Int){
        cupons.remove(at: index)
        defaults.set(cupons, forKey: "SavedArray")
    }
    
    func loadCupon(){
        self.cupons = defaults.stringArray(forKey: "SavedArray")
    }
    
}

