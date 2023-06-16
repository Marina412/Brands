//
//  Customer.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import Foundation

struct AllCustomers : Decodable{
    let customers : [Customer]
}
struct Customer : Decodable{
    var id : Int?
    var firstName : String?
    var lastName : String?
    var email : String?
    var password: String?
    var password_confirmation : String?
    var phone : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
       case password = "note"
        case phone = "phone"
    
        
    }
}
