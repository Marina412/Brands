//
//  HelperFunction.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import Foundation
import UIKit

func circleImage(image : UIImageView){
        image.layer.cornerRadius = image.frame.height / 2
        image.clipsToBounds = true
    }
    
//    func showAlertsWithOkBtn(message:String){
//        let alert = UIAlertController(title: "Shopify", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }

