//
//  AuthViewModel.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import Foundation

class AuthViewModel{
    let repo : RepoProtocol?
    var bindResult : (()->()) = {}
    var viewModelResult :AllCustomers!{
        didSet{
            bindResult()
        }
    }
    
    init(repo: RepoProtocol?) {
        self.repo = repo
    }
    func saveCustomerInDatabase(customer : Customer){
        repo?.saveCustomerToDatabas(customer: customer)
        print("customer Created in view model \(customer.firstName)")
    }
    func getAllCustomers(){
        repo?.getCustomersFromDatabase{ res in
            guard let allCustomers = res else{return}
            self.viewModelResult = allCustomers
        }
    }
    
}
