//
//  DataCollectionViewCell.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import UIKit

class DataCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var navigation_btn: UIButton!
    
    func setup(data:SettingData){
        dataLabel.text=data.title
    }
    
}
