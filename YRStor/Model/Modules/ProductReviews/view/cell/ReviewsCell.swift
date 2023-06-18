//
//  ReviewsCell.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit
import Cosmos

class ReviewsCell: UITableViewCell {

    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var reviewerName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewImage: UIImageView!
   
    var reviewCell :Review?
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(revieww : Review){
        self.reviewCell = revieww
        reviewDate.text = revieww.reviewDate
        reviewerName.text = revieww.reviewerName
        review.text = revieww.review
       // reviewImage.image = UIImageView(image: UIImage(named: "logo"))
        //ratingView.rating = Double(revieww.reviewRating ?? 0.0)
        
    }
    
}
