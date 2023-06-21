//
//  BrandProductsViewController.swift
//  YRStor
//
//  Created by marina on 06/06/2023.
//

import UIKit
import RxCocoa
import RxSwift
class BrandProductsViewController: UIViewController {
    
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var filterSearchBar: UISearchBar!
    let defaults = UserDefaults.standard
    var brandId:Int?
    var brandTitle:String?
    var brandProductsVM:BrandProductsViewModel!
    let disposeBag = DisposeBag()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var favProducts :[String] = []
    var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
    var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
        UserDefaults.standard.set(Constant.IS_BRANDS, forKey: "isFavOrCart")
        indicatorSetUp()
        brandName.text = brandTitle?.localizedCapitalized
        let remote = NetworkManager()
        let repo = Repo(networkManager: remote)
        brandProductsVM = BrandProductsViewModel(repo: repo)
        setUpProductsCollectionView()
        setUpSearchBar()
        registerXibCells()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.startAnimating()
        brandProductsVM.setUpData(brandId:brandId ?? 0){
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
            
            guard let favIds = customerFav.lineItems?.count  else {return}
            
            for id in customerFav.lineItems!{
                self.favProducts.append(id.productId ?? "")
              
            }
            
            self.productsCollectionView.reloadData()
        }
    }
}
    

extension BrandProductsViewController:UICollectionViewDelegateFlowLayout{
  
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.numberOfItems(inSection: section) == 1  {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: collectionView.frame.width - flowLayout.itemSize.width)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
extension BrandProductsViewController{
    func indicatorSetUp(){
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        productsCollectionView.isHidden = true
    }
}
extension BrandProductsViewController{
    func setUpProductsCollectionView(){
        var isFav = false
        productsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        brandProductsVM.poductsObservablRS.bind(to: productsCollectionView.rx.items(cellIdentifier: "productsCell",cellType: ProductCollectionViewCell.self)) { index, element, cell in
 
           isFav = self.favProducts.contains(String(element.id ?? 0))
            cell.cellSetUp(product: element, currency: UserDefaults.standard.string(forKey: Constant.CURRENCY) ?? "", isFav: isFav)
//            cell.categoryButtonAction = {() in
//                let category = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
//                self.navigationController?.pushViewController(category, animated: true)
//
//            }
//            cell.BrandsButtonAction = {() in
//                let brands = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
//                self.navigationController?.pushViewController(brands, animated: true)
//            }

        }.disposed(by:disposeBag)
        
        productsCollectionView.rx.itemSelected.subscribe(onNext:{
            index in
            let productInfo = self.storyboard?.instantiateViewController(withIdentifier: "ProductInfoViewController") as! ProductInfoViewController
            productInfo.product = self.brandProductsVM.allProducts[index.row]
            self.navigationController?.pushViewController(productInfo, animated: true)
         }).disposed(by: disposeBag)
        
    }
}
extension BrandProductsViewController: UISearchBarDelegate{
    func setUpSearchBar() {
        filterSearchBar.delegate = self
        filterSearchBar.rx.text.subscribe { textQuery in
            self.brandProductsVM.filterProudacts(searchText: textQuery ?? "")
        }.disposed(by: disposeBag)
    }
}

extension BrandProductsViewController{
    private func registerXibCells(){
        productsCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "productsCell")
    }
}
