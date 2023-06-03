//
//  NetworkManager.swift
//  Shopify
//
//  Created by marina on 31/05/2023.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol{
    func getDataFromApi<T: Decodable>(apiUrl: String, val: T.Type,completion: @escaping (T?)->())
}

class NetworkManager : NetworkManagerProtocol{
    func getDataFromApi<T: Decodable>(apiUrl: String,val: T.Type,completion: @escaping (T?)->()) {
        let url = URL(string: apiUrl)
        
        guard let newURL = url else{
            return
        }
        AF.request(newURL)
            .responseDecodable(of: T.self) { (response) in
                switch response.result {
                case .success(let jsonData):
                    completion(jsonData)
                    
                case .failure(let error):
                    print("error here \n \n \(String(describing: error)) \n\n ")
                    completion(nil)
                }
            }
    }
}


