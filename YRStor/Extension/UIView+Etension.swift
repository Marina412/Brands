//
//  UIView+Etension.swift
//  Brandy
//
//  Created by Aya Mohamed Ahmed on 01/06/2023.
//

import Foundation
import UIKit

extension UIView{
    @IBInspectable var cornerRadius:CGFloat{
        get{return cornerRadius}
        set{ self.layer.cornerRadius=newValue}
    }
    
    static func elevationCardView(view : UIView){
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.9
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5
        
  
    }
}



