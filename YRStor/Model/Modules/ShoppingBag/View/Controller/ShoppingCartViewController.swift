//
//  ShoppingBagViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 06/06/2023.
//

import UIKit

class ShoppingCartViewController: UIViewController {
    
    @IBOutlet weak var totalItemsLb: UILabel!
    @IBOutlet weak var checkOutletBtn: UIButton!
    @IBOutlet weak var numberOfItem: UILabel!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var cartTable: UITableView!
    var viewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
    var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let noDataImage  = UIImageView(image: UIImage(named: "noShoopingCart"))
    var totalPrice = ""
    let defaults = UserDefaults.standard
    var shoppingCountKeyPath = #keyPath(UserDefaults.shoppingBag)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
       
    }
    override func viewWillAppear(_ animated: Bool) {
        defaults.addObserver(self, forKeyPath: shoppingCountKeyPath, options: .new, context: nil)
        defaults.shoppingBag = defaults.integer(forKey: "shopBagCount")
        
    }
    deinit{
        defaults.removeObserver(self, forKeyPath: shoppingCountKeyPath)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard (object as? UserDefaults) === defaults,
                      keyPath == shoppingCountKeyPath,
                      let change = change
                else { return }
                
        var itemNumbers = cartViewModel.resDraft?.lineItems?.count ?? 0
                if let updatedCount = change[.newKey] as? Int {
                    (tabBarController!.tabBar.items![2] as! UITabBarItem).badgeValue = "\(itemNumbers)"
                }
        
        let defaults = UserDefaults.standard
        let isLoggin = defaults.bool(forKey: "isLogging")
        defaults.set(Constant.IS_SHOPPING_CART, forKey: "isFavOrCart")
        if (isLoggin == false){
            defaults.set(Constant.IS_SHOPPING_CART, forKey: "isFavOrCart")
            cartTable.isHidden = true
            checkoutBtn.isHidden = true
            totalPriceLbl.isHidden = true
            numberOfItem.isHidden = true
            activityIndicator.isHidden = true
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
        cartTable.register(UINib(nibName: "ShopCart", bundle: nil), forCellReuseIdentifier: "ShopCart")
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        view.addSubview(noDataImage)
        
    }
    func getDrafts(){
        viewModel.getAllFav()
        viewModel.bindResult = {() in
            let res = self.viewModel.viewModelResult
            guard let allDrafts = res else {return}
            guard var customerDraft = CustomerHelper.getCustomerCart(drafts: allDrafts.draftOrders) else {return}
            if(customerDraft.lineItems?.count != nil){
                
                self.noDataImage.isHidden = true
                self.cartTable.isHidden = false
                self.cartTable.reloadData()
            }
            guard var customerCartProducts = customerDraft.lineItems else {return}
            self.cartViewModel.resDraft = customerDraft
            self.cartViewModel.products = customerCartProducts
            for product in self.cartViewModel.products{
                self.cartViewModel.productIds.append(product.productId ?? "")
            }
            
            
            let idsString = self.cartViewModel.productIds.joined(separator: ",")
            self.viewModel.getFavProducts(ids: idsString)
            self.viewModel.bindResultProducts = {() in
                let res = self.viewModel.favProductResult
                guard let cartProducts = res?.products else {return}
                self.cartViewModel.cartProductsDetails = cartProducts
                for i in 0..<customerCartProducts.count{
                    for product in cartProducts {
                        if(customerCartProducts[i].productId == String(product.id ?? 0)){
                            customerCartProducts[i].productImage = product.image?.src
                        }
                    }
                }
             
                self.cartViewModel.products = customerCartProducts
                self.cartViewModel.resDraft = customerDraft
                self.cartViewModel.resDraft?.lineItems = customerCartProducts
                self.cartViewModel.draft.draftOrder = self.cartViewModel.resDraft ?? FavProduct()
                self.cartViewModel.draftId = String(customerDraft.draftId ?? 0)
                self.cartTable.reloadData()
                self.activityIndicator.isHidden = true
                guard let totalPrice = customerDraft.totalPrice else {return}
                self.totalPrice = totalPrice
                self.totalPriceLbl.text = "Total :\(totalPrice)"
            
                self.totalItemsLb.text = "Items : \(String(customerCartProducts.count))"
                
            }
        }
    }
    
    

    
    @IBAction func checkoutBtn(_ sender: Any) {
        let checkout = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        checkout.checkOutItems = cartViewModel.resDraft ?? FavProduct()
        self.navigationController?.pushViewController(checkout, animated: true)
    }
}
extension ShoppingCartViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.products.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCart", for: indexPath) as! ShopCart
        
        cell.configureCell(draft: cartViewModel.resDraft ?? FavProduct(), indexPath: indexPath,currency: viewModel.curencyType)
        cell.cellViewModel.stepperAction = { [weak self] totalPrice  in
            self?.totalPriceLbl.text = "Total :  \(String(totalPrice))"

            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var product = self.cartViewModel.resDraft?.lineItems?[indexPath.row]
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                
                if(self.cartViewModel.resDraft?.lineItems?.count == 1 ){
                    self.cartViewModel.deleteFavListInDatabase(draftId: self.cartViewModel.draftId, indexPath: indexPath.row, completion: {
                        
                        
                        UikitHelper.noDataImage(image: self.noDataImage, view: self.view, table: self.cartTable, activityIndicator: self.activityIndicator)
                        self.noDataImage.isHidden = false
                        self.totalPriceLbl.isHidden = true
                        self.numberOfItem.isHidden = true
                        self.checkoutBtn.isHidden = true
                        
                    })
                }
                else{
                    self.cartViewModel.products.remove(at: indexPath.row)
                    self.cartViewModel.resDraft?.lineItems = self.cartViewModel.products
                    self.cartViewModel.draft.draftOrder = self.cartViewModel.resDraft ?? FavProduct()
//                    
//                    var totalPrice = self.cartViewModel.defaults.value(forKey: "totalPrice") as! Double
//                    var test = (Double(product?.productPrice ?? "") ?? 0.0)  * (Double(product?.quantity ?? Int(1.0)))
//                    var totalPriceUpdated = totalPrice -  test
//                    self.totalPriceLbl.text = String(totalPriceUpdated)
                    self.totalItemsLb.text = "Items : \(String(self.cartViewModel.products.count))"
                    self.cartTable.reloadData()
                    self.cartViewModel.editShoppingCart(draftOrder: self.cartViewModel.draft, draftId: self.cartViewModel.draftId)
                    
                }
                
            }
                                         ))
            self.present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var productSelected = cartViewModel.resDraft?.lineItems?[indexPath.row]
        var newProduct = Product()
        for product in cartViewModel.cartProductsDetails{
            if(String(product.id ?? 0 ) == productSelected?.productId ){
                newProduct.id = product.id
                newProduct.bodyHTML = product.bodyHTML
                newProduct.title = product.title
                newProduct.images = product.images
                newProduct.variants?[0].price = product.variants?[0].price
            }
            
        }
        let productInfo = self.storyboard?.instantiateViewController(withIdentifier: "ProductInfoViewController") as! ProductInfoViewController
        productInfo.product = newProduct
        self.navigationController?.pushViewController(productInfo, animated: true)
        
    }
}









