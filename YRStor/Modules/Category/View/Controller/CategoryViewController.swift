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
    @IBOutlet weak var categoriesLab: UILabel!
    @IBOutlet weak var filterFloaty: Floaty!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var catigoryVM:CategoryViewModel!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("help")
        renderUI()
        registerXibCells()
        navigationBarButtons()
        let remote = NetworkManager()
        let repo = Repo(networkManager: remote)
        catigoryVM = CategoryViewModel(repo: repo)
        setUpProductsCollectionView()
        setUpSearchBar()
        catigoryVM.setUpData()
        
        filterFloaty.openAnimationType = .fade
        filterFloaty.addItem(Constant.ACCESSORIES, icon: UIImage(named: "accessory")){
            [weak self]
            item in
            guard let self else { return }
            self.catigoryVM.filterProudactsBySubCategory(categoryName: Constant.ACCESSORIES)
        }
        filterFloaty.addItem(Constant.T_SHIRTS, icon: UIImage(named: "tShirt")){
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
            catigoryVM.filterProudactsByMainCategory(categoryName: Constant.WOMEN)
        case 1:
            catigoryVM.filterProudactsByMainCategory(categoryName: Constant.MEN)
        case 2:
            catigoryVM.filterProudactsByMainCategory(categoryName: Constant.KID)
        case 3:
            catigoryVM.filterProudactsByMainCategory(categoryName: Constant.SALE)
        default :
            print("")
        }
    }
}
extension CategoryViewController{
    func setUpProductsCollectionView(){
        catigoryVM.poductsObservablRS.bind(to: productsCollectionView.rx.items){
            collectionView, index, item in
            let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: IndexPath(row: index, section: 0)) as! ProductCollectionViewCell
            productCell.cellSetUp(product:item)
            return productCell
        }.disposed(by:disposeBag)
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
        categoriesLab.text = "Categories"
        categoryWMSegment.buttonTitles = " Woman,Man,Kid,Sale"
        categoryWMSegment.buttonImages = "woman,man,kid,sale"
        categoryWMSegment.buttonImagesSelected = "selected,selected,selected,selected"
        categoryWMSegment.animate = true
    }
    private func registerXibCells(){
        productsCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
}
extension CategoryViewController{
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

