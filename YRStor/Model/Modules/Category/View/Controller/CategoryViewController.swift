//
//  CategoryViewController.swift
//  YRStor
//
//  Created by marina on 02/06/2023.
//

import UIKit
import WMSegmentControl
import Floaty
import RxSwift
import RxCocoa
class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryWMSegment: WMSegment!
    
    @IBOutlet weak var filterFloaty: Floaty!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var catigoryVM:CategoryViewModel!
    let disposeBag = DisposeBag()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var favProducts :[String] = []
    let defaults = UserDefaults.standard
    var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
    var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
        UserDefaults.standard.set(Constant.IS_CATEGORY, forKey: "isFavOrCart")
        indicatorSetUp()
        renderUI()
        registerXibCells()
        let remote = NetworkManager()
        let repo = Repo(networkManager: remote)
        catigoryVM = CategoryViewModel(repo: repo)
        setUpProductsCollectionView()
        setUpSearchBar()
//        catigoryVM.setUpData(){
//            [weak self] in
//            guard let self else { return }
//            DispatchQueue.main.async {
//                self.activityIndicator.stopAnimating()
//                self.productsCollectionView.isHidden = false
//            }
//        }
        filterFloaty.openAnimationType = .none
        filterFloaty.addItem(Constant.ACCESSORIES, icon: UIImage(named: "accessory")){
            [weak self]
            item in
            guard let self else { return }
            self.catigoryVM.filterProudactsBySubCategory(categoryName: Constant.ACCESSORIES)
        }
        filterFloaty.addItem(Constant.T_SHIRTS, icon: UIImage(named: "T-SHIRTS")){
            [weak self]
            item in
            guard let self else { return }
            self.catigoryVM.filterProudactsBySubCategory(categoryName: Constant.T_SHIRTS)
        }
        filterFloaty.addItem(Constant.SHOES, icon: UIImage(named: "shoe")){
            [weak self]
            item in
            guard let self else { return }
            self.catigoryVM.filterProudactsBySubCategory(categoryName: Constant.SHOES)
        }
        filterFloaty.addItem("No Filter", icon: UIImage(systemName: "nosign")){
            [weak self]
            item in
            guard let self else { return }
            self.catigoryVM.filterProudactsBySubCategory(categoryName: "")
        }
        
    }
    
    @IBAction func filterCategoryWMSegment(_ sender: WMSegment) {
        
        print("selected index = \(sender.selectedSegmentIndex)")
        switch sender.selectedSegmentIndex{
        case 0:
            print("nofilter")
            catigoryVM.filterProudactsByMainCategory(categoryName: "")
        case 1:
            catigoryVM.filterProudactsByMainCategory(categoryName: Constant.WOMEN)
        case 2:
            catigoryVM.filterProudactsByMainCategory(categoryName: Constant.MEN)
        case 3:
            catigoryVM.filterProudactsByMainCategory(categoryName: Constant.KID)
        case 4:
            catigoryVM.filterProudactsByMainCategory(categoryName: Constant.SALE)
        default :
            print("")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.startAnimating()
        catigoryVM.setUpData(){
            [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.productsCollectionView.isHidden = false
            }
        }
        
        checkIsFavProduct()
    }
    
    func checkIsFavProduct(){
     
        favViewModel.getAllFav()
        favViewModel.bindResult = {() in
            let res = self.favViewModel.viewModelResult
            guard let allFav = res?.draftOrders else {return}
            
            
            guard let customerFav = CustomerHelper.getFavForCustomers(favs: allFav) else {return}
            print("all fav \(customerFav.lineItems?.count)")
            
            guard let favIds = customerFav.lineItems?.count  else {return}
            
            for id in customerFav.lineItems!{
                self.favProducts.append(id.productId ?? "")
              
            }
            
            self.productsCollectionView.reloadData()
        }
    }
}



extension CategoryViewController{
    func indicatorSetUp(){
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        productsCollectionView.isHidden = true
    }
}
extension CategoryViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       if collectionView.numberOfItems(inSection: section) == 1  {
           let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: collectionView.frame.width - flowLayout.itemSize.width)
       }
       return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
   }
}
extension CategoryViewController{
 
    func setUpProductsCollectionView(){
        var isFav = false
        print("test1")
        productsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
            catigoryVM.poductsObservablRS.bind(to: productsCollectionView.rx.items(cellIdentifier: "productsCell",cellType: ProductCollectionViewCell.self)) { index, element, cell in
     
               isFav = self.favProducts.contains(String(element.id ?? 0))
                
                cell.cellSetUp(product: element, currency: UserDefaults.standard.string(forKey: Constant.CURRENCY) ?? "", isFav: isFav)
//                cell.categoryButtonAction = {() in
//                    let category = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
//                    self.navigationController?.pushViewController(category, animated: true)
//                    
//                }
//                cell.BrandsButtonAction = {() in
//                    let category = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
//                    self.navigationController?.pushViewController(category, animated: true)
//
//                }
  
        }.disposed(by:disposeBag)
        productsCollectionView.rx.itemSelected.subscribe(onNext:{
            index in
            let productInfo = self.storyboard?.instantiateViewController(withIdentifier: "ProductInfoViewController") as! ProductInfoViewController
            productInfo.product = self.catigoryVM.allProducts[index.row]
            self.navigationController?.pushViewController(productInfo, animated: true)
         }).disposed(by: disposeBag)
    }
}

extension CategoryViewController: UISearchBarDelegate{
    func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.rx.text.subscribe { textQuery in
            self.catigoryVM.filterProudacts(searchText: textQuery ?? "")
        }.disposed(by: disposeBag)
    }
}
extension CategoryViewController{
    func renderUI(){
        
        categoryWMSegment.borderColor = .lightGray
        categoryWMSegment.borderWidth = 2
        categoryWMSegment.buttonTitles = "All,Woman,Man,Kid,Sale"
//        categoryWMSegment.buttonImages = "selected,woman,man,kid,sale"
//       categoryWMSegment.buttonImagesSelected = "selected,selected,selected,selected,selected"
        categoryWMSegment.animate = true
    }
    private func registerXibCells(){
        productsCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "productsCell")
    }
}



