//
//  HomeViewController.swift
//  Shopify
//
//  Created by marina on 01/06/2023.
//

import UIKit
import Reachability

class HomeViewController: UIViewController {
    var reachability = try! Reachability()

    @IBOutlet weak var adsCollectionView: UICollectionView!{
        didSet{
            adsCollectionView.delegate = self
            adsCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var curentPage = 0
    var timer:Timer?
    var homeAdvertismentPhoto:[String]=["home2","home1","home3"]
    var homeVM:HomeViewModel!
    let userDefaults = UserDefaults.standard
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
       override func viewWillAppear(_ animated: Bool) {
           homeVM.loadCupon()
           NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
          do{
            try reachability.startNotifier()
          }catch{
            print("could not start reachability notifier")
          }
       }
    
    @objc func reachabilityChanged(note: Notification) {}
    override func viewDidDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        HelperFunctions.curencyDefualtsFirstTime()
        indicatorSetUp()
        self.brandsCollectionView.isHidden = true
        userDefaults.set(false, forKey: "AddressShoppingCart")
        userDefaults.set(false, forKey: "didSelectAddress")
        self.userDefaults.set(false, forKey: "touchCopon")
        let remote = NetworkManager()
        let repo = Repo(networkManager: remote)
        homeVM = HomeViewModel(repo: repo)
        brandsCollectionView.delegate = self
        brandsCollectionView.dataSource = self
        setTimer()
        registerXibCells()
        navigationBarButtons()
        homeVM.getAllCategoriesFromApi {
            [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.brandsCollectionView.isHidden = false
                self.brandsCollectionView.reloadData()
            }
        }
        
    }
    func setTimer(){
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(increaseCurrentPage), userInfo: nil, repeats: true)
        pageControl.numberOfPages = homeAdvertismentPhoto.count
    }
    
    @objc func increaseCurrentPage(){
        if curentPage < homeAdvertismentPhoto.count - 1 {
            curentPage += 1
        }else{
            curentPage = 0
        }
        
        adsCollectionView.scrollToItem(at: IndexPath(row: curentPage, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = curentPage
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
        let profilBtn = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(self.navToProfile))
        let searchBtn = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.navToSearchScreen))
        navigationItem.rightBarButtonItems = [profilBtn,searchBtn]
    }
}
extension HomeViewController{
    func indicatorSetUp(){
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        brandsCollectionView.isHidden = true
    }
}
extension HomeViewController{
    @objc func navToSearchScreen(){
        let search = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(search, animated: true)
        
    }
    @objc func navToProfile(){
        let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profile, animated: true)    }
}
extension HomeViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (reachability.connection != .unavailable){
            
            switch collectionView{
            case adsCollectionView:
                if indexPath.row == homeAdvertismentPhoto.count - 1{
                    if (homeVM.cupons == []){
                        let alert = UIAlertController(title: "Shopify", message: "Sorry you donn't have cupons", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert,animated: true)
                    }else{
                        guard homeVM.cupons != nil else {return}
                        let alert = UIAlertController(title: "Shopify", message: "Added your coupon \(homeVM.cupons[0] ) you can use it when you Payed", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Yes", style: .default,handler: {  action in
                            self.userDefaults.set(self.homeVM.cupons[0], forKey: Constant.CUPON_CODE)
                            self.userDefaults.set(true, forKey: "touchCopon")
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        self.present(alert,animated: true)
                    }
                }
            case brandsCollectionView:
                let brandProductsVC = self.storyboard?.instantiateViewController(withIdentifier: "BrandProductsViewController") as! BrandProductsViewController
                brandProductsVC.brandId = homeVM.brands[indexPath.row].collectionID
                brandProductsVC.brandTitle = homeVM.brands[indexPath.row].title
                self.navigationController?.pushViewController(brandProductsVC, animated: true)
            default:
                print("")
                
            }
        }
        
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline,Plz check your connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
}
extension HomeViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case adsCollectionView:
            return homeAdvertismentPhoto.count
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
            adsCell?.adsImage.image = UIImage(named: homeAdvertismentPhoto[indexPath.row])
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
            return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height - 10)
            
        case brandsCollectionView:
            return CGSize(width: collectionView.frame.width * 0.50 , height: collectionView.frame.height * 0.50)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}


