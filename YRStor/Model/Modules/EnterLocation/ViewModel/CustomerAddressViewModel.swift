//
//  CustomerAddress.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 15/06/2023.
//

import Foundation

class CustomerAddressViewModel {
    var removeBtn: (()->())?
    let repo : RepoProtocol?
    var bindResult : (()->()) = {}
    var viewModelResult :AllAddress?{
        didSet{
            bindResult()
        }
    }
    var bindOneResult : (()->()) = {}
    var viewModelOneResult :[Address]?{
        didSet{
            bindOneResult()
        }
    }
    
    init(repo: RepoProtocol?) {
        self.repo = repo
    }
    
    func saveCustomerAddress(address : CustomerAddress , customerId : String){
        repo?.saveAddressToDatabase(address: address , customerId: customerId)
    }
    
    func getAllAdresses(customerId:String){
        repo?.getAllAddressFromDatabase(customerId:customerId,completion: { res in
            guard let allAddress = res else {return}
            self.viewModelResult = allAddress
        })
    }
    func getOneAddress(customerId:String){
        repo?.getONEAddressFromDatabase(customerId: customerId, completion: { res in
            guard let oneAddress = res else {return}
            self.viewModelOneResult = oneAddress
        })
    }
    func deleteAddress(customerId: Int , addressId : Int){
        repo?.deleteAddreesInDatabase(customerId: customerId, addressId: addressId)
    }
}
