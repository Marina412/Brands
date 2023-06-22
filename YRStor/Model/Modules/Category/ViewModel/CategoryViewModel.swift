//
//  CategoryViewModel.swift
//  YRStor
//
//  Created by marina on 02/06/2023.
//

import Foundation
import RxSwift
class CategoryViewModel{
    let repo:RepoProtocol
    var allProducts:[Product]=[]
    var allProductsIDs:[Int]=[]
    let disposeBag = DisposeBag()
    var filterProducts:[Product]=[]
    var poductsObservablRS : ReplaySubject <[Product]> = ReplaySubject<[Product]>.create(bufferSize: 10)
    init(repo:RepoProtocol) {
        self.repo = repo
    }
    
    func getAllProductsFromApiByCategorry(completion: @escaping ()->()){
        allProductsIDs.removeAll()
        repo.getAllProducts() {
            [weak self] productsResult in
            guard let self else { return }
            guard let productsResult else {return}
            print(productsResult.count)
            for product in productsResult{
                self.allProductsIDs.append(product.id ?? 0)
            }
            completion()
        }
    }
    func getAllPoductsPricesFromApi(completion: @escaping ()->()){
        allProducts.removeAll()
        repo.getAllProductsPrice(productIds:allProductsIDs){[weak self] productsResult in
            guard let self else { return }
            guard let productsResult else {return}
            for product in productsResult{
                self.allProducts.append(product)
            }
            completion()
        }
    }

    func setUpData(completion: @escaping ()->()){
        getAllProductsFromApiByCategorry{
            [weak self ]  in
            guard let self else {return}
            self.getAllPoductsPricesFromApi{
                self.poductsObservablRS.onNext(self.allProducts)
                completion()
            }
        }
    }
    
    func filterProudactsByMainCategory(categoryName:String){
        print(categoryName)
        if categoryName != ""
        {
            let filteredProducts : [Product] = allProducts.filter({
                
               return $0.tags?.lowercased().contains(categoryName.lowercased()) == true
               
            })
            filterProducts = filteredProducts
            poductsObservablRS.onNext(filteredProducts)
        }
        else{
            poductsObservablRS.onNext(allProducts)
        }
    }
    func filterProudactsBySubCategory(categoryName:String){
        if categoryName != ""
        {
            let filteredProducts : [Product] = allProducts.filter({
                $0.productType?.lowercased() == categoryName.lowercased()
            })
            filterProducts = filteredProducts
            poductsObservablRS.onNext(filteredProducts)
        }
        else{
            poductsObservablRS.onNext(allProducts)
        }
    }
    func filterProudacts(searchText:String){
        if searchText != ""
        {
            let filteredProducts : [Product] = allProducts.filter({
                $0.variants?[0].price?.lowercased().contains(searchText.lowercased()) == true ||
                $0.productType?.lowercased().contains(searchText.lowercased()) == true ||
                $0.title?.lowercased().contains(searchText.lowercased()) == true
            })
            filterProducts = filteredProducts
            poductsObservablRS.onNext(filteredProducts)
        }
        else{
            poductsObservablRS.onNext(allProducts)
        }
    }
  
}
