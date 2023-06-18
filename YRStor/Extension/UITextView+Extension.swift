//
//  UITextView+Extension.swift
//  YRStor
//
//  Created by Huda kamal  on 18/06/2023.
//

import Foundation
import UIKit

extension UITextView{
    static func textViewStyle(textView: UITextView){
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 0.2
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.shadowColor = UIColor.gray.cgColor
        textView.layer.shadowOffset = CGSize(width: 0, height: 2)
        textView.layer.shadowOpacity = 0.5
        textView.layer.shadowRadius = 30
        
    }
}
