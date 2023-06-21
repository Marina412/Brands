//
//  SearchViewController.swift
//  YRStor
//
//  Created by Huda kamal  on 03/06/2023.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift
import Reachability

class SearchViewController: UIViewController ,UISearchBarDelegate {
    @IBOutlet weak var allProductsTable: UITableView!
    var reachability = try! Reachability()
    var productsIds : [String] = []
    var allProductsArr = BehaviorRelay<[Product]>(value: [])
    var filteredProductsArr = BehaviorRelay<[Product]>(value: [])
    let disBag = DisposeBag()
    let repo = Repo(networkManager: NetworkManager())
    let searchViewModel = SearchViewModel(repo: Repo(networkManager: NetworkManager()))
    let authViewModel = AuthViewModel(repo: Repo(networkManager: NetworkManager()))
    let searchBar = UISearchBar()
    let noSearchImage = UIImageView()
    let defaults = UserDefaults.standard
    let networkManager = NetworkManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set(Constant.IS_PRODUCT_INFO, forKey: "isFavOrCart")
        defaults.set(true, forKey: "isLogging")
        tabBarController?.tabBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        allProductsTable.isHidden = true
        selectedItem()
        setUpSearcBar()
        searchViewModel.getAllProducts()
        searchViewModel.bindResult = {() in
            let res = self.searchViewModel.viewModelResult
            guard let allproducts = res else {return}
            self.allProductsArr.accept(allproducts)
            self.filteredProductsArr.accept(allproducts)
            self.rxTabelViewHandel()
        }
        
        authViewModel.getAllCustomers()
        authViewModel.bindResult = {() in
            let res = self.authViewModel.viewModelResult
            guard let allCustomers = res else {return}
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) { }
    override func viewDidDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    
    func rxTabelViewHandel(){
        
        filteredProductsArr.bind(to: allProductsTable
            .rx
            .items(cellIdentifier: "productCell")) {
                (tv,item,cell) in
                cell.textLabel?.text = item.title
            }
        
            .disposed(by: disBag)
    }
    
    func setUpSearcBar(){
        searchBar.delegate = self
        searchBar.placeholder = "Products Search"
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        allProductsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            allProductsTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            allProductsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            allProductsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            allProductsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(noSearchImage)
        noSearchImage.translatesAutoresizingMaskIntoConstraints = false
        noSearchImage.image = UIImage(named: "searchImage")
        
        NSLayoutConstraint.activate([
            noSearchImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noSearchImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (reachability.connection != .unavailable){
            if !searchText.isEmpty {
                self.noSearchImage.isHidden = true
                let filteredItems = allProductsArr.value.filter { item in
                    return item.title?.lowercased().contains(searchText.lowercased()) ?? false
                }
                
                allProductsTable.isHidden = false
                filteredProductsArr.accept(filteredItems)
                allProductsTable.reloadData()
            } else {
                self.noSearchImage.isHidden = false
                filteredProductsArr.accept([])
            }
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline,Plz check connectivity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
           
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    func selectedItem(){
        if (reachability.connection != .unavailable){
            
            allProductsTable.rx
                .modelSelected(Product.self)
                .subscribe(onNext: {
                    txt in
                    
                    let productVc = self.storyboard?.instantiateViewController(withIdentifier: "ProductInfoViewController")
                    as! ProductInfoViewController
                    productVc.product = txt
                    self.navigationController?.pushViewController(productVc, animated: true)
                }).disposed(by: disBag)
        }
        else{
            let alert = UIAlertController(title: "Goallll", message: " Sorry!! you are offline", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
           
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    
}

