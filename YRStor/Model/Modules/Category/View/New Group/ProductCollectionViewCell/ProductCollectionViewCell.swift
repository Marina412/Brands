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
    
    
    
    var viewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
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
    
    
    func cellSetUp(product:Product,currency:String){
        
        self.favProduct = FavProduct(email: viewModel.defaults.value(forKey: "email") as? String,lineItems: [LineItems(productId: String(product.id ?? 0),productTitle: product.title,productPrice: product.variants?[0].price, productImage: product.image?.src)], favOrShopping: Constant.IS_FAV)
        self.product = product
        getDraftId()
        productImage.kf.setImage(with: URL(string:product.image?.src ?? ""), placeholder: UIImage(named: "man"))
        productTitle.text = product.title?.localizedCapitalized
        productType.text = product.productType?.localizedCapitalized
        productPrice.text = product.variants?[0].price
        currencyLab.text = currency
       
    }
    @IBAction func addToShoppingCartBtn(_ sender: Any) {
        self.shoppingCart.setImage(UIImage(systemName: "cart.circle.fill"), for: .normal)
        print("add to shopping cart")
    }
    @IBAction func addToFavouritBtn(_ sender: Any) {
        print("add to fav")
 
        if(favourit.currentImage == (UIImage(systemName: "heart.fill"))){
            
            favourit.setImage(UIImage(systemName: "heart"), for: .normal)
            viewModel.deleteFavListInDatabase(draftId: self.draftId, indexPath: 0) {
                
            }
            
            
            print("deleted clicked")
        }
        else{
             
            favourit.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            viewModel.saveFavProductToDatabase(favProduct: favProduct ?? FavProduct())
            print("added to fav")
        }
    }
    
    func getDraftId(){
        viewModel.getAllFav()
        viewModel.bindResult = {() in
            let res = self.viewModel.viewModelResult
            guard let allDrafts = res else {return}
            guard var customerDrafts = CustomerHelper.getFavForCustomers(favs: allDrafts.draftOrders) else {return}
            for draft in customerDrafts {
                if(draft.lineItems?[0].productId == String(self.product.id ?? 0)){
                    self.draftId = String(draft.draftId ?? 0)
                }
                guard let products = draft.lineItems else {return}
                for id in products{

                    if(id.productId == String(self.product.id ?? 0)){
                        print("ids equal each other second loop ")
                        self.favourit.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                }
            }
        }
    }

}


