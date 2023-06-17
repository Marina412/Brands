//
//  OrderCollectionViewCell.swift
//  YRStor
//
//  Created by marina on 13/06/2023.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderPaydType: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func cellSetUp(order:Order){
        orderDate.text = order.created_at
        orderPaydType.text = order.reference
        orderPrice.text = order.current_total_price

    }
}
