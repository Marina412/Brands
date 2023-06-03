//
//  UIViewController+Extension.swift
//  Brandy
//
//  Created by Aya Mohamed Ahmed on 01/06/2023.
//

import UIKit
import Foundation

extension UIViewController{
    static var identifier: String{
        return String(describing: self)
    }
    static func instantiate() -> Self{
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
}
