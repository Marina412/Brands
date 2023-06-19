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
    
    var brandId:Int?
    var brandTitle:String?
    var brandProductsVM:BrandProductsViewModel!
    let disposeBag = DisposeBag()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    func getDraftId(product :Product) -> (product:Product,draftId:  String){
        var favProduct = Product()
        var draftId = ""
        var viewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
        viewModel.getAllFav()
        viewModel.bindResult = {() in
            let res = viewModel.viewModelResult
            guard let allDrafts = res else {return}
            guard var customerDrafts = CustomerHelper.getFavForCustomers(favs: allDrafts.draftOrders) else {return}
            for draft in customerDrafts {
                if(draft.lineItems?[0].productId == String(product.id ?? 0)){
                    draftId = String(draft.draftId ?? 0)
                    guard let products = draft.lineItems else {return}
                    for id in products{
                        if(id.productId == String(product.id ?? 0)){
                            print("ids equal each other second loop ")
                            favProduct.id = product.id
                            favProduct.title = product.title
                            favProduct.variants?[0].price = product.variants?[0].price
                            favProduct.image?.src = product.image?.src
                            favProduct.productType = product.productType
                            favProduct.isFav = true
                        }
                    }
                }
            }
        }
        return (favProduct,draftId)
        
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
        productsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        brandProductsVM.poductsObservablRS.bind(to: productsCollectionView.rx.items){
            collectionView, index, item in
            let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: IndexPath(row: index, section: 0)) as! ProductCollectionViewCell
            productCell.cellSetUp(product: item,  currency:self.brandProductsVM.curencyType)
            return productCell
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
        productsCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
}
