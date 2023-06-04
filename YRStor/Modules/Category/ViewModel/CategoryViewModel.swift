//
//  CategoryViewModel.swift
//  YRStor
//
//  Created by marina on 02/06/2023.
//

import Foundation
class CategoryViewModel{
    let repo:RepoProtocol
    
    var allProducts:[Product]=[]
    var filteredMainCategoryProduct : [Product]=[]
    
    init(repo:RepoProtocol) {
        self.repo = repo
    }
    func getAllProductsFromApi(collectionId:Int,completion: @escaping ()->()){
        allProducts.removeAll()
        repo.getProductsByCollectionId(collectionId: collectionId) { [weak self] productsResult in
            guard let self else { return }
            guard let productsResult else {return}
            print("\n\n sub count \(productsResult.count)\n\n ")
            for product in productsResult{
                self.allProducts.append(product)
            }
            completion()
        }
    }
    
    
    func getAllProductsFromApiAndFilterByMainCategorry(categoryId:Int,brandName:String,completion: @escaping ()->()){
        filteredMainCategoryProduct.removeAll()
        repo.getProductsByCollectionId(collectionId: categoryId) { [weak self] productsResult in
            guard let self else { return }
            guard let productsResult else {return}
            print("\n\n main count \(productsResult.count) \n\n")
//            self.filteredMainCategoryProduct = productsResult.filter({ product in
//                product.vendor?.lowercased() == brandName.lowercased()
//            })
            for product in productsResult{
                    self.filteredMainCategoryProduct.append(product)
            }
            completion()
        }
    }
}
