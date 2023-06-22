//
//  MockNetworkManager.swift
//  ApiTestTests
//
//  Created by Huda kamal  on 11/06/2023.
//


import Foundation
import Alamofire
@testable import YRStor
class MockNetworkManager {

    var mockAllProductsResponse = ""
    
}

extension MockNetworkManager : NetworkManagerProtocol {
    func saveCustomerInDatabase(apiUrl: String, customer: YRStor.Customer, completion: @escaping (YRStor.CustomerResponse?) -> ()) {
        
    }
    
    func saveFavProductInDatabase(apiUrl: String, favProduct: YRStor.FavProduct) {
        
    }
    
    func deleteFavProductListInDatabase(draftId: String, completion: @escaping () -> ()) {
        
    }
    
    func getAllAddressFromApi<T>(apiUrl: String, val: T.Type, completion: @escaping (T?) -> ()) where T : Decodable {
        
    }
    
    func saveAddressInDatabase(apiUrl: String, address: YRStor.CustomerAddress) {
        
    }
    
    func deleteAddressInDatabase(customerId: Int, addressId: Int) {
        
    }
    
    func editShoppingCartInDatabase(apiUrl: String, draftOrder: YRStor.Drafts, draftId: String) {
        
    }
    
    func saveShoppingCartInDataBase(apiUrl: String, favProduct: YRStor.FavProduct, completion: @escaping (YRStor.Drafts?) -> ()) {
        
    }
    
    func postOrder(apiUrl: String, order: YRStor.PostOrders, completion: @escaping (YRStor.PostOrders?) -> ()) {
        
    }
    
    func postOrder(apiUrl: String, order: YRStor.Order, completion: @escaping (String?) -> ()) {
        print("")
    }
    
   
    
    func getDataFromApi<T>(apiUrl: String, val: T.Type, completion: @escaping (T?) -> ()) where T : Decodable {
        let data = Data(mockAllProductsResponse.utf8)
        do {
            let jsonData = try JSONDecoder().decode(T.self, from: data)
            completion(jsonData)
        } catch let decodingError {
            
        }

    }
 
}

