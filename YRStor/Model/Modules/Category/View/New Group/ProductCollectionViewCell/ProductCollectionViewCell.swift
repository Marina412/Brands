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
    // var favProduct = FavProduct(lineItems: [LineItems()])
    var favProduct : FavProduct?
    var product = Product()
    //    var draftOrders : [FavProduct] = []
    var draftId  = ""
    var intDID = 0
    var isFave:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        shoppingCart.layer.cornerRadius = 18
        shoppingCart.layer.borderWidth = 0.5
        shoppingCart.layer.borderColor = UIColor.black.cgColor
    }
    
    
    func cellSetUp(product:Product){// ,currency:String){
        self.product = product
        
        productImage.kf.setImage(with: URL(string:product.image?.src ?? ""), placeholder: UIImage(named: "man"))
        productTitle.text = product.title?.localizedCapitalized
        productType.text = product.productType?.localizedCapitalized
        productPrice.text = product.variants?[0].price
        currencyLab.text = "EPY"//currency
        getDraftId()
    }
    @IBAction func addToShoppingCartBtn(_ sender: Any) {
        self.shoppingCart.setImage(UIImage(systemName: "cart.circle.fill"), for: .normal)
        print("add to shopping cart")
    }
    @IBAction func addToFavouritBtn(_ sender: Any) {
        getDraftId()
        print("add to fav")
        // isFave = !isFave
        if isFave{
            
            viewModel.deleteFavListInDatabase(draftId: "\(intDID)", indexPath: 0) {
                print("deleted from cell controller")
                self.favourit.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
        }
        else{
            favourit.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favProduct = FavProduct(email: viewModel.defaults.value(forKey: "email") as? String,lineItems: [LineItems(productId: String(product.id ?? 0),productTitle: product.title,productPrice: product.variants?[0].price, productImage: product.image?.src)], favOrShopping: Constant.IS_FAV)
            viewModel.saveFavProductToDatabase(favProduct: favProduct ?? FavProduct())
            
        }
    }
    
    func getDraftId(){
        viewModel.getAllFav()
        viewModel.bindResult = {() in
            let res = self.viewModel.viewModelResult
            guard let  res else {return}
            guard var customerDrafts = self.getCustomerDrafts(drafts: res.draftOrders) else {return}
            print("customer de \(customerDrafts)")
            for draft in customerDrafts {
                if(draft.lineItems?[0].productId == String(self.product.id ?? 0)){
                    self.draftId = String(draft.draftId ?? 0)
                    self.intDID = draft.draftId ?? 0
                    print(" second for loop ids\(draft.lineItems?[0].productId)")
                    self.isFave = true
                }
            }
        }
    }
    
    func getCustomerDrafts(drafts : [FavProduct])-> [FavProduct]?{
        var customerDrafts : [FavProduct] = []
        let email = viewModel.defaults.string(forKey: "email")
        for draft in drafts {
            if(draft.email == email && draft.favOrShopping == Constant.IS_FAV){
                customerDrafts.append(draft)
            }
        }
        return customerDrafts
        
    }
}

