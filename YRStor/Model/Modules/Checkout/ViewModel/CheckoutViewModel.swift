//
//  CheckoutViewModel.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 15/06/2023.
//

import Foundation

class CheckoutViewModel {
    let date = Date()
    
   }
extension Date {
    static func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {
            return nowUTC
        }
        return localDate
    }
}

