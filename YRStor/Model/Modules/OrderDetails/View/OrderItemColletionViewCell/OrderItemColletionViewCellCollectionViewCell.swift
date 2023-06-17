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
    func cellSetUp(order:OrderProductItems){
        productImage.kf.setImage(with: URL(string:order.sku ?? ""), placeholder: UIImage(named: "logo"))
        productTitle.text = order.title
        productsCount.text = "\(order.quantity ?? 0) items"
        productsTotalPrice.text = order.price 
        
    }
}
