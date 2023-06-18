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
    func saveCustomerInDatabase(apiUrl : String ,customer : Customer, completion : @escaping(CustomerResponse?)->())
    func saveFavProductInDatabase(apiUrl : String ,favProduct : FavProduct)
    func deleteFavProductListInDatabase(draftId : String,completion: @escaping ()->())
    func getAllAddressFromApi<T: Decodable>(apiUrl: String, val: T.Type,completion: @escaping (T?)->())
    func saveAddressInDatabase(apiUrl : String ,address : CustomerAddress)
    func deleteAddressInDatabase(customerId : Int , addressId : Int)
    func editShoppingCartInDatabase(apiUrl: String, draftOrder: Drafts , draftId : String)
    func saveShoppingCartInDataBase(apiUrl: String,favProduct: FavProduct,completion: @escaping (Drafts?)->())
    //func postOrder(apiUrl: String,order:Order,completion: @escaping (String?)->())
    
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
    
    func saveCustomerInDatabase(apiUrl : String , customer : Customer , completion : @escaping(CustomerResponse?)->()) {
        
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
        
        AF.request(request).responseDecodable(of: CustomerResponse.self) { (response) in
            print("--- API Call Details ---")
            print("Endpoint:", newURL)
            print("Request Body:", parameters)
            if let responseData = response.data, let responseString = String(data: responseData, encoding: .utf8) {
                print("Response:", responseString)
            } else {
                print("Response: No Data")
            }
            print("-----------------------")
            switch response.result {
            case .success(let data):
                print("--- Success ---")
                print(data)
                completion(data)
                
            case .failure(let error):
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
                "email": favProduct.email,"note" : favProduct.favOrShopping,
                "line_items": [
                    [
                        "title": favProduct.lineItems?[0].productTitle,
                        "sku": favProduct.lineItems?[0].productId,
                        "price": favProduct.lineItems?[0].productPrice,
                        "quantity": favProduct.lineItems?[0].quantity,
                        
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
    func deleteFavProductListInDatabase(draftId : String,completion: @escaping ()->()) {
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
                completion()
            case .failure(let error):
                // Handle the failure response
                print("--- Failure ---")
                print(error)
            }
        }
    }
    
    
    func getAllAddressFromApi<T>(apiUrl: String, val: T.Type, completion: @escaping (T?) -> ()) where T : Decodable {
        let url = URL(string: apiUrl)
        guard let newURL = url else{
            return
        }
        AF.request(newURL)
            .responseDecodable(of: T.self) { (response) in
                switch response.result {
                case .success(let jsonData):
                    completion(jsonData)
                    
                case .failure(_):
                    completion(nil)
                    
                }
            }
    }
    
    
    func saveAddressInDatabase(apiUrl: String, address: CustomerAddress) {
        let url = URL(string: apiUrl)
        guard let newURL = url else{
            return
        }
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(address)
        let parameters = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        
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
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func deleteAddressInDatabase(customerId : Int , addressId : Int) {
        print("deleteNetwork")
        let url = URL(string:Constant(customerId: customerId, addressId: addressId ).DELETE_ADDRESS)
        
        let headers = [
            "Content-Type": "application/json"
        ]
        guard let url else{return}
        var request = URLRequest(url:url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.allHTTPHeaderFields = headers
        request.httpShouldHandleCookies = false
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        AF.request(request).validate().response{ response in
            print("Endpoint:",url)
            if let responseData = response.data, let responseString = String(data: responseData, encoding: .utf8) {
                print("Response:", responseString)
            } else {
                print("Response: No Data")
            }
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    func editShoppingCartInDatabase(apiUrl: String, draftOrder: Drafts , draftId : String) {
        // var urlString = apiUrl + draftId + ".json"
        let url = URL(string: apiUrl + draftId + ".json" )
        
        print(url)
        guard let newURL = url else{
            return
        }
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(draftOrder)
        let parameters = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let headers = [
            "Content-Type": "application/json"
        ]
        
        var request = URLRequest(url: newURL)
        request.httpMethod = HTTPMethod.put.rawValue
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
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    func saveShoppingCartInDataBase(apiUrl: String,favProduct: FavProduct,completion: @escaping (Drafts?)->()) {
        let url = URL(string: apiUrl)
        
        guard let newURL = url else{
            return
        }
        
        let parameters: [String: Any] = [
            "draft_order": [
                "email": favProduct.email,
                "note" : favProduct.favOrShopping ,
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
        
        AF.request(request).responseDecodable(of: Drafts.self) { (response) in
            switch response.result {
            case .success(let data):
                // print(data)
                completion(data)
            case .failure(let error):
                
                print("API request failed:", error)
            }
        }
    }
}
    extension NetworkManager{
//    func postOrder(apiUrl: String,order:Order,completion: @escaping (String?)->()){
//        let url = URL(string: apiUrl)
//        guard let url else{return}
//        AF.request(url,method: .post,parameters: HelperFunctions.orderToParameters(order: order),encoding: JSONEncoding.default, headers: HTTPHeaders([Constant.HEADER])).validate().response{
//            response in
//            switch response.result {
//            case .success(_):
//                if let responseData = response.data, let responseString = String(data: responseData, encoding: .utf8) {
//                    completion(responseString)
//                } else {
//                    print("Response: No Data")
//                }
//            case .failure(let error):
//                print("error here \n \n \(String(describing:error)) \n\n ")
//                completion(nil)
//            }
//        }
//    }
    
}





