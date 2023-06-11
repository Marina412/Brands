//
//  CurrencyViewModel.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 05/06/2023.
//

import Foundation
class CurrencyViewModel{
    var currencyLists: [Currency] = [
        Currency(flagImage:"EgyptFlag" ,currencyName: "Egyptian Pound", selected: false),
        Currency(flagImage:"AmericaFlag",currencyName: "Dollar", selected: false),
        Currency(flagImage:"EuropeFlag",currencyName: "Euro", selected: false),
        Currency(flagImage:"SARFlag",currencyName: "SAR Riyal", selected: false),
        Currency(flagImage:"UAEFlag",currencyName: "UAE Dirham", selected: false)]
    
}

