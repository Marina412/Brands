//
//  ReviewsViewController.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsTable: UITableView!
    var  reviews = [Review(reviewDate: "5 days ago", reviewerName: "Menna", review: "i like this product",reviewImage:"review1.png",reviewRating: 4),
                    Review(reviewDate: "1 week ago", reviewerName: "Hour", review: "good matrial",reviewImage: "review2.png",reviewRating: 5),
                    Review(reviewDate: " 11 days ago", reviewerName: "Aya", review: "i loved it so much",reviewImage: "review3.png",reviewRating: 5),
                    Review(reviewDate: "7 months ago", reviewerName: "Huda", review: "very good product",reviewImage: "review4.png",reviewRating: 4.5),
                    Review(reviewDate: "10 months ago", reviewerName: "Marina", review: "i like it",reviewImage: "review5.png", reviewRating: 5),
                    Review(reviewDate: "1 year ago", reviewerName: "eman", review: "pretty colors",reviewImage: "review6.png", reviewRating: 3.5)]
    var review = Review()
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setUpTable()
    }
    
    func setUpTable(){
        
        reviewsTable.dataSource = self
        reviewsTable.delegate = self
        reviewsTable.register(UINib(nibName: "ReviewsCell", bundle: nil), forCellReuseIdentifier: "reviewCell")
        
    }
    

}

extension ReviewsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewsCell
        cell.configureCell(revieww: reviews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
    
    
}

