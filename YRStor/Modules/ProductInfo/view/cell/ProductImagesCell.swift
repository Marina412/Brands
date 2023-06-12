//
//  ProductImagesCellCollectionViewCell.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit

class ProductImagesCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imagesCell: UIImageView!
    
    func setUpProductImages(productImages : [ProductImage], indexPath : IndexPath){
        imagesCell.kf.setImage(with: URL(string: productImages[indexPath.row].src ?? ""))
    }
}
