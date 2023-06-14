//
//  LocationCollectionViewCell.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var locationLbl: UILabel!
    
    func setup(location:Location){
        locationLbl.text = location.address
    }
}
