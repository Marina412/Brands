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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
    var cartViewModel : ShoppingCartViewModel?
    var favProduct = FavProduct(lineItems: [LineItems()])
    var product = Product()
    var draftId  = ""
    var email  = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shoppingCart.layer.cornerRadius = 18
        shoppingCart.layer.borderWidth = 0.5
        shoppingCart.layer.borderColor = UIColor.black.cgColor
        activityIndicator.isHidden = true
    }
    
    
    func cellSetUp(product:Product, currency:String){
        
        cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
        //self.product = product
        cartViewModel?.product = LineItems(productId: String(product.id ?? 0),productTitle: product.title,productPrice: product.variants?[0].price, productImage: product.image?.src)
        print("product id in cell \(self.product.id ?? 0 )")
        productImage.kf.setImage(with: URL(string:product.image?.src ?? ""), placeholder: UIImage(named: "man"))
        productTitle.text = product.title?.localizedCapitalized
        productType.text = product.productType?.localizedCapitalized
        productPrice.text = product.variants?[0].price
        currencyLab.text = currency
        
        
    }
    
    @IBAction func addToShoppingCartBtn(_ sender: Any) {
        
        checkCustomerCart()
        print("add to shopping cart")
    }
    @IBAction func addToFavouritBtn(_ sender: Any) {
        print("add to fav")
        
        if(favourit.currentImage == (UIImage(systemName: "heart.fill"))){
            print("click product id  \(product.id)")
            favourit.setImage(UIImage(systemName: "heart"), for: .normal)
            checkCustomerFavs()
            
            
            // print("deleted clicked")
        }
        else{
           
             favourit.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            deleteFavProduct()
            //print("added to fav")
        }
    }
   
    
    
    func checkCustomerFavs(){
        let email = self.cartViewModel?.defaults.string(forKey: "email")
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
                        self.cartViewModel?.resDraft = draft
                        isExists = true
                        
                    }
                    else{
                        isNew = true
                    }
                }
                
                if(isExists){
                    self.putInCart(draft: self.cartViewModel?.resDraft ?? FavProduct())
                }
                
                if(isNew && isExists == false){
                    self.addNewFavList()
                }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
               // self.addToCartOutlet.isHidden = false
                
            }
        }
        
    }
      
    func putInFavsList(draft : FavProduct){
        var newDraft = draft
        newDraft.favOrShopping = Constant.IS_FAV
        self.cartViewModel?.draftId = String(draft.draftId ?? 0)
        newDraft.lineItems?.append(cartViewModel?.product ?? LineItems())
        var draft = Drafts(draftOrder: newDraft)
        cartViewModel?.editShoppingCart(draftOrder:draft, draftId: self.cartViewModel?.draftId ?? "")
        print("edit existing draftOrder  \(draft.draftOrder.lineItems?.count)")
        
    }
      func addNewFavList(){
          let email = self.cartViewModel?.defaults.string(forKey: "email")
          var lineItems = [cartViewModel?.product ?? LineItems()]
          var draft = FavProduct(email: email,lineItems: lineItems,favOrShopping: Constant.IS_FAV)
          cartViewModel?.saveShoppingCartInDatabase(favProduct: draft)
          cartViewModel?.bindResult = {() in
              let res = self.cartViewModel?.viewModelResult
              guard let draftOrder = res else {return}
          }
          
      }
      
      func deleteFavProduct(){
          
          if(self.cartViewModel?.resDraft?.lineItems?.count == 1){
              cartViewModel?.deleteFavListInDatabase(draftId: self.cartViewModel?.draftId ?? "", indexPath: nil, completion: nil)
              print("deleted from if")
              favourit.setImage(UIImage(systemName: "heart"), for: .normal)
          }else{
              
      favourit.setImage(UIImage(systemName: "heart"), for: .normal)
              var newProduct : [LineItems] = []
              var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
              favViewModel.getAllFav()
              favViewModel.bindResult = {() in
                  let res = favViewModel.viewModelResult
                  guard let allFav = res?.draftOrders else {return}
                  guard var customerFav = CustomerHelper.getFavForCustomers(favs: allFav) else {return}
                  self.cartViewModel?.resDraft = customerFav
                  self.cartViewModel?.products = customerFav.lineItems ?? [LineItems()]
                  guard let products = customerFav.lineItems else {return}
                  for i in 0..<products.count{
                      if(products[i].productId ==  String(self.cartViewModel?.product.productId ?? "")){
                          self.cartViewModel?.resDraft?.lineItems?.remove(at: i)
                          self.cartViewModel?.resDraft?.favOrShopping = Constant.IS_FAV
                          var newDraft = Drafts(draftOrder: self.cartViewModel?.resDraft ?? FavProduct())
                          self.cartViewModel?.editShoppingCart(draftOrder: newDraft, draftId: String(self.cartViewModel?.resDraft?.draftId ?? 0))
                          }
                      }
                  self.favourit.setImage(UIImage(systemName: "heart"), for: .normal)
              }
              
          }
              
          }
    
    
    func checkCustomerCart(){
        let email = self.cartViewModel?.defaults.string(forKey: "email")
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
                        self.cartViewModel?.resDraft = draft
                        isExists = true
                        
                    }
                    else{
                        isNew = true
                    }
                }
                if(isExists){
                    
                    self.putInCart(draft: self.cartViewModel?.resDraft ?? FavProduct())
                }
                if(isNew && isExists == false){
                    self.addNewCart()
                }
                
            }
        }
        
    }
    
    
    func putInCart(draft : FavProduct){
        var newDraft = draft
        self.cartViewModel?.draftId = String(draft.draftId ?? 0)
        var newProduct = cartViewModel?.product ?? LineItems()
        newDraft.lineItems?.append(newProduct)
        var draft = Drafts(draftOrder: newDraft)
        cartViewModel?.editShoppingCart(draftOrder:draft, draftId: self.cartViewModel?.draftId ?? "")
        print("edit existing draftOrder  \(draft.draftOrder.lineItems?.count)")
        
    }
    
    
    func addNewCart(){
        
        let email = self.cartViewModel?.defaults.string(forKey: "email")
        var lineItems = [cartViewModel?.product ?? LineItems()]
        var draft = FavProduct(email: email,lineItems: lineItems,favOrShopping: Constant.IS_SHOPPING_CART)
        self.cartViewModel?.saveShoppingCartInDatabase(favProduct: draft)
        self.cartViewModel?.bindResult = {() in
            let res = self.cartViewModel?.viewModelResult
            guard let draftOrder = res else {return}
        }
        
        
    }
    
}

