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
    let defaults = UserDefaults.standard
    var customerFavList : [FavProduct] = []
    var productIds : [String] = []
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        getDrafts()
    }
    
    func setUpView(){
        favTable.dataSource = self
        favTable.delegate = self
        favTable.register(UINib(nibName: "FavTableViewCell", bundle: nil), forCellReuseIdentifier: "favCell")
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    func getDrafts(){
        viewModel.getAllFav()
        viewModel.bindResult = {() in
            let res = self.viewModel.viewModelResult
            guard let allFav = res else {return}
            guard var customerFav = self.getFavForCustomers(favs: allFav.draftOrders) else {return}
            for product in customerFav {
                self.productIds.append(product.lineItems?[0].productId ?? "")
            }
            if(self.productIds.count == 0 ){
                self.noFavImage()
                
            }else{
                let idsString = self.productIds.joined(separator: ",")
                self.viewModel.getFavProducts(ids: idsString)
                self.viewModel.bindResultProducts = {() in
                    let res = self.viewModel.favProductResult
                    guard let favProducts = res?.products else {return}
                    for i in 0..<customerFav.count {
                        for product in favProducts {
                            if customerFav[i].lineItems?[0].productId == String(product.id ?? 0) {
                                customerFav[i].image = product.image?.src
                            }
                        }
                    }
                    self.customerFavList = customerFav
                    for image in self.customerFavList{
                        print(image.image)
                    }
                    self.activityIndicator.isHidden = true
                    self.favTable.reloadData()
                }
                self.activityIndicator.isHidden = true
                self.favTable.reloadData()
            }
        }
    }
    func getFavForCustomers(favs : [FavProduct])-> [FavProduct]?{
        var favProducts : [FavProduct] = []
        let email = defaults.string(forKey: "email")
        for fav in favs {
            if(fav.email == email){
                favProducts.append(fav)
            }
        }
        return favProducts
        
    }
    func noFavImage(){
        // edit the image
        let imageView = UIImageView(image: UIImage(named: "NoFavImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        self.favTable.isHidden = true
        self.activityIndicator.isHidden = true
    }
    
    
}

extension FavouritesViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerFavList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavTableViewCell
        
        cell.configureCell(favProducts: customerFavList, indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var product = customerFavList[indexPath.row]
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                self.viewModel.deleteFavListInDatabase(draftId: String(product.draftId ?? 0))
                
                self.customerFavList.remove(at: indexPath.row)
                self.favTable.reloadData()
                if(self.customerFavList.count == 0){
                   // self.noFavImage()
                }
            }
                                        ))
            self.present(alert, animated: true)
            self.favTable.reloadData()
            
        }
    }
    
}
