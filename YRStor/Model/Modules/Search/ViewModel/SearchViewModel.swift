//
//  SearchViewModel.swift
//  YRStor
//
//  Created by Huda kamal  on 03/06/2023.
//

import Foundation
class SearchViewModel{
    
    let repo : RepoProtocol?
    var bindResult : (()->()) = {}
    var viewModelResult :[Product]!{
        didSet{
            bindResult()
        }
    }
    
    init(repo: RepoProtocol?) {
        self.repo = repo
    }
    func getAllProducts(){
        repo?.getAllProducts{ res in
            guard let AllProducts = res else{return}
            self.viewModelResult = AllProducts
            
        }
    }
    
}
