//
//  ProductInfoViewController.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit

class ProductInfoViewController: UIViewController {

    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var imageCollection: UICollectionView!
    
    @IBOutlet weak var productPrice: UILabel!
 
    @IBOutlet weak var productDescription: UITextView!
    
    @IBOutlet weak var productBrand: UILabel!
    
    @IBOutlet weak var fabBtnCheck: UIButton!
    
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var stepperOutlet: UIStepper!
    
    var currentPage = 0{
            didSet{
                pageControl.currentPage = currentPage
            }
        }
        var product : Product?
        var productImages : [ProductImage]!
        var draftId :String?
        var favProduct : FavProduct?
        var lineItems : [LineItems]?
        let defaults = UserDefaults.standard
        var viewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
        var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
        var shoppingCartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
        var draft : FavProduct = FavProduct()
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            productQuantity.text = "\(Int(stepperOutlet.value))"
            checkIsFavProduct()
            setUpView()
            setUpProductDetails()
        }
        
        func checkIsFavProduct(){
            var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
            favViewModel.getAllFav()
            favViewModel.bindResult = {() in
                let res = favViewModel.viewModelResult
                guard let allFav = res?.draftOrders else {return}
                guard var customerFav = self.getFavForCustomers(favs: allFav) else {return}
                for draft in customerFav{
                    if(draft.lineItems?[0].productId == String(self.product?.id ?? 0)){
                        self.draftId = String(draft.draftId ?? 0)
                    }
                    guard let products = draft.lineItems else {return}
                    for id in products{
                        if(draft.lineItems?[0].productId == String(self.product?.id ?? 0)){
                            self.fabBtnCheck.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        }
                    }
                }
            }
        }
        
        func checkCustomerCart(){
            let email = defaults.string(forKey: "email")
            var draftId : String = ""
            var isNew = false
            var isExists = false
            var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
            favViewModel.getAllFav()
            favViewModel.bindResult = {() in
                let res = favViewModel.viewModelResult
                guard var allDrafts = res?.draftOrders else {return}
                if allDrafts.count == 0 {
                    self.addProductToCartInDataBase()
                }
                else{
                    for draft in allDrafts{
                        if(draft.email == email && draft.favOrShopping == Constant.IS_SHOPPING_CART){
                            self.draft = draft
                            isExists = true
                            
                        }
                        else{
                            isNew = true
                        }
                    }
                    if(isExists){
                        var isFound = false
                        for var productId in allDrafts[0].lineItems!{
                            print("product id \(self.product?.title)")
                            print("draft product id \(productId.productTitle)")
                            if(productId.productTitle == String(self.product?.title ?? "")){
                                productId.quantity = productId.quantity + (Int(self.productQuantity.text ?? "") ?? 0)
                                
                                var newDraft = allDrafts[0]
                                self.draftId = String(allDrafts[0].draftId ?? 0)
                                var draft = Drafts(draftOrder: newDraft)
                                self.shoppingCartViewModel.editShoppingCart(draftOrder:draft, draftId: self.draftId ?? "")
                                isFound = true
                                print("line itemss \(allDrafts[0].lineItems)")
                                break
                            }
                        }
                        if(!isFound){
                            self.putInCart(draft: self.draft)
                        }
                    }
                    
                    if(isNew && isExists == false){
                        self.addProductToCartInDataBase()
                    }
                    
                }
            }
            
        }
        
        func putInCart(draft : FavProduct){
            var newDraft = draft
            draftId = String(draft.draftId ?? 0)
            var newProduct = [LineItems(productId: String(self.product?.id ?? 0) ,productTitle: self.product?.title,productPrice: self.product?.variants?[0].price, quantity: Int(stepperOutlet.value))]
            newDraft.lineItems?.append(contentsOf: newProduct)
            var draft = Drafts(draftOrder: newDraft)
            shoppingCartViewModel.editShoppingCart(draftOrder:draft, draftId: draftId ?? "")
            print("edit existing draftOrder  \(draft.draftOrder.lineItems?.count)")
            
        }
        
        
        func setUpView(){
            productImages = product?.images
            imageCollection.delegate = self
            imageCollection.dataSource = self
            pageControl.numberOfPages = productImages.count
            setUpProductDetails()
        }
        func setUpProductDetails(){
            productName.text = product?.title
            productBrand.text = "Brand : " + (product?.vendor ?? "")
            productDescription.text = product?.bodyHTML
            productPrice.text = "Price : " + (product?.variants?[0].price ?? "")
            productName.numberOfLines = 0
            productName.lineBreakMode = .byWordWrapping
        }
    func saveFavProductToDatabase(){
           let email = defaults.string(forKey: "email")
           lineItems = [LineItems(productId: String(product?.id ?? 0) , productTitle : product?.title,productPrice: product?.variants?[0].price, quantity: 1,productImage: product?.image?.src)]
           
           favProduct = FavProduct(email: email,lineItems: lineItems,favOrShopping: Constant.IS_FAV)
           viewModel.saveFavProductToDatabase(favProduct: favProduct!)
        fabBtnCheck.setImage(UIImage(systemName: "heart.fill"), for: .normal)
       }

    func deleteProductFromDatabase(){
           var draftId = 0
           favViewModel.getAllFav()
           favViewModel.bindResult = {() in
               let res = self.favViewModel.viewModelResult
               guard let allFav = res else {return}
               guard let customerFav = self.getFavForCustomers(favs: allFav.draftOrders) else {return}
               for draft in customerFav{
                   if(draft.lineItems?[0].productId == String(self.product?.id ?? 0)){
                       draftId = draft.draftId ?? 0
                   }
               }
               self.favViewModel.deleteFavListInDatabase(draftId: String(draftId), indexPath: nil, completion: nil)
               
           }
       }
       
       func getFavForCustomers(favs : [FavProduct])-> [FavProduct]?{
           var favProducts : [FavProduct] = []
           let email = defaults.string(forKey: "email")
           for fav in favs {
               if(fav.email == email && fav.favOrShopping == Constant.IS_FAV){
                   favProducts.append(fav)
               }
           }
           return favProducts
           
       }
       
       func getCustomerCart(drafts : [FavProduct])-> FavProduct?{
           var customerDraft : FavProduct!
           let email = defaults.string(forKey: "email")
           for draft in drafts {
               if(draft.email == email && draft.favOrShopping == Constant.IS_SHOPPING_CART){
                   customerDraft = draft
               }
           }
           return customerDraft
           
       }

       func addProductToCartInDataBase(){
           
           var shoppingCartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
           let email = defaults.string(forKey: "email")
           var lineItems = [LineItems(productId: String(product?.id ?? 0) , productTitle : product?.title,productPrice: product?.variants?[0].price, quantity: 1,productImage: product?.image?.src)]
           var draft = FavProduct(email: email,lineItems: lineItems,favOrShopping: Constant.IS_SHOPPING_CART)
           shoppingCartViewModel.saveShoppingCartInDatabase(favProduct: draft)
           shoppingCartViewModel.bindResult = {() in
               let res = shoppingCartViewModel.viewModelResult
               guard let draftOrder = res else {return}
           }
           
           
       }
    @IBAction func favBtn(_ sender: Any) {
        if(fabBtnCheck.currentImage == (UIImage(systemName: "heart.fill"))){
            fabBtnCheck.setImage(UIImage(systemName: "heart"), for: .normal)
            deleteProductFromDatabase()
            print("deleted")
        }else{
            fabBtnCheck.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            saveFavProductToDatabase()
            print("added")
        }
    }
    
    @IBAction func stepperAction(_ sender: Any) {
        productQuantity.text = "\(Int(stepperOutlet.value))"
    }
    
    @IBAction func reviewsBtn(_ sender: Any) {
        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController")
        as! ReviewsViewController
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
}

extension ProductInfoViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productImages?.count ?? 3
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ProductImagesCell
        cell.setUpProductImages(productImages: productImages, indexPath: indexPath)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
    
    
    
}
