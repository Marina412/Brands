//
//  CategoryViewController.swift
//  YRStor
//
//  Created by marina on 02/06/2023.
//

import UIKit
import Floaty
import WMSegmentControl
class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryWMSegment: WMSegment!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var filterFloaty: Floaty!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var brandId:Int?
    var brandTitle:String?
    var isFloatyPressed = false
    var isSegmentPressed  = false
    var filteredProductsByCategory : [Product] = []
    var catigoryVM:CategoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("help")
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        renderWMSegmentUI()
        registerXibCells()
        navigationBarButtons()
        let remote = NetworkManager()
        //let local = DataBaseManager()
        let repo = Repo(networkManager: remote)
        catigoryVM = CategoryViewModel(repo: repo)
        catigoryVM.getAllProductsFromApi(collectionId:brandId ?? 0){
            //[weak self]
            //            guard let self else { return }
            DispatchQueue.main.async {
                self.productsCollectionView.reloadData()
            }
        }
        filterFloaty.openAnimationType = .fade
        filterFloaty.addItem(Constant.ACCESSORIES, icon: UIImage(named: "accessory")){
            [weak self]
            item in
            guard let self else { return }
            self.isFloatyPressed = true
            self.filterProductsByCategory( filterBy: Constant.ACCESSORIES)  }
        filterFloaty.addItem(Constant.T_SHIRTS, icon: UIImage(named: "tShirt")){
            [weak self]
            item in
            guard let self else { return }
            self.isFloatyPressed = true
            self.filterProductsByCategory(filterBy: Constant.T_SHIRTS)
        }
        filterFloaty.addItem(Constant.SHOES, icon: UIImage(named: "shoe")){
            [weak self]
            item in
            guard let self else { return }
            self.isFloatyPressed = true
            self.filterProductsByCategory( filterBy: Constant.SHOES)
        }
        filterFloaty.addItem("No Filter", icon: UIImage(systemName: "nosign")){
            [weak self]
            item in
            guard let self else { return }
            self.isFloatyPressed = false
            self.isSegmentPressed = false
            self.productsCollectionView.reloadData()
        }
    }
    
    @IBAction func filterCategoryWMSegment(_ sender: WMSegment) {
        isSegmentPressed = true
        print("selected index = \(sender.selectedSegmentIndex) if press  \(isSegmentPressed)")
        switch sender.selectedSegmentIndex{
        case 0:
            catigoryVM.getAllProductsFromApiAndFilterByMainCategorry(categoryId: Constant.WOMEN_COLLECTION_ID, brandName: brandTitle ?? "" ){
                self.filterProductsByMainCategory()
            }
        case 1:
            catigoryVM.getAllProductsFromApiAndFilterByMainCategorry(categoryId: Constant.MEN_COLLECTION_ID, brandName: brandTitle ?? "" ){
                self.filterProductsByMainCategory()
            }
        case 2:
            catigoryVM.getAllProductsFromApiAndFilterByMainCategorry(categoryId: Constant.KID_COLLECTION_ID, brandName: brandTitle ?? "" ){
                self.filterProductsByMainCategory()
            }
        case 3:
            catigoryVM.getAllProductsFromApiAndFilterByMainCategorry(categoryId: Constant.ON_SALE_COLLECTION_ID, brandName: brandTitle ?? "" ){
                self.filterProductsByMainCategory()
            }
        default :
            print("")
        }
    }
}

extension CategoryViewController{
    func filterProductsByCategory(filterBy:String){
        filteredProductsByCategory.removeAll()
        filteredProductsByCategory = catigoryVM.allProducts.filter({ product in
            product.productType?.lowercased() == filterBy.lowercased()
        })
        productsCollectionView.reloadData()
    }
    
    func filterProductsByMainCategory(){
        filteredProductsByCategory.removeAll()
        filteredProductsByCategory = catigoryVM.filteredMainCategoryProduct.filter({ product in
            product.vendor?.lowercased() == brandTitle?.lowercased()
        })
        productsCollectionView.reloadData()
    }
}
extension CategoryViewController{
    func renderWMSegmentUI(){
        brandName.text = brandTitle
        //categoryWMSegment.isRounded = true
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
        let searchBtn = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.navToFavoriteScreen))
        let shoppingBagBtn = UIBarButtonItem(image: UIImage(systemName: "bag.fill"), style: .plain, target: self, action: #selector(self.navToShoppingBagScreen))
        navigationItem.rightBarButtonItems = [searchBtn, shoppingBagBtn]
    }
}
extension CategoryViewController{
    @objc func navToFavoriteScreen(){
        print("go to fav ")
    }
    @objc func navToShoppingBagScreen(){
        print("go to bag ")
    }
}
extension CategoryViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("klike cell")
        //        let productInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        //        productInfoVC.brandId = homeVM.brands[indexPath.row].collectionID
        //
        //        productInfoVC.modalPresentationStyle = .fullScreen
        //        productInfoVC.modalTransitionStyle = .flipHorizontal
        //        self.present(categoryVC, animated: true)
        
    }
}
extension CategoryViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSegmentPressed || isFloatyPressed{
           return  filteredProductsByCategory.count
        }
        else{
            return catigoryVM.allProducts.count
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell
        productCell?.layer.borderWidth = 1
        productCell?.layer.cornerRadius = 25
        productCell?.layer.borderColor = UIColor.black.cgColor
        
        if isSegmentPressed || isFloatyPressed{
            
            productCell?.cellSetUp(product:filteredProductsByCategory[indexPath.row])
            return productCell ?? BrandCollectionViewCell()
        }
        else {
            productCell?.cellSetUp(product:catigoryVM.allProducts[indexPath.row])
            return productCell ?? BrandCollectionViewCell()
        }
    }
}
extension CategoryViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.50 , height: collectionView.frame.height * 0.50)
        
    }
}
