//
//  Currency.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 05/06/2023.
//

import Foundation

struct ConcurrencyModel: Codable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: Countries
}

struct Countries: Codable {
    let EGP: Double
    let USD: Double
    let EUR: Double
    let SAR: Double
    let AED: Double
    
}

struct Currency{
    let flagImage:String
    let currencyName:String
    var selected:Bool
}
