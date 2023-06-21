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
    var viewModelOneResult :AllAddress??{
        didSet{
            bindOneResult()
        }
    }
    var curencyType :String = "USD"
    var rates = Rates()
    
    init(repo: RepoProtocol?) {
        self.repo = repo
        currencySetUp()
    }
    func currencySetUp(){
        curencyType =  UserDefaults.standard.string(forKey: Constant.CURRENCY) ?? "USD"
        repo?.getCurrency{
            [weak self] res in
                guard let self else { return }
                guard let res else {return}
            self.rates = res
        }
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
    func deleteAddress(customerId: Int , addressId : Int){
        repo?.deleteAddreesInDatabase(customerId: customerId, addressId: addressId)
    }
    
    func postOrder(order:PostOrders,completion: @escaping (PostOrders?)->()){
        repo?.postOrderToApi(order: order){
            res in
            completion(res)
        }
    }
}
