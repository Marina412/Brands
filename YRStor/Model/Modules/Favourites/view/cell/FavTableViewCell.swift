//
//  FavTableViewCell.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit
import Kingfisher

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addToCartOutlet: UIButton!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var addToCartBtnOutlet: UIButton!
    @IBOutlet weak var productPrice: UILabel!
    
    var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
    var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
    var draftId = 0
    var draftt = Drafts(draftOrder: FavProduct())
    var index : IndexPath = IndexPath()
    let defaults = UserDefaults.standard
    var products : [LineItems] = [LineItems()]
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityIndicator.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell( draft : FavProduct,indexPath : IndexPath ,currency:String){
        cartViewModel.product = draft.lineItems?[indexPath.row] ?? LineItems()
        cartViewModel.draftId = String(draft.draftId ?? 0)
        defaults.double(forKey: "totalPrice")
        defaults.set(draft.totalPrice, forKey: "totalPrice")
        index = indexPath
        draftt.draftOrder  = draft
        draftId = draft.draftId ?? 0
        productTitle.text = draft.lineItems?[indexPath.row].productTitle
        productPrice.text = (draft.lineItems?[indexPath.row].productPrice ?? "0") + currency
       
        productImage.kf.setImage(with: URL(string:  draft.lineItems?[indexPath.row].productImage ?? ""))

     UIView.elevationCardView(view: view)
        
    }
    @IBAction func addToCartBtn(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        addToCartOutlet.isHidden = true
        self.checkCustomerCart()
        print("add to cart in fav clickeddd")
 
    }
    
}
extension FavTableViewCell{
   
    
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
                    
                    self.putInCart(draft: self.cartViewModel.resDraft ?? FavProduct())
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
        var newProduct = cartViewModel.product
        newDraft.lineItems?.append(newProduct)
        var draft = Drafts(draftOrder: newDraft)
        cartViewModel.editShoppingCart(draftOrder:draft, draftId: self.cartViewModel.draftId ?? "")
        print("edit existing draftOrder  \(draft.draftOrder.lineItems?.count)")
        
    }
    
    
    func addNewCart(){
        
        let email = self.cartViewModel.defaults.string(forKey: "email")
        var lineItems = [cartViewModel.product]
        var draft = FavProduct(email: email,lineItems: lineItems,favOrShopping: Constant.IS_SHOPPING_CART)
        self.cartViewModel.saveShoppingCartInDatabase(favProduct: draft)
        self.cartViewModel.bindResult = {() in
            let res = self.cartViewModel.viewModelResult
            guard let draftOrder = res else {return}
        }
        
        
    }
    
}

