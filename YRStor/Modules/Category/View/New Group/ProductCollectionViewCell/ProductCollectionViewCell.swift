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
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var shoppingCart: UIButton!
    @IBOutlet weak var favourit: UIButton!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var currencyLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        shoppingCart.layer.cornerRadius = 18
        shoppingCart.layer.borderWidth = 0.5
        shoppingCart.layer.borderColor = UIColor.black.cgColor
    }
    @IBAction func addToShoppingCartBtn(_ sender: Any) {
        self.shoppingCart.setImage(UIImage(systemName: "cart.circle.fill"), for: .normal)
        print("add to shopping cart")
    }
    @IBAction func addToFavouritBtn(_ sender: Any) {
        print("add to fav")
        self.favourit.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
    }
    func cellSetUp(product:Product){// ,currency:String){
        productImage.kf.setImage(with: URL(string:product.image?.src ?? ""), placeholder: UIImage(named: "man"))
        productTitle.text = product.title?.localizedCapitalized
        productType.text = product.productType?.localizedCapitalized
        productPrice.text = product.variants?[0].price
        currencyLab.text = "EPY"//currency
    }
}

