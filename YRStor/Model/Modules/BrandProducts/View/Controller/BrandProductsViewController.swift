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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productsCollectionView.delegate = nil
        productsCollectionView.dataSource = nil
        brandName.text = brandTitle
        navigationBarButtons()
        let remote = NetworkManager()
        let repo = Repo(networkManager: remote)
        brandProductsVM = BrandProductsViewModel(repo: repo)
        setUpProductsCollectionView()
        setUpSearchBar()
        registerXibCells()
        brandProductsVM.setUpData(brandId:brandId ?? 0)
    }
    
}
extension BrandProductsViewController{
    func setUpProductsCollectionView(){
        brandProductsVM.poductsObservablRS.bind(to: productsCollectionView.rx.items){
            collectionView, index, item in
            let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: IndexPath(row: index, section: 0)) as! ProductCollectionViewCell
            productCell.cellSetUp(product:item,currency: self.brandProductsVM.curencyType)
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
    func navigationBarButtons(){
        self.navigationController?.navigationBar.tintColor =  #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        let profilBtn = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(self.navToProfil))
        let searchBtn = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.navToFavoriteScreen))
        navigationItem.rightBarButtonItems = [profilBtn,searchBtn]
    }
    @objc func navToFavoriteScreen(){
        print("go to fav ")
    }
    @objc func navToProfil(){
        print("go to profil ")
    }
}
extension BrandProductsViewController{
    private func registerXibCells(){
        productsCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
}
