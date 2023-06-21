//
//  UiKitHelper.swift
//  YRStor
//
//  Created by Huda kamal  on 19/06/2023.
//

import Foundation
import UIKit

class UikitHelper{
    
    static func noDataImage(image : UIImageView , view:UIView, table : UITableView , activityIndicator: UIActivityIndicatorView){
       
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 100),
            image.heightAnchor.constraint(equalToConstant: 100)
        ])
        table.isHidden = true
        activityIndicator.isHidden = true
    }
}

