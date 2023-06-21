//
//  FavouritesViewController.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var favTable: UITableView!
    var viewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
    var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let defaults = UserDefaults.standard
    let imageView = UIImageView(image: UIImage(named: "noFavImage"))
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        print(" cart view model arrayyy \(cartViewModel.resDraft?.lineItems)")
     
        let isLoggin = defaults.bool(forKey: "isLogging")
        defaults.set(Constant.IS_FAV, forKey: "isFavOrCart")
        if (isLoggin == false){
            favTable.isHidden = true
            self.defaults.set(Constant.IS_FAV, forKey: "isFavOrCart")
            let register = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            self.navigationController?.pushViewController(register, animated: true)
        }
        else if (isLoggin == true){
            favTable.reloadData()
            setUpView()
            getDrafts()
        }
    }
    
//    self.cartViewModel.resDraft = nil
//        self.favTable.reloadData()
    func getDrafts(){
        viewModel.getAllFav()
        viewModel.bindResult = {() in
            
            let res = self.viewModel.viewModelResult
            guard let allDrafts = res else {return}
            
            self.favTable.reloadData()
            guard var customerDraft = CustomerHelper.getFavForCustomers(favs: allDrafts.draftOrders) else {return }
            if(customerDraft.lineItems?.count == nil){
                UikitHelper.noDataImage(image: self.imageView, view: self.view, table: self.favTable, activityIndicator: self.activityIndicator)
                self.imageView.isHidden = false
            }else if(customerDraft.lineItems?.count != nil){
                self.imageView.isHidden = true
                self.favTable.isHidden = false
                self.favTable.reloadData()
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
                self.favTable.reloadData()
                self.activityIndicator.isHidden = true

                
            }
        }
    }

    
    func setUpView(){
        self.navigationItem.setHidesBackButton(true, animated: false)
        favTable.dataSource = self
        favTable.delegate = self
        favTable.register(UINib(nibName: "FavTableViewCell", bundle: nil), forCellReuseIdentifier: "favCell")
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
}

    

extension FavouritesViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavTableViewCell
        cell.configureCell(draft: cartViewModel.resDraft ?? FavProduct(), indexPath: indexPath,currency: viewModel.curencyType)
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                if(self.cartViewModel.resDraft?.lineItems?.count == 1 ){
                    self.cartViewModel.deleteFavListInDatabase(draftId: self.cartViewModel.draftId, indexPath: indexPath.row, completion: {
                        
                        
                        UikitHelper.noDataImage(image: self.imageView, view: self.view, table: self.favTable, activityIndicator: self.activityIndicator)
                        self.imageView.isHidden = false
                    })
                }
                else{
                    self.cartViewModel.products.remove(at: indexPath.row)
                    self.cartViewModel.resDraft?.lineItems = self.cartViewModel.products
                    self.cartViewModel.draft.draftOrder = self.cartViewModel.resDraft ?? FavProduct()
                    self.favTable.reloadData()
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
