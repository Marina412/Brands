//
//  UserDefaults+Extension.swift
//  YRStor
//
//  Created by marina on 19/06/2023.
//

import Foundation
extension UserDefaults{
    @objc dynamic var shoppingBag: Int {
        get { self.integer(forKey: #function) ?? 0}
        set { self.setValue(newValue, forKey: #function) }
    }
}

