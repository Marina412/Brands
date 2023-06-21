//
//  OrderItemColletionViewCellCollectionViewCell.swift
//  YRStor
//
//  Created by marina on 15/06/2023.
//

import UIKit

class OrderItemColletionViewCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productsTotalPrice: UILabel!
    @IBOutlet weak var productsCount: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func cellSetUp(order:OrderLineItems){
        productImage.kf.setImage(with: URL(string:order.image ?? ""), placeholder: UIImage(named: "logo"))
        productTitle.text = order.productTitle
        productsCount.text = "\(order.productQuantity ?? 0) items"
        productsTotalPrice.text = HelperFunctions.priceEXchange(price:(order.productPrice ?? "0"))
    }
}
