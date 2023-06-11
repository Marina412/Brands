//
//  HomeViewController.swift
//  Shopify
//
//  Created by marina on 01/06/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var adsCollectionV: UICollectionView!
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var homeVM:HomeViewModel!
    //    var currentPage = 0{
    //        didSet{
    //            if currentPage == homeVM.homeAdvertisment.count-1{
    //                currentPage = 0
    //            }
    //            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now()+2) {
    //                self.currentPage += 1
    //            }
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello from home")
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        let remote = NetworkManager()
        let repo = Repo(networkManager: remote)
        homeVM = HomeViewModel(repo: repo)
        brandsCollectionView.delegate = self
        brandsCollectionView.dataSource = self
        adsCollectionV.delegate = self
        adsCollectionV.dataSource = self
        registerXibCells()
        navigationBarButtons()
        homeVM.getAllCategoriesFromApi {
            [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.brandsCollectionView.reloadData()
            }
        }
    }
}
extension HomeViewController{
    private func registerXibCells(){
        brandsCollectionView.register(UINib(nibName: "BrandCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandCollectionViewCell")
    }
}
extension HomeViewController{
    func navigationBarButtons(){
        self.navigationController?.navigationBar.tintColor =  #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        let profilBtn = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(self.navToProfil))
        let searchBtn = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.navToFavoriteScreen))
        navigationItem.rightBarButtonItems = [profilBtn,searchBtn]
    }
}
extension HomeViewController{
    @objc func navToFavoriteScreen(){
        print("go to fav ")
    }
    @objc func navToProfil(){
        print("go to profil ")
    }
}
extension HomeViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView{
        case brandsCollectionView:
            print("klick cell ")
            let brandProductsVC = self.storyboard?.instantiateViewController(withIdentifier: "BrandProductsViewController") as! BrandProductsViewController
            brandProductsVC.brandId = homeVM.brands[indexPath.row].collectionID
            brandProductsVC.brandTitle = homeVM.brands[indexPath.row].title
            self.navigationController?.pushViewController(brandProductsVC, animated: true)
//                        brandProductsVC.modalPresentationStyle = .fullScreen
//                        brandProductsVC.modalTransitionStyle = .flipHorizontal
//                        self.present(brandProductsVC, animated: true)
        default:
            print("")
            
        }
    }
}
extension HomeViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case adsCollectionV:
            return homeVM.homeAdvertisment.count
        case brandsCollectionView:
            return homeVM.brands.count
        default:
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case adsCollectionV:
            let adsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionViewCell", for: indexPath) as? AdsCollectionViewCell
            adsCell?.adsImage.image = UIImage(named: homeVM.homeAdvertisment[indexPath.row])
            adsCell?.adsImage.layer.cornerRadius = 50.0
            return adsCell ?? AdsCollectionViewCell()
        case brandsCollectionView:
            let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCollectionViewCell", for: indexPath) as? BrandCollectionViewCell
            brandCell?.cellSetUp(brand: homeVM.brands[indexPath.row])
            brandCell?.layer.borderWidth = 1
            brandCell?.layer.cornerRadius = 25
            brandCell?.layer.borderColor = UIColor.black.cgColor
            return brandCell ?? BrandCollectionViewCell()
            
        default:
            return UICollectionViewCell()
            
        }
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView{
        case brandsCollectionView:
            return CGSize(width: collectionView.frame.width * 0.50 , height: collectionView.frame.height * 0.50)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        let width = scrollView.frame.width
    //        currentPage=Int(scrollView.contentOffset.x / width)
    //        homePageControl.currentPage = currentPage
    //    }
}

