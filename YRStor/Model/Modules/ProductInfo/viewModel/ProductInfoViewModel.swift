//
//  ProductInfoViewModel.swift
//  YRStor
//
//  Created by Huda kamal  on 18/06/2023.
//

import Foundation

class ProductInfoViewModel{
    
   
    var productImages : [ProductImage]!
   
    var repo:RepoProtocol
    
    init(repo: RepoProtocol) {
        
        self.repo = repo
    }
}
