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
        // Initialization code
        
//        brandImg.layer.borderWidth = 1
//        brandImg.layer.borderColor = UIColor.black.cgColor
//        brandImg.layer.cornerRadius = 20
        //brandName.layer.cornerRadius = 20
    }
    func cellSetUp(brand:Collection){
        brandImg.kf.setImage(with: URL(string:brand.collectionImage?.src ?? ""), placeholder: UIImage(named: ""))
        brandName.text = brand.title
        
    }
}
