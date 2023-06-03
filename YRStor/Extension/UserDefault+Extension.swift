//
//  UserDefault+Extension.swift
//  Brandy
//
//  Created by Aya Mohamed Ahmed on 01/06/2023.
//

import Foundation

extension UserDefaults{
    private enum UserDefaultKey: String{
        case onboarded
    }
    var onboarded: Bool {
        get{
            bool(forKey: UserDefaultKey.onboarded.rawValue)
        }
        set{
            setValue(newValue, forKey: UserDefaultKey.onboarded.rawValue)
        }
    }
}
