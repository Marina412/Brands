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
//        let remote = NetworkingService()
//        let local = DataBaseManager()
//        let repo = Repo(dataBaseManager: local, networkManger: remote)
        homeVM = HomeViewModel(repo: repo)
        
        registerXibCells()
        
    }
    private func registerXibCells(){
        adsCollectionView.register(UINib(nibName: "AdsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdsCollectionViewCell")
        
        brandsCollectionView.register(UINib(nibName: "BrandCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandCollectionViewCell")
        
    }
    
    
}


extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case categoriesCollectionView:
            return homeVM.ads.count
        case cardCollectionView:
            return homeVM.brands.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case adsCollectionView:
            
            let adsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionViewCell", for: indexPath) as? AdsCollectionViewCell
            //cell?.setUp(categories: categories[indexPath.row])
            return adsCell
            
        case brandsCollectionView:
            let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCollectionViewCell", for: indexPath) as? BrandCollectionViewCell
            
            //cardCell?.setUp(recipe: homeVM.recipeResponse[indexPath.row])
            return brandCell
            
        default:
            return UICollectionViewCell()
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView{
        case adsCollectionView:
            return return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
        case brandsCollectionView:
            return CGSize(width: collectionView.frame.width * 0.50 , height: collectionView.frame.height * 0.5)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Todo add when press
        
        
        
    }
    
}
