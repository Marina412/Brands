//
//  Repo.swift
//  Shopify
//
//  Created by marina on 31/05/2023.
//

import Foundation
protocol RepoProtocol{
    func postOrderToApi(order: Order)
    func getAllProducts(completion: @escaping ([Product]?)->())
    func getAllCollections(completion: @escaping ([Collection]?)->())
    func getProductsByCollectionId(collectionId:Int ,completion: @escaping ([Product]?)->())
    func getAllProductsPrice(productIds: [Int] , completion: @escaping ([Product]?)->())
    
    func saveCustomerToDatabas(customer : Customer , completion: @escaping (CustomerResponse?) -> ())
    func getCustomersFromDatabase(completion: @escaping (AllCustomers?)->())
    
    func saveFavProductToDatabase(favProduct : FavProduct)
    func getAllFav(completion: @escaping (FavProducts?)->())
    func deleteFavProductListInDatabase(draftId: String,completion: @escaping ()->())
    func getAllFavProducts( ids : String , completion: @ escaping(AllProudects?)->())
    
    func saveAddressToDatabase(address:CustomerAddress, customerId : String)
    func getAllAddressFromDatabase(customerId:String,completion: @escaping (AllAddress?)->())
    func getONEAddressFromDatabase(customerId:String,completion: @escaping (AllAddress?)->())
    
    func deleteAddreesInDatabase(customerId : Int , addressId : Int)
    func editShoppingCartInDatabase(draftOrder: Drafts,draftId : String)
    func saveShoppingCartInDatabase(apiUrl: String, favProduct: FavProduct, completion: @escaping (Drafts?) -> ())
    
    func getCurrency(completion: @escaping (Rates?)->())
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
    
    func saveCustomerToDatabas(customer: Customer, completion: @escaping (CustomerResponse?) -> ()) {
        networkManager?.saveCustomerInDatabase(apiUrl: Constant.POST_CUSTOMER_URL,customer: customer, completion: { res in
            completion(res)
            
        })
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
    func deleteFavProductListInDatabase(draftId: String,completion: @escaping ()->()) {
        networkManager?.deleteFavProductListInDatabase(draftId: draftId, completion: completion)
    }
    
    
    func getAllFavProducts( ids : String = "0" , completion: @escaping(AllProudects?)->()){
        networkManager?.getDataFromApi(apiUrl : Constant.PRODUCTS_BY_ID_URL + ids  , val: AllProudects.self, completion: { res in
            completion(res)
        })
    }
    
    func saveAddressToDatabase(address: CustomerAddress,customerId:String) {
        networkManager?.saveAddressInDatabase(apiUrl: Constant.POST_ADDRESS_URL+customerId+"/addresses.json", address:address)

    }
    
    func getAllAddressFromDatabase(customerId:String,completion: @escaping (AllAddress?) -> ()) {
        networkManager?.getAllAddressFromApi(apiUrl: Constant.POST_ADDRESS_URL+customerId+"/addresses.json", val:AllAddress.self, completion: { res in
            completion(res)
        })
    }
    func getONEAddressFromDatabase(customerId:String,completion: @escaping (AllAddress?) -> ()) {
        networkManager?.getAllAddressFromApi(apiUrl: Constant.POST_ADDRESS_URL+customerId+"/addresses.json"+"?limit=1", val:AllAddress.self, completion: { res in
                   completion(res)
               })
       }
    
    func deleteAddreesInDatabase(customerId : Int , addressId : Int) {
        networkManager?.deleteAddressInDatabase(customerId: customerId, addressId: addressId)
    }
    func editShoppingCartInDatabase(draftOrder: Drafts,draftId : String) {
        networkManager?.editShoppingCartInDatabase(apiUrl: Constant.PUT_FAV_PRODUCT_URL, draftOrder: draftOrder, draftId: draftId)
    }
    
    func saveShoppingCartInDatabase(apiUrl: String, favProduct: FavProduct, completion: @escaping (Drafts?) -> ()) {
        networkManager?.saveShoppingCartInDataBase(apiUrl: apiUrl, favProduct: favProduct, completion: { res in
            completion(res)
        })
    }
    func getCurrency(completion: @escaping (Rates?)->()){
        networkManager?.getDataFromApi(apiUrl: Constant.CURRENCY_EXCHANGE_API_URL +  Constant.CURRENCY_EXCHANGE_API_KEY, val: Exchange.self, completion: { res in
            completion(res?.rates)
        })
    }
    func postOrderToApi(order: Order){
        networkManager?.postOrder(apiUrl: Constant.POST_ORDERS_URL, order: order){
            res in
            print(res)
        }
    }
}
