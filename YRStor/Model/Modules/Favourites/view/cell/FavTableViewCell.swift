//
//  FavTableViewCell.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit
import Kingfisher

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(favProducts : [FavProduct],indexPath : IndexPath){
        productTitle.text = favProducts[indexPath.row].lineItems?[0].productTitle
        productPrice.text = favProducts[indexPath.row].lineItems?[0].productPrice
        productImage.kf.setImage(with: URL(string: favProducts[indexPath.row].image ?? ""))
    }
}
