//
//  HomeViewModel.swift
//  Shopify
//
//  Created by marina on 31/05/2023.
//

import Foundation
class HomeViewModel{
    let repo:RepoProtocol
        var ads:[HomeAd]=[]
        var brands:[HomeBrand]=[]
        init(repo:RepoProtocol) {
            self.repo = repo
        }

}
