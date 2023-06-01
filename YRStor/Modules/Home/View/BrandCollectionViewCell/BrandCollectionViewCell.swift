//
//  BrandCollectionViewCell.swift
//  Shopify
//
//  Created by marina on 01/06/2023.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandImg: UIImageView!
    
    @IBOutlet weak var brandName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func cellSetUp(brand:HomeBrand){
        brandImg.image = UIImage(named: brand.image)
        brandName.text = brand.name
        
    }
}
