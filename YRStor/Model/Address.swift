//
//  Address.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 15/06/2023.
//

import Foundation

struct AllAddress: Codable {
    var addresses: [Address]?
}

struct CustomerAddress : Codable{
    var customer_address : Address
    
    enum CodingKeys: String, CodingKey {
            case customer_address = "customer_address"
        }
}
struct Address:Codable{
    var id:Int?
    var customer_id: Int?
    var address1: String?
    var country: String?
    var city: String?
    var phone:String?
    enum coding: String, CodingKey {
        case address_id = "id"
        case address1 = "address1"
    }
}

