//
//  ProductCollectionViewCell.swift
//  YRStor
//
//  Created by marina on 04/06/2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var shoppingCart: UIButton!
    @IBOutlet weak var favourit: UIButton!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var currencyLab: UILabel!
    
    
    
    
    var productInforViewModel = ProductInfoViewModel(repo: Repo(networkManager: NetworkManager()))
    var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
    var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
    var favProduct = FavProduct(lineItems: [LineItems()])
    var product = Product()
//    var draftOrders : [FavProduct] = []
    var draftId  = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shoppingCart.layer.cornerRadius = 18
        shoppingCart.layer.borderWidth = 0.5
        shoppingCart.layer.borderColor = UIColor.black.cgColor
    }
    
    
    func cellSetUp(product:Product, currency:String){
        
//        self.favProduct = FavProduct(email: favViewModel.defaults.value(forKey: "email") as? String,lineItems: [LineItems(productId: String(product.id ?? 0),productTitle: product.title,productPrice: product.variants?[0].price, productImage: product.image?.src)], favOrShopping: Constant.IS_FAV)

        favViewModel.product = LineItems(productId: String(product.id ?? 0),productTitle: product.title,productPrice: product.variants?[0].price, productImage: product.image?.src)
        self.product = product
        print("product id in cell \(self.product.id ?? 0 )")
       // getDraftId()
        productImage.kf.setImage(with: URL(string:product.image?.src ?? ""), placeholder: UIImage(named: "man"))
        productTitle.text = product.title?.localizedCapitalized
        productType.text = product.productType?.localizedCapitalized
        productPrice.text = product.variants?[0].price
        currencyLab.text = currency
       
    }
    @IBAction func addToShoppingCartBtn(_ sender: Any) {
//        self.shoppingCart.setImage(UIImage(systemName: "cart.circle.fill"), for: .normal)
        checkCustomerCart()
        print("add to shopping cart")
    }
    @IBAction func addToFavouritBtn(_ sender: Any) {
        print("add to fav")
 
        if(favourit.currentImage == (UIImage(systemName: "heart.fill"))){
            print("click product id  \(product.id)")
            favourit.setImage(UIImage(systemName: "heart"), for: .normal)
            favViewModel.deleteFavListInDatabase(draftId: self.draftId, indexPath: 0) {
                
            }
            
            
           // print("deleted clicked")
        }
        else{
             
           // favourit.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favViewModel.saveFavProductToDatabase(favProduct: favProduct ?? FavProduct())
            //print("added to fav")
        }
    }
    func checkCustomerCart(){
         
         let email = favViewModel.defaults.string(forKey: "email")
         var draftId : String = ""
         var isNew = false
         var isExists = false
        favViewModel.getAllFav()
        favViewModel.bindResult = {() in
             let res = self.favViewModel.viewModelResult
             guard var allDrafts = res?.draftOrders else {return}
             if allDrafts.count == 0 {
                 self.addProductToCartInDataBase()
             }
             else{
                 for draft in allDrafts{
                     if(draft.email == email && draft.favOrShopping == Constant.IS_SHOPPING_CART){
                         self.productInforViewModel.draft = draft
                         isExists = true
                         
                     }
                     else{
                         isNew = true
                     }
                 }
                 if(isExists){
                     self.putInCart(draft: self.productInforViewModel.draft)
                 }
                 
                 if(isNew && isExists == false){
                     self.addProductToCartInDataBase()
                 }
             }
         }
     }
             func putInCart(draft : FavProduct){
                 var newDraft = draft
                 self.productInforViewModel.draftId = String(draft.draftId ?? 0)
                 var newProduct = self.favViewModel.product
                 newDraft.lineItems?.append(newProduct)
                 var draft = Drafts(draftOrder: newDraft)
                 self.cartViewModel.editShoppingCart(draftOrder:draft, draftId: self.productInforViewModel.draftId ?? "")
                 print("edit existing draftOrder  \(draft.draftOrder.lineItems?.count)")

             }
             
             func addProductToCartInDataBase(){
                 
                 var shoppingCartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
                 let email = self.favViewModel.defaults.string(forKey: "email")

                 var draft = FavProduct(email: email,lineItems: [favViewModel.product],favOrShopping: Constant.IS_SHOPPING_CART)
                 shoppingCartViewModel.saveShoppingCartInDatabase(favProduct: draft)
                 shoppingCartViewModel.bindResult = {() in
                     let res = shoppingCartViewModel.viewModelResult
                     guard let draftOrder = res else {return}
                 }
             }
         }




