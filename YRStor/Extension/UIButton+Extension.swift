//
//  UIButton+Extension.swift
//  YRStor
//
//  Created by Huda kamal  on 18/06/2023.
//

import Foundation
import UIKit

extension UIButton{
    
    static func elevationBtn(button: UIButton){
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
    }
}
