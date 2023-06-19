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
    override func viewDidLoad() {
        super.viewDidLoad()
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
//                print("test 4")
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
       
        print("test1")
        productsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        catigoryVM.poductsObservablRS.bind(to: productsCollectionView.rx.items){
            collectionView, index, item in
            print("test2")
            let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: IndexPath(row: index, section: 0)) as! ProductCollectionViewCell
            print("item\(item)")
            productCell.cellSetUp(product: item, currency: self.catigoryVM.curencyType)
           
           
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
        
        categoryWMSegment.borderColor = .lightGray
        categoryWMSegment.borderWidth = 2
        
        categoryWMSegment.buttonTitles = " Woman,Man,Kid,Sale"
        categoryWMSegment.buttonImages = "woman,man,kid,sale"
        categoryWMSegment.buttonImagesSelected = "selected,selected,selected,selected"
        categoryWMSegment.animate = true
    }
    private func registerXibCells(){
        productsCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
}



