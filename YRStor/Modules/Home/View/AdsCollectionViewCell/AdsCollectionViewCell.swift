//
//  AdsCollectionViewCell.swift
//  Shopify
//
//  Created by marina on 01/06/2023.
//

import UIKit

class AdsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var adImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func cellSetUp(ad:HomeAd){
        adImg.image = UIImage(named: ad.image)
        
    }
}
