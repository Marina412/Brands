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
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let isLoggin = defaults.bool(forKey: "isLogging")
        defaults.set(Constant.IS_FAV, forKey: "isFavOrCart")
        if (isLoggin == false){
            favTable.isHidden = true
            self.defaults.set(Constant.IS_FAV, forKey: "isFavOrCart")
            let register = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            self.navigationController?.pushViewController(register, animated: true)
        }
        else if (isLoggin == true){
            setUpView()
            getDrafts()
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
    func getDrafts(){
        viewModel.getAllFav()
        viewModel.bindResult = {() in
            let res = self.viewModel.viewModelResult
            guard let allFav = res else {return}
            guard var customerFav = self.getFavForCustomers(favs: allFav.draftOrders) else {return}
            for product in customerFav {
                self.viewModel.productIds.append(product.lineItems?[0].productId ?? "")
            }
            if(self.viewModel.productIds.count == 0 ){
                self.noFavImage()
                
            }else{
                let idsString = self.viewModel.productIds.joined(separator: ",")
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
                    self.viewModel.customerFavList = customerFav
                    for image in self.viewModel.customerFavList{
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
        let email = viewModel.defaults.string(forKey: "email")
        for fav in favs {
            if(fav.email == email && fav.favOrShopping == Constant.IS_FAV){
                favProducts.append(fav)
            }
        }
        return favProducts
        
    }
    func noFavImage(){
        // edit the image
        let imageView = UIImageView(image: UIImage(named: "noFavImage"))
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
        return viewModel.customerFavList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavTableViewCell
        
        cell.configureCell(favProducts: viewModel.customerFavList, indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var product = viewModel.customerFavList[indexPath.row]
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                
                self.viewModel.deleteFavListInDatabase(draftId: String(product.draftId ?? 0),indexPath: indexPath.row,completion: {
                    self.viewModel.customerFavList.remove(at: indexPath.row)
                    self.favTable.reloadData()
                    if(self.viewModel.customerFavList.count == 0){
                        self.noFavImage()
                        
                    }
                })
               
            }
                                         ))
            self.present(alert, animated: true)
            self.favTable.reloadData()
            
        }
    }
    
}
