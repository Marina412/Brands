//
//  ShoppingBagViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 06/06/2023.
//

import UIKit

class ShoppingCartViewController: UIViewController {
    
    @IBOutlet weak var numberOfItem: UILabel!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPricee: UILabel!
     @IBOutlet weak var cartTable: UITableView!
     var viewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
     var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
    let activityIndicator = UIActivityIndicatorView(style: .large)
   
     override func viewDidLoad() {
         super.viewDidLoad()
       
     }
    override func viewWillAppear(_ animated: Bool) {
            let defaults = UserDefaults.standard
            let isLoggin = defaults.bool(forKey: "isLogging")
           defaults.set(Constant.IS_SHOPPING_CART, forKey: "isFavOrCart")
            if (isLoggin == false){
                defaults.set(Constant.IS_SHOPPING_CART, forKey: "isFavOrCart")
                cartTable.isHidden = true
                checkoutBtn.isHidden = true
                totalLabel.isHidden = true
                totalPricee.isHidden = true
                numberOfItem.isHidden = true
                let register = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                self.navigationController?.pushViewController(register, animated: true)
            }
            else{
                setUpView()
                getDrafts()
            }
        }
     func setUpView(){
         
         cartTable.dataSource = self
         cartTable.delegate = self
         cartTable.register(UINib(nibName: "ShoppingCartCell", bundle: nil), forCellReuseIdentifier: "cartCell")
         activityIndicator.center = view.center
         activityIndicator.color = UIColor.black
         view.addSubview(activityIndicator)
         activityIndicator.startAnimating()
     }
     func getDrafts(){
         
         viewModel.getAllFav()
         viewModel.bindResult = {() in
             let res = self.viewModel.viewModelResult
             guard let allDrafts = res else {return}
             guard var customerDraft = self.getCustomerCart(drafts: allDrafts.draftOrders) else {return}
             guard var customerCartProducts = customerDraft.lineItems else {return}
             self.cartViewModel.resDraft = customerDraft
             self.cartViewModel.products = customerCartProducts
             for product in self.cartViewModel.products{
                 self.viewModel.productIds.append(product.productId ?? "")
               //  print(self.viewModel.productIds)
             }
             if(self.viewModel.productIds.count == 0 ){
                 self.noShopCartImage()
             }
             else{
                 let idsString = self.viewModel.productIds.joined(separator: ",")
                 self.viewModel.getFavProducts(ids: idsString)
                 self.viewModel.bindResultProducts = {() in
                     let res = self.viewModel.favProductResult
                     guard let cartProducts = res?.products else {return}
                     for i in 0..<customerCartProducts.count{
                         for product in cartProducts {
                             if(customerCartProducts[i].productId == String(product.id ?? 0)){
                                 customerCartProducts[i].productImage = product.image?.src
                             }
                         }
                     }
                     self.cartViewModel.products = customerCartProducts
                     self.cartViewModel.resDraft = customerDraft
                     self.cartViewModel.resDraft.lineItems = customerCartProducts
                     self.cartViewModel.draft.draftOrder = self.cartViewModel.resDraft
                     self.cartViewModel.draftId = String(customerDraft.draftId ?? 0)
                     self.cartTable.reloadData()
                     self.totalPricee.text = customerDraft.totalPrice
                 }
             }
         }
     }
     func getCustomerCart(drafts : [FavProduct])-> FavProduct?{
         var customerDraft : FavProduct!
         let email = viewModel.defaults.string(forKey: "email")
         for draft in drafts {
             if(draft.email == email && draft.favOrShopping == Constant.IS_SHOPPING_CART){
                 customerDraft = draft
             }
         }
         return customerDraft
         
     }
     func noShopCartImage(){
         let imageView = UIImageView(image: UIImage(named: "noShoppingBag"))
         imageView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(imageView)
         
         NSLayoutConstraint.activate([
             imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             imageView.widthAnchor.constraint(equalToConstant: 100),
             imageView.heightAnchor.constraint(equalToConstant: 100)
         ])
         self.cartTable.isHidden = true
         self.totalPricee.isHidden = true
     }
     
    @IBAction func checkoutBtn(_ sender: Any) {
        let checkout = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        checkout.checkOutItems = cartViewModel.resDraft
         self.navigationController?.pushViewController(checkout, animated: true)
    }
}
 extension ShoppingCartViewController : UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return cartViewModel.products.count
     }
     
  
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! ShoppingCartCell
         
         cell.configureCell(draft: cartViewModel.resDraft, indexPath: indexPath)
         cell.cellViewModel.stepperAction = { [weak self] totalPrice in
             self?.totalPricee.text = String(totalPrice)
             
         }
         
         return cell
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 200
     }
     
     
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         var product = self.cartViewModel.resDraft.lineItems?[indexPath.row]
         if editingStyle == .delete {
             let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
             alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                 
                
                 if(self.cartViewModel.resDraft.lineItems?.count == 1 ){
                     self.cartViewModel.deleteFavListInDatabase(draftId: self.cartViewModel.draftId, indexPath: indexPath.row, completion: {
                         self.cartTable.isHidden = true
                         self.noShopCartImage()
                         self.totalPricee.text = "0.0"
                     })
                 }
                 else{
                     self.cartViewModel.products.remove(at: indexPath.row)
                     self.cartViewModel.resDraft.lineItems = self.cartViewModel.products
                     self.cartViewModel.draft.draftOrder = self.cartViewModel.resDraft
                     self.cartTable.reloadData()
                     self.cartViewModel.editShoppingCart(draftOrder: self.cartViewModel.draft, draftId: self.cartViewModel.draftId)
                    
                 }
                
             }
                                          ))
             self.present(alert, animated: true)
             
            
             
         }
     }
     
     
 }







