//
//  BrandCollectionViewCell.swift
//  Shopify
//
//  Created by marina on 01/06/2023.
//

import UIKit
import Kingfisher
class BrandCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandImg: UIImageView!
    
    @IBOutlet weak var brandName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func cellSetUp(brand:Collection){
        brandImg.kf.setImage(with: URL(string:brand.collectionImage?.src ?? ""), placeholder: UIImage(named: "logo"))
        brandName.text = brand.title
        
    }
}
