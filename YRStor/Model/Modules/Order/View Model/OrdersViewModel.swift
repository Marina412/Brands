//
//  OrdersViewModel.swift
//  YRStor
//
//  Created by marina on 11/06/2023.
//

import Foundation
import RxSwift
class OrdersViewModel{
    let repo:RepoProtocol
    var orders:[Order]=[]
    var ordersObservablRS : ReplaySubject <[Order]> = ReplaySubject<[Order]>.create(bufferSize: 10)
        init(repo:RepoProtocol) {
            self.repo = repo
        }
    func getAllOrdersFromApi(userEmail:String){
        repo.getAllOrders { [weak self] ordersRes in
            guard let self else { return }
            guard let ordersRes else {return}
            for order in ordersRes{
                if order.email?.contains(userEmail) == true{
                    self.orders.append(order)
                }
            }
            self.ordersObservablRS.onNext(self.orders)
        }
    }
}
