//
//  OrderCollectionViewCell.swift
//  YRStor
//
//  Created by marina on 13/06/2023.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view: CardViews!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderPaydType: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.elevationCardView(view: view)
    }
    func cellSetUp(order:Order){
        let endCar = (order.createdAt?.firstIndex(of: "T"))!
        orderDate.text = order.createdAt?.substring(to: endCar)
        orderPaydType.text = order.payType
        orderPrice.text = HelperFunctions.priceEXchange(price:(order.currentTotalPrice ?? "0"))

    }
}
