//
//  FavTableViewCell.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit
import Kingfisher

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var addToCartBtnOutlet: UIButton!
    @IBOutlet weak var productPrice: UILabel!
    
    var productInforViewModel = ProductInfoViewModel(repo: Repo(networkManager: NetworkManager()))
    var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
    var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(favProducts : [FavProduct],indexPath : IndexPath,currency:String){
        
        favViewModel.product = favProducts[indexPath.row].lineItems?[0] ?? LineItems()
        productInforViewModel.draftId = String(favProducts[indexPath.row].draftId ?? 0)
        productTitle.text = favProducts[indexPath.row].lineItems?[0].productTitle
        productPrice.text = favProducts[indexPath.row].lineItems?[0].productPrice ?? "0" + currency
        productImage.kf.setImage(with: URL(string: favProducts[indexPath.row].image ?? ""))
       
        productImage.layer.cornerRadius = 30
        productImage.layer.borderWidth = 0.2
        productImage.layer.borderColor = UIColor.black.cgColor
        
        UIView.elevationCardView(view: view)
    }
    @IBAction func addToCartBtn(_ sender: Any) {
        self.checkCustomerCart()
        print("add to cart in fav clickeddd")
        
    }
    
}
extension FavTableViewCell{
    
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
//
            }
            
            func getCustomerCart(drafts : [FavProduct])-> FavProduct?{
                var customerDraft : FavProduct!
                let email = self.favViewModel.defaults.string(forKey: "email")
                for draft in drafts {
                    if(draft.email == email && draft.favOrShopping == Constant.IS_SHOPPING_CART){
                        customerDraft = draft
                    }
                }
                return customerDraft
                
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

