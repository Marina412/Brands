//
//  onboardingViewController.swift
//  Brandy
//
//  Created by Aya Mohamed Ahmed on 01/06/2023.
//

import UIKit

class onboardingViewController: UIViewController {
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    let defaults = UserDefaults.standard
    let slides:[onboardingSlide]=[
        onboardingSlide(title: "Brands", description: "All That you need,All That you want just Hello at Brands",image:"onboarding1"),
        onboardingSlide(title: "Brands", description: "A lot of offers wait you with many coupons just for you ",image:"onboarding2"),
        onboardingSlide(title: "Brands", description: "You can shop anytime and anywhere while keeping up with everything new", image:"onboarding3")]
    var currentPage = 0{
        didSet{
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1{
                nextBtn.setTitle("Get Started", for: .normal)
            }
            else{
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        print("onBoarding viewController")
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if currentPage == slides.count - 1{
            defaults.set(false, forKey: "isLogging")
            let homeScreen = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            homeScreen.modalPresentationStyle = .fullScreen
            homeScreen.modalTransitionStyle = .flipHorizontal
            UserDefaults.standard.onboarded = true
            self.present(homeScreen, animated: true)
        }else{
            let indexPath = IndexPath(item: currentPage, section: 0)
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        currentPage += 1
       }
}
extension onboardingViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCollectionViewCell", for: indexPath) as! onboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage=Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
    
}
