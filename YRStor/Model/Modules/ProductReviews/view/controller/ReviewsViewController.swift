//
//  ReviewsViewController.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsTable: UITableView!
    

    var  reviews = [Review(reviewDate: "5 days ago", reviewerName: "Mohamed Kamal", review: "i like this product"),Review(reviewDate: "1 week ago", reviewerName: "Hour Abdalrahman", review: "good matrial"), Review(reviewDate: " 11 days ago", reviewerName: "Aya Mohamed", review: "i loved it so much"),Review(reviewDate: "7 months ago", reviewerName: "Huda Mohareb", review: "very good product"),Review(reviewDate: "10 months ago", reviewerName: "Marina Atef", review: "i like it"),Review(reviewDate: "1 year ago", reviewerName: "eman khaled", review: "pretty colors")]
    
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
        cell.configureCell(reviews: reviews, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
    
    
}

