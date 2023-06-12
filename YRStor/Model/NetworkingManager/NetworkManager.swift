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
    func saveCustomerInDatabase(apiUrl : String ,customer : Customer)
    func saveFavProductInDatabase(apiUrl : String ,favProduct : FavProduct)
    func deleteFavProductListInDatabase(draftId : String)
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
    
    func saveCustomerInDatabase(apiUrl : String , customer : Customer) {
        
        let url = URL(string: apiUrl)
        
        guard let newURL = url else{
            return
        }
        
        let parameters: [String: Any] = [
            "customer": [
                "first_name": customer.firstName,
                "last_name": customer.lastName,
                "email": customer.email,
                "note": customer.password,
                "phone": customer.phone
            ]
        ]
        let headers = [
            "Content-Type": "application/json"
        ]
        
        var request = URLRequest(url: newURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.allHTTPHeaderFields = headers
        request.httpShouldHandleCookies = false
        
        AF.request(request).validate().response{ response in
            print("--- API Call Details ---")
            print("Endpoint:", newURL)
            print("Request Body:", parameters)
            if let responseData = response.data, let responseString = String(data: responseData, encoding: .utf8) {
                print("Response:", responseString)
            } else {
                print("Response: No Data")
            }
            print("-----------------------")
            
            // Handle the response
            switch response.result {
            case .success(let value):
                // Handle the success response
                print("--- Success ---")
                print(value)
            case .failure(let error):
                // Handle the failure response
                print("--- Failure ---")
                print(error)
            }
        }
    }
    func saveFavProductInDatabase(apiUrl : String ,favProduct: FavProduct) {
        
        let url = URL(string: apiUrl)
        
        guard let newURL = url else{
            return
        }
        
        let parameters: [String: Any] = [
            "draft_order": [
                "email": favProduct.email,
                "line_items": [
                    [
                        "title": favProduct.lineItems?[0].productTitle,
                        "sku": favProduct.lineItems?[0].productId,
                        "price": favProduct.lineItems?[0].productPrice,
                        "quantity": favProduct.lineItems?[0].quantity
                    ]
                ]
            ]
        ]
        let headers = [
            "Content-Type": "application/json"
        ]
        
        var request = URLRequest(url: newURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers
        request.httpShouldHandleCookies = false
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        AF.request(request).validate().response{ response in
            print("--- API Call Details ---")
            print("Endpoint:", newURL)
            print("Request Body:", parameters)
            if let responseData = response.data, let responseString = String(data: responseData, encoding: .utf8) {
                print("Response:", responseString)
            } else {
                print("Response: No Data")
            }
            print("-----------------------")
            
            // Handle the response
            switch response.result {
            case .success(let value):
                // Handle the success response
                print("--- Success ---")
                print(value)
            case .failure(let error):
                // Handle the failure response
                print("--- Failure ---")
                print(error)
            }
        }
    }
    
    func deleteFavproductUrl(draftId : String )-> String{
        
        let url = "https://3bb29754b8cff5196f1bca64f0d63ddc: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@mad-ism-43-2.myshopify.com/admin/api/2023-04/draft_orders/\(draftId).json"
        
        return url
    }
    
    func deleteFavProductListInDatabase(draftId : String) {
        let url = URL(string: deleteFavproductUrl(draftId: draftId))
        
        guard let newURL = url else{
            return
        }
        let headers = [
            "Content-Type": "application/json"
        ]
        
        var request = URLRequest(url: newURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.allHTTPHeaderFields = headers
        request.httpShouldHandleCookies = false
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        AF.request(request).validate().response{ response in
            print("--- API Call Details ---")
            print("Endpoint:", newURL)
            if let responseData = response.data, let responseString = String(data: responseData, encoding: .utf8) {
                print("Response:", responseString)
            } else {
                print("Response: No Data")
            }
            print("-----------------------")
            
            // Handle the response
            switch response.result {
            case .success(let value):
                // Handle the success response
                print("--- Success ---")
                print(value)
            case .failure(let error):
                // Handle the failure response
                print("--- Failure ---")
                print(error)
            }
        }
    }
}


