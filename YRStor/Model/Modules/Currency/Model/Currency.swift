//
//  Currency.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 05/06/2023.
//

import Foundation

struct Exchange: Codable {
    var success: Bool?
    var timestamp: Int?
    var base: String?
    var date: String?
    var rates: Rates?
}
struct Rates: Codable {
    var EGP: Double?
    var USD: Double?
    var EUR: Double?
    var SAR: Double?
    var AED: Double?
}


struct Currency{
    let flagImage:String
    let currencyName:String
    var selected:Bool
}
