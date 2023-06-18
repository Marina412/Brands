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

class SearchViewController: UIViewController ,UISearchBarDelegate {
    @IBOutlet weak var allProductsTable: UITableView!
    
    var productsIds : [String] = []
    var allProductsArr = BehaviorRelay<[Product]>(value: [])
    var filteredProductsArr = BehaviorRelay<[Product]>(value: [])
    let disBag = DisposeBag()
    let repo = Repo(networkManager: NetworkManager())
    let searchViewModel = SearchViewModel(repo: Repo(networkManager: NetworkManager()))
    let authViewModel = AuthViewModel(repo: Repo(networkManager: NetworkManager()))
    let searchBar = UISearchBar()
    let noSearchImage = UIImageView()
    
    let networkManager = NetworkManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //allProductsTable.isHidden = false
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
    func selectedItem(){
        allProductsTable.rx
            .modelSelected(Product.self)
            .subscribe(onNext: {
                txt in
                
                //self.performSegue(withIdentifier: "ProductInfoViewController", sender: self)

                let productVc = self.storyboard?.instantiateViewController(withIdentifier: "ProductInfoViewController")
                as! ProductInfoViewController
                productVc.product = txt
                self.navigationController?.pushViewController(productVc, animated: true)
            }).disposed(by: disBag)

    }
    
}

