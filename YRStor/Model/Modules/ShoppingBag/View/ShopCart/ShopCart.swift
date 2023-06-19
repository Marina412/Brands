//
//  ShopCart.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 18/06/2023.
//

import UIKit

class ShopCart: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQunatity: UILabel!
    @IBOutlet weak var stepperOulet: UIStepper!
    
    
    let cellViewModel = ShoppingCellViewModel(repo: Repo(networkManager: NetworkManager()))
    var productPriceValue : String = ""
    var stepperClicked = false
    var draftId = 0
    var draftt = Drafts(draftOrder: FavProduct())
    var index : IndexPath = IndexPath()
    let defaults = UserDefaults.standard
    var products : [LineItems] = [LineItems()]
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureCell( draft : FavProduct,indexPath : IndexPath ,currency:String){
        defaults.double(forKey: "totalPrice")
        defaults.set(draft.totalPrice, forKey: "totalPrice")
        index = indexPath
        draftt.draftOrder  = draft
        draftId = draft.draftId ?? 0
        productTitle.text = draft.lineItems?[indexPath.row].productTitle
        productPrice.text = (draft.lineItems?[indexPath.row].productPrice ?? "0") + currency
        self.productPriceValue = draft.lineItems?[indexPath.row].productPrice ?? ""
        productImage.kf.setImage(with: URL(string:  draft.lineItems?[indexPath.row].productImage ?? ""))
        
        guard let quantity = draft.lineItems?[indexPath.row].quantity else {return}
        productQunatity.text = "\(quantity)"
        stepperOulet.value = Double(quantity)
        
        
        
    }
    
    
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        var totalPrice = defaults.double(forKey: "totalPrice")
        
        if sender.value > Double(productQunatity.text ?? "") ?? 0.0 {
            
            UserDefaults.standard.shoppingBag = HelperFunctions.shopBagCount(itemCount: 1,plusOrMinus: "plus")
            totalPrice = totalPrice + ((draftt.draftOrder.lineItems?[index.row].productPrice ?? "") as NSString).doubleValue
            defaults.set(totalPrice, forKey: "totalPrice")
            productQunatity.text = "\(Int(stepperOulet.value))"
            draftt.draftOrder.lineItems?[index.row].quantity = Int(stepperOulet.value)
            cellViewModel.updateQuantity(draftOrder: self.draftt, draftId:String(draftId))
 
        } else if sender.value < Double(productQunatity.text ?? "") ?? 0.0  {
            UserDefaults.standard.shoppingBag = HelperFunctions.shopBagCount(itemCount: 1,plusOrMinus: "minus")
            totalPrice = totalPrice - ((draftt.draftOrder.lineItems?[index.row].productPrice ?? "") as NSString).doubleValue
            defaults.set(totalPrice, forKey: "totalPrice")
            productQunatity.text = "\(Int(stepperOulet.value))"
            draftt.draftOrder.lineItems?[index.row].quantity = Int(stepperOulet.value)
            cellViewModel.updateQuantity(draftOrder: self.draftt, draftId: String(draftId))
        }
        
        cellViewModel.stepperAction?(totalPrice )
        print(" total price \(totalPrice)")
    }
    
    
}
