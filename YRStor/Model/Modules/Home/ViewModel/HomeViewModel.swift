//
//  HomeViewModel.swift
//  Shopify
//
//  Created by marina on 31/05/2023.
//

import Foundation
class HomeViewModel{
    let repo:RepoProtocol
    var brands:[Collection]=[]
    var cupons:[String] = ["15%","25%","50%"]
    init(repo:RepoProtocol) {
        self.repo = repo
    }
    func getAllCategoriesFromApi(completion: @escaping ()->()){
        repo.getAllCollections { [weak self] collectionsResult in
            guard let self else { return }
            guard let collectionsResult else {return}
            for brand in collectionsResult[4...15] {
                self.brands.append(brand)
            }
            completion()
        }
    }
}
