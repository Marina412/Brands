//
//  BrandProductsViewModel.swift
//  YRStor
//
//  Created by marina on 06/06/2023.
//

import Foundation
import RxSwift

class BrandProductsViewModel{
    let repo:RepoProtocol
    var allProducts:[Product]=[]
    var filterProducts:[Product]=[]
    var allProductsIDs:[Int]=[]
    let disposeBag = DisposeBag()
    var poductsObservablRS : ReplaySubject <[Product]> = ReplaySubject<[Product]>.create(bufferSize: 10)
    
    init(repo:RepoProtocol) {
        self.repo = repo
    }
    
    func getAllProductsFromApiByCategorry(collectionId:Int,completion: @escaping ()->()){
        allProductsIDs.removeAll()
        repo.getProductsByCollectionId(collectionId: collectionId) {
            [weak self] productsResult in
            guard let self else { return }
            guard let productsResult else {return}
            
            for product in productsResult{
                self.allProductsIDs.append(product.id!)
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
    func setUpData(brandId:Int,completion: @escaping ()->()){
        getAllProductsFromApiByCategorry(collectionId:brandId){
            [weak self ]  in
            guard let self else {return}
            self.getAllPoductsPricesFromApi(){
                self.poductsObservablRS.onNext(self.allProducts)
                completion()
            }
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
