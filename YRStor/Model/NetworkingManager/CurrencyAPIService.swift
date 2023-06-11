//
//  CurrencyApiService.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 05/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyAPIService{
    private let concurrentDispatchQueueScheduler:ConcurrentDispatchQueueScheduler!
    private let mainSchduler:MainScheduler!
    
    init(concurrentDispatchQueueScheduler: ConcurrentDispatchQueueScheduler! =  ConcurrentDispatchQueueScheduler(qos: .background), mainSchduler: MainScheduler! = MainScheduler.instance) {
        self.concurrentDispatchQueueScheduler = concurrentDispatchQueueScheduler
        self.mainSchduler = mainSchduler
    }
    
    func getAPIDataObservable() -> Observable<ConcurrencyModel>{
        var request = URLRequest(url: URL(string:"https://api.apilayer.com/exchangerates_data/latest?base=EGP&symbols=EGP,SAR,AED")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("BFgMvbuIH48DLJG1ldHiNeCyyoYhvOjA", forHTTPHeaderField: "apikey")
        return URLSession.shared.rx.response(request: request)
            .subscribe(on: concurrentDispatchQueueScheduler)
            .map { result -> ConcurrencyModel in
                do {
                    let exchange = try JSONDecoder().decode(
                        ConcurrencyModel.self, from: result.data
                    )
                    return exchange
                } catch let error {
                    throw error
                }
            }
    }
}
