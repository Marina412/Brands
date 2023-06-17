//
//  MockRepo.swift
//  YRStorTests
//
//  Created by marina on 14/06/2023.
//

import Foundation
@testable import YRStor

class MockRepo : RepoProtocol {
    
    
    let networkManager: NetworkManagerProtocol?
    
    init(mockNetworkManager: NetworkManagerProtocol?) {
        self.networkManager = mockNetworkManager
    }
    
    func getAllProducts(completion: @escaping ([YRStor.Product]?) -> ()) {
        let products = [Product(id: 1, vendor: "adidas"),Product(id: 2, vendor: "nike"),Product(id: 3, vendor: "adidas"),Product(id: 4, vendor: "nike"),Product(id: 5, vendor: "adidas"),Product(id: 6, vendor: "nike"),Product(id: 7, vendor: "adidas"),Product(id: 8, vendor: "nike"),Product(id: 9, vendor: "adidas"),Product(id: 10, vendor: "nike"),Product(id: 11, vendor: "adidas"),Product(id: 12, vendor: "nike") ,Product(id: 13, vendor: "adidas"),Product(id: 14, vendor: "nike"),Product(id: 15, vendor: "adidas"),Product(id: 16, vendor: "nike"),Product(id: 16, vendor: "nike") ]
        completion(products)
    }
    
    func getAllCollections(completion: @escaping ([YRStor.Collection]?) -> ()) {
        let collections = [Collection(collectionID: 1,title: "a"),Collection(collectionID: 2,title: "a"),Collection(collectionID: 3,title: "a"),Collection(collectionID: 4,title: "a"),Collection(collectionID: 5,title: "a")]
        completion(collections)
    }
    
    func getProductsByCollectionId(collectionId: Int, completion: @escaping ([YRStor.Product]?) -> ()) {
        let products = [Product(id: 1, vendor: "adidas"),Product(id: 2, vendor: "nike"),Product(id: 3, vendor: "adidas"),Product(id: 4, vendor: "nike"),Product(id: 5, vendor: "adidas"),Product(id: 6, vendor: "nike")]
        completion(products)
    }
    
    func getAllProductsPrice(productIds: [Int], completion: @escaping ([YRStor.Product]?) -> ()) {
        let products = [Product(id: 1, vendor: "adidas",variants: [Variant(price: "50")]),Product(id: 2, vendor: "nike"),Product(id: 3, vendor: "adidas",variants: [Variant(price: "50")]),Product(id: 4, vendor: "nike"),Product(id: 5, vendor: "adidas"),Product(id: 6, vendor: "nike",variants: [Variant(price: "50")])]
        completion(products)
    }
    
    func getAllOrders(completion: @escaping ([YRStor.Order]?) -> ()) {
        let order = [Order(created_at: "",currency: "",email: "marina",current_total_price: "100", line_items: [OrderProductItems(price: "",product_id: 1,quantity: 2,title: "",sku: "")] ,reference: "",note: "")]
        completion(order)
    }
    func getCurrency(completion: @escaping (YRStor.Rates?) -> ()) {
        completion(Rates(EGP: 10.00,USD: 40.0, EUR: 50.0, SAR: 30.0, AED: 20.0 ))
    }
    
}
