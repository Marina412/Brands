//
//  ProductCollectionViewCell.swift
//  YRStor
//
//  Created by marina on 04/06/2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var shoppingCart: UIButton!
    @IBOutlet weak var favourit: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        favourit.layer.cornerRadius = 5
        favourit.layer.borderColor = UIColor.black.cgColor
        favourit.layer.borderWidth = 1
        shoppingCart.layer.cornerRadius = 5
        shoppingCart.layer.borderWidth = 1
    }
    @IBAction func addToShoppingCartBtn(_ sender: Any) {
        print("add to shopping cart")
    }
    @IBAction func addToFavouritBtn(_ sender: Any) {
        print("add to fav")
    }
    func cellSetUp(product:Product){
        productImage.kf.setImage(with: URL(string:product.image?.src ?? ""), placeholder: UIImage(named: ""))
        productTitle.text = product.title
        productType.text = product.productType
    }
}

