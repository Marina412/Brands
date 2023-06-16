//
//  CardViews.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 13/06/2023.
//

import Foundation
import UIKit

class CardViews : UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    private func initialSetup(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 10
        cornerRadius = 10
    }
}
