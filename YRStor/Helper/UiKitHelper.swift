//
//  UiKitHelper.swift
//  YRStor
//
//  Created by Huda kamal  on 19/06/2023.
//

import Foundation
import UIKit

class UikitHelper{
    
     static func noDataImage(imageName : String , view:UIView, table : UITableView , activityIndicator: UIActivityIndicatorView){
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        table.isHidden = true
        activityIndicator.isHidden = true
    }
}
