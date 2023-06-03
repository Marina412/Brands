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

class SearchViewController: UIViewController {
    @IBOutlet weak var allProductsTable: UITableView!
    
    var productsIds : [String] = []
    var allProductsArr = BehaviorRelay<[Product]>(value: [])
    var filteredProductsArr = BehaviorRelay<[Product]>(value: [])
    let disBag = DisposeBag()
    let repo = Repo(networkManager: NetworkManager())
    let searchViewModel = SearchViewModel(repo: Repo(networkManager: NetworkManager()))
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allProductsTable.isHidden = true
        createSearchBar()
        setSearchBarConstarnits()
        searchViewModel.getAllProducts()
        searchViewModel.bindResult = {() in
            let res = self.searchViewModel.viewModelResult
            guard let allproducts = res else {return}
            self.allProductsArr.accept(allproducts)
            self.filteredProductsArr.accept(allproducts)
            self.rxTabelViewHandel()
            
        }
        
        
    }
    func createSearchBar(){
        allProductsTable.tableHeaderView = searchController.searchBar
        
        // Set the search controller's searchResultsUpdater property to self.
        searchController.searchResultsUpdater = self
        
        // Configure the search controller.
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Products"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
    func setSearchBarConstarnits(){
        
        
        view.addSubview( searchController.searchBar)
        
        //        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        //        let searchBarLeadingConstraint =  searchController.searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        //        let searchBarTrailingConstraint =  searchController.searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        //        let topConstraint = searchController.searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        //
        //        NSLayoutConstraint.activate([topConstraint,searchBarLeadingConstraint, searchBarTrailingConstraint])
    }
    
}

extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //allProductsTable.isHidden = false
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let filteredItems = allProductsArr.value.filter { item in
                return item.title.lowercased().contains(searchText.lowercased())
            }
            filteredProductsArr.accept(filteredItems)
            allProductsTable.reloadData()
        } else {
            filteredProductsArr.accept(allProductsArr.value)
        }
    }
}

