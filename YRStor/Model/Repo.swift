//
//  Repo.swift
//  Shopify
//
//  Created by marina on 31/05/2023.
//

import Foundation
protocol RepoProtocol{
    func getAllProducts(completion: @escaping ([Product]?)->())
    func getAllCollections(completion: @escaping ([Collection]?)->())
    func getProductsByCollectionId(collectionId:Int ,completion: @escaping ([Product]?)->())
    func getAllProductsPrice(productIds: [Int] , completion: @escaping ([Product]?)->())
    
    func saveCustomerToDatabas(customer : Customer)
    func getCustomersFromDatabase(completion: @escaping (AllCustomers?)->())

    func saveFavProductToDatabase(favProduct : FavProduct)
    func getAllFav(completion: @escaping (FavProducts?)->())
    func deleteFavProductListInDatabase(draftId : String)
    func getAllFavProducts( ids : String , completion: @ escaping(AllProudects?)->())
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
    func getAllProducts(completion: @escaping ([Product]?)->()){
        networkManager?.getDataFromApi(apiUrl: Constant.ALL_PRODUCTS_URL, val: AllProudects.self, completion: { res in
            completion(res?.products)
        })
    }
    func getAllCollections(completion: @escaping ([Collection]?)->()){
        networkManager?.getDataFromApi(apiUrl: Constant.COLECTIONS_URL, val: Collections.self, completion: {res in
            completion(res?.collection_listings)
        })
    }
    
    func getProductsByCollectionId(collectionId:Int ,completion: @escaping ([Product]?)->()){
        networkManager?.getDataFromApi(apiUrl: Constant(collectionId: collectionId).PRODUCT_BY_COLLECTION_ID_URL ,val: AllProudects.self, completion: { res in
            completion(res?.products)
        })
    }
    func getAllProductsPrice(productIds: [Int] , completion: @escaping ([Product]?)->()){
        networkManager?.getDataFromApi(apiUrl: Constant(productIds:productIds).PRODUCT_PRICE_URL ,val: AllProudects.self, completion: { res in
            completion(res?.products)
        })
    }
    
    func saveCustomerToDatabas(customer: Customer) {
        networkManager?.saveCustomerInDatabase(apiUrl: Constant.POST_CUSTOMER_URL,customer: customer)
    }
    func getCustomersFromDatabase(completion: @escaping (AllCustomers?)->()){
        networkManager?.getDataFromApi(apiUrl: Constant.GET_CUSTOMERS_URL, val:AllCustomers.self, completion: { res in
            completion(res)
        })
    
    }
    func saveFavProductToDatabase(favProduct: FavProduct) {
        networkManager?.saveFavProductInDatabase(apiUrl: Constant.POST_FAV_PRODUCT_URL, favProduct: favProduct)
    }
    
    func getAllFav(completion: @escaping (FavProducts?)->()){
        networkManager?.getDataFromApi(apiUrl: Constant.GET_ALL_FAV_URL, val: FavProducts.self, completion: {res in
            guard let result = res else {return}
            completion(result)
        })
    }
    func deleteFavProductListInDatabase(draftId: String) {
        networkManager?.deleteFavProductListInDatabase(draftId: draftId)
    }
    
    func getAllFavProducts( ids : String = "0" , completion: @escaping(AllProudects?)->()){
        networkManager?.getDataFromApi(apiUrl : Constant.PRODUCTS_BY_ID_URL + ids  , val: AllProudects.self, completion: { res in
            completion(res)
        })
    }
}
