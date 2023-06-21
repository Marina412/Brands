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
        orders.removeAll()
        repo.getAllOrders { [weak self] ordersRes in
            guard let self else { return }
            guard let ordersRes else {return}
            for order in ordersRes{
                print("order befor \(order)")
                if order.userEmail == userEmail {
                    self.orders.append(order)
                    print("order in \(order)")
                }
            }
            self.ordersObservablRS.onNext(self.orders)
        }
    }
}
