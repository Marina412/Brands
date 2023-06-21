//
//  ProductInfoViewController.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit
import Reachability

class ProductInfoViewController: UIViewController {
    
    @IBOutlet var addToCartOutlet: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cartBtnOutlet: UIButton!
    @IBOutlet weak var reviewsBtnOutlet: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var fabBtnCheck: UIButton!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var stepperOutlet: UIStepper!
    var reachability = try! Reachability()
    var currentPage = 0{
        didSet{
            pageControl.currentPage = currentPage
        }
    }
    
    var product : Product?
    var productInfoViewModel = ProductInfoViewModel(repo: Repo(networkManager: NetworkManager()))
    var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
    var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
       do{
         try reachability.startNotifier()
       }catch{
         print("could not start reachability notifier")
       }
        tabBarController?.tabBar.isHidden = false
        setUpView()
        setUpProductDetails()
        checkIsFavProduct()
    }
    @objc func reachabilityChanged(note: Notification) {}
    override func viewDidDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
     }
    
    func checkIsFavProduct(){
        
        favViewModel.getAllFav()
        favViewModel.bindResult = {() in
            let res = self.favViewModel.viewModelResult
            guard let allFav = res?.draftOrders else {return}
            guard let customerFav = CustomerHelper.getFavForCustomers(favs: allFav) else {return}
            self.cartViewModel.draftId = String(customerFav.draftId ?? 0)
            self.cartViewModel.resDraft = customerFav
            
            guard let products = customerFav.lineItems else {return}
            for favProduct in products{
                if(favProduct.productId == String(self.product?.id ?? 0)){
                    self.fabBtnCheck.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
            }
        }
        
    }
    
    
    func checkCustomerCart(){
        let email = self.cartViewModel.defaults.string(forKey: "email")
        var draftId : String = ""
        var isNew = false
        var isExists = false
        var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
        favViewModel.getAllFav()
        favViewModel.bindResult = {() in
            let res = favViewModel.viewModelResult
            guard var allDrafts = res?.draftOrders else {return}
            if allDrafts.count == 0 {
                self.addNewCart()
            }
            else{
                for draft in allDrafts{
                    if(draft.email == email && draft.favOrShopping == Constant.IS_SHOPPING_CART){
                        self.cartViewModel.resDraft = draft
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
                            self.cartViewModel.draftId = String(allDrafts[0].draftId ?? 0)
                            var draft = Drafts(draftOrder: newDraft)
                            self.cartViewModel.editShoppingCart(draftOrder:draft, draftId: self.cartViewModel.draftId ?? "")
                            isFound = true
                            print("line itemss \(allDrafts[0].lineItems)")
                            break
                        }
                    }
                    if(!isFound){
                        self.putInCart(draft: self.cartViewModel.resDraft ?? FavProduct())
                    }
                }
                
                if(isNew && isExists == false){
                    self.addNewCart()
                }
                
            }
        }
        
    }
    
    
    func putInCart(draft : FavProduct){
        var newDraft = draft
        self.cartViewModel.draftId = String(draft.draftId ?? 0)
        var newProduct = [LineItems(productId: String(self.product?.id ?? 0) ,productTitle: self.product?.title,productPrice: self.product?.variants?[0].price, quantity: Int(stepperOutlet.value))]
        newDraft.lineItems?.append(contentsOf: newProduct)
        var draft = Drafts(draftOrder: newDraft)
        cartViewModel.editShoppingCart(draftOrder:draft, draftId: self.cartViewModel.draftId ?? "")
        print("edit existing draftOrder  \(draft.draftOrder.lineItems?.count)")
        
    }
    
    
    func addNewCart(){
        
        let email = self.cartViewModel.defaults.string(forKey: "email")
        var lineItems = [LineItems(productId: String(product?.id ?? 0) , productTitle : product?.title,productPrice: product?.variants?[0].price, quantity: Int(stepperOutlet.value),productImage: product?.image?.src)]
        var draft = FavProduct(email: email,lineItems: lineItems,favOrShopping: Constant.IS_SHOPPING_CART)
        self.cartViewModel.saveShoppingCartInDatabase(favProduct: draft)
        self.cartViewModel.bindResult = {() in
            let res = self.cartViewModel.viewModelResult
            guard let draftOrder = res else {return}
        }
        
        
    }
    
    
    func checkCustomerFavs(){
        let email = self.cartViewModel.defaults.string(forKey: "email")
        var draftId : String = ""
        var isNew = false
        var isExists = false
        favViewModel.getAllFav()
        favViewModel.bindResult = {() in
            let res = self.favViewModel.viewModelResult
            guard var allDrafts = res?.draftOrders else {return}
            if allDrafts.count == 0 {
                self.addNewFavList()
            }
            else{
                for draft in allDrafts{
                    if(draft.email == email && draft.favOrShopping == Constant.IS_FAV){
                        self.cartViewModel.resDraft = draft
                        isExists = true
                        
                    }
                    else{
                        isNew = true
                    }
                }
                if(isExists){
                    var isFound = false
                    for var productId in allDrafts[0].lineItems!{
                        if(productId.productTitle == String(self.product?.title ?? "")){
                            productId.quantity = productId.quantity + (Int(self.productQuantity.text ?? "") ?? 0)
                            
                            var newDraft = allDrafts[0]
                            self.cartViewModel.draftId = String(allDrafts[0].draftId ?? 0)
                            var draft = Drafts(draftOrder: newDraft)
                            self.cartViewModel.editShoppingCart(draftOrder:draft, draftId: self.cartViewModel.draftId ?? "")
                            isFound = true
                            print("line itemss \(allDrafts[0].lineItems)")
                            break
                        }
                    }
                    if(!isFound){
                        self.putInFavsList(draft: self.cartViewModel.resDraft ?? FavProduct())
                    }
                }
                
                if(isNew && isExists == false){
                    self.addNewFavList()
                }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.addToCartOutlet.isHidden = false
                
            }
        }
        
    }
    
    func putInFavsList(draft : FavProduct){
        var newDraft = draft
        newDraft.favOrShopping = Constant.IS_FAV
        self.cartViewModel.draftId = String(draft.draftId ?? 0)
        var newProduct = [LineItems(productId: String(self.product?.id ?? 0) ,productTitle: self.product?.title,productPrice: self.product?.variants?[0].price, quantity: Int(stepperOutlet.value))]
        newDraft.lineItems?.append(contentsOf: newProduct)
        var draft = Drafts(draftOrder: newDraft)
        cartViewModel.editShoppingCart(draftOrder:draft, draftId: self.cartViewModel.draftId ?? "")
        print("edit existing draftOrder  \(draft.draftOrder.lineItems?.count)")
        
    }
    func addNewFavList(){
        
        let email = self.cartViewModel.defaults.string(forKey: "email")
        var lineItems = [LineItems(productId: String(product?.id ?? 0) , productTitle : product?.title,productPrice: product?.variants?[0].price, quantity: Int(stepperOutlet.value),productImage: product?.image?.src)]
        var draft = FavProduct(email: email,lineItems: lineItems,favOrShopping: Constant.IS_FAV)
        cartViewModel.saveShoppingCartInDatabase(favProduct: draft)
        cartViewModel.bindResult = {() in
            let res = self.cartViewModel.viewModelResult
            guard let draftOrder = res else {return}
        }
        
    }
    
    func deleteFavProduct(){
        
        if(self.cartViewModel.resDraft?.lineItems?.count == 1){
            cartViewModel.deleteFavListInDatabase(draftId: self.cartViewModel.draftId, indexPath: nil, completion: nil)
            print("deleted from if")
            fabBtnCheck.setImage(UIImage(systemName: "heart"), for: .normal)
        }else{
            fabBtnCheck.setImage(UIImage(systemName: "heart"), for: .normal)
            var newProduct : [LineItems] = []
            var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
            favViewModel.getAllFav()
            favViewModel.bindResult = {() in
                let res = favViewModel.viewModelResult
                guard let allFav = res?.draftOrders else {return}
                guard var customerFav = CustomerHelper.getFavForCustomers(favs: allFav) else {return}
                self.cartViewModel.resDraft = customerFav
                self.cartViewModel.products = customerFav.lineItems ?? [LineItems()]
                guard let products = customerFav.lineItems else {return}
                for i in 0..<products.count{
                    if(products[i].productId ==  String(self.product?.id ?? 0)){
                        self.cartViewModel.resDraft?.lineItems?.remove(at: i)
                        self.cartViewModel.resDraft?.favOrShopping = Constant.IS_FAV
                        var newDraft = Drafts(draftOrder: self.cartViewModel.resDraft ?? FavProduct())
                        self.cartViewModel.editShoppingCart(draftOrder: newDraft, draftId: String(self.cartViewModel.resDraft?.draftId ?? 0))
                    }
                }
                self.fabBtnCheck.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
        }
        
    }
    
    
    func setUpView(){
        
        self.productInfoViewModel.productImages = product?.images
        imageCollection.delegate = self
        imageCollection.dataSource = self
        pageControl.numberOfPages = self.productInfoViewModel.productImages.count
        setUpProductDetails()
        self.activityIndicator.isHidden = true

    }
    func setUpProductDetails(){
        productName.text = product?.title
        productBrand.text = "Brand : " + (product?.vendor ?? "")
        productDescription.text = product?.bodyHTML
        productPrice.text = "Price : " + (product?.variants?[0].price ?? "")
        productName.numberOfLines = 0
        productName.lineBreakMode = .byWordWrapping
        UITextView.textViewStyle(textView: productDescription)
        productQuantity.text = "\(Int(stepperOutlet.value))"
        
    }
    
    
    
    
    @IBAction func favBtn(_ sender: Any) {
        if (reachability.connection != .unavailable){
            //        var email = UserDefaults.standard.value(forKey: "email")
            //        var isLogin = UserDefaults.standard.value(forKey: "isLoggin")
            //        UserDefaults.standard.set(Constant.IS_PRODUCT_INFO, forKey: "isFavOrCart")
            //        if ((isLogin != nil) == false && email as! String == ""){
            //                   let register = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            //                                self.navigationController?.pushViewController(register, animated: true)
            //               }
            
            //  else if ((isLogin != nil) == true){
            if(fabBtnCheck.currentImage == (UIImage(systemName: "heart.fill"))){
                fabBtnCheck.setImage(UIImage(systemName: "heart"), for: .normal)
                deleteFavProduct()
                print("deleted from fav")
            }else{
                fabBtnCheck.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                checkCustomerFavs()
                print("added to fav")
            }
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline,Plz check connectivity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
           
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }

        
    }
    
    
    
    @IBAction func stepperAction(_ sender: Any) {
        if (reachability.connection != .unavailable){
            productQuantity.text = "\(Int(stepperOutlet.value))"
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline,Plz check connectivity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
           
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    
    @IBAction func reviewsBtn(_ sender: Any) {
        if (reachability.connection != .unavailable){
            let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController")
            as! ReviewsViewController
            self.navigationController?.pushViewController(reviewVC, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline,Plz check connectivity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
           
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    
    @IBAction func addToCartBtn(_ sender: Any) {
        if (reachability.connection != .unavailable){
            //        let email = UserDefaults.standard.string(forKey: "email")
            //        var isLogin = UserDefaults.standard.value(forKey: "isLoggin")
            //        UserDefaults.standard.set(Constant.IS_PRODUCT_INFO, forKey: "isFavOrCart")
            //        if ((isLogin != nil) == false && email == ""){
            //            let register = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            //            self.navigationController?.pushViewController(register, animated: true)
            //        }
            // else if ((isLogin != nil) == true) {
            checkCustomerCart()
            //  }
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline,Plz check connectivity", preferredStyle: .alert)
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





extension ProductInfoViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productInfoViewModel.productImages?.count ?? 3
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ProductImagesCell
        cell.setUpProductImages(productImages: self.productInfoViewModel.productImages, indexPath: indexPath)
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

