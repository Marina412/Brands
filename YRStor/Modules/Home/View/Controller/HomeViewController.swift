//
//  HomeViewController.swift
//  Shopify
//
//  Created by marina on 01/06/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    var homeVM:HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello from home")
        let remote = NetworkManager()
        //let local = DataBaseManager()
        let repo = Repo(networkManager: remote)
        homeVM = HomeViewModel(repo: repo)
        [adsCollectionView,brandsCollectionView].forEach {
            $0?.delegate   = self
            $0?.dataSource = self
        }
        registerXibCells()
        navigationBarButtons()
        
        homeVM.getAllCategoriesFromApi {
            //            [weak self]
            //            guard let self else { return }
            DispatchQueue.main.async {
                self.brandsCollectionView.reloadData()
            }
        }
    }
}
extension HomeViewController{
    private func registerXibCells(){
        adsCollectionView.register(UINib(nibName: "AdsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdsCollectionViewCell")
        
        brandsCollectionView.register(UINib(nibName: "BrandCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandCollectionViewCell")
    }
}
extension HomeViewController{
    func navigationBarButtons(){
        
        let searchBtn = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.navToFavoriteScreen))
        
        let shoppingBagBtn = UIBarButtonItem(image: UIImage(systemName: "bag.fill"), style: .plain, target: self, action: #selector(self.navToShoppingBagScreen))
        
        navigationItem.rightBarButtonItems = [searchBtn, shoppingBagBtn]
    }
}
extension HomeViewController{
    @objc func navToFavoriteScreen(){
        print("go to fav ")
    }
    @objc func navToShoppingBagScreen(){
        print("go to bag ")
    }
}
extension HomeViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView{
        case adsCollectionView:
            print("")
            
        case brandsCollectionView:
            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
            categoryVC.brandId = homeVM.brands[indexPath.row].collectionID
            categoryVC.brandTitle = homeVM.brands[indexPath.row].title
            categoryVC.modalPresentationStyle = .fullScreen
            categoryVC.modalTransitionStyle = .flipHorizontal
            self.present(categoryVC, animated: true)
            
        default:
            print("")
            
        }
        
    }
}
extension HomeViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case adsCollectionView:
            return homeVM.ads.count
        case brandsCollectionView:
            return homeVM.brands.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case adsCollectionView:
            
            let adsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionViewCell", for: indexPath) as? AdsCollectionViewCell
            adsCell?.cellSetUp(ad: homeVM.ads[indexPath.row])
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
        case adsCollectionView:
            return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
        case brandsCollectionView:
            return CGSize(width: collectionView.frame.width * 0.50 , height: collectionView.frame.height * 0.50)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}

