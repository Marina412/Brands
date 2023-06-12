//
//  ReviewsCell.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit

class ReviewsCell: UITableViewCell {

    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var reviewerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(reviews : [Review], indexPath : IndexPath){
        reviewDate.text = reviews[indexPath.row].reviewDate
        reviewerName.text = reviews[indexPath.row].reviewerName
        review.text = reviews[indexPath.row].review
        
    }
    
}
