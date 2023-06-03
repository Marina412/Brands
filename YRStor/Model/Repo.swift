//
//  Repo.swift
//  Shopify
//
//  Created by marina on 31/05/2023.
//

import Foundation
protocol RepoProtocol{
    func getAllProducts(completion: @escaping (AllProudects?)->())
    func getAllCollections(completion: @escaping ([Collection]?)->())
}
class Repo : RepoProtocol{
    
    let networkManager : NetworkManagerProtocol?
    init(networkManager:NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    func getAllProducts(completion: @escaping (AllProudects?)->()){
        networkManager?.getDataFromApi(apiUrl: Constant.ALL_PRODUCTS_URL, val: AllProudects.self, completion: { res in
            completion(res)
        })
    }
    func getAllCollections(completion: @escaping ([Collection]?)->()){
        networkManager?.getDataFromApi(apiUrl: Constant.COLECTIONS_URL, val: Collections.self, completion: {res in
            completion(res?.collection_listings)
        })
    }
}
