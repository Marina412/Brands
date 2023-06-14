//
//  CurrencyApiService.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 05/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

class ExchangeApiNetwork {
    private let backgroundScheduler:ConcurrentDispatchQueueScheduler!
    private let mainSchduler:MainScheduler!
    
    init(backgroundScheduler: ConcurrentDispatchQueueScheduler! =  ConcurrentDispatchQueueScheduler(qos: .background), mainSchduler: MainScheduler! = MainScheduler.instance) {
        self.backgroundScheduler = backgroundScheduler
        self.mainSchduler = mainSchduler
    }
    
    func getExChange() -> Observable<Exchange>{
        var request = URLRequest(url: URL(string: Constant.CURRENCY_EXCHANGE_API_URL)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(Constant.CURRENCY_EXCHANGE_API_KEY, forHTTPHeaderField: "apikey")
        return URLSession.shared.rx.response(request: request)
            .subscribe(on: backgroundScheduler)
            .map { result -> Data in
                guard result.response.statusCode == 200 else {
                    throw Error.invalidResponse(result.response)

                }
                return result.data
            }
            .map { result in
                do {
                    let exchange = try JSONDecoder().decode(
                        Exchange.self, from: result
                    )
                    return exchange
                } catch let error {
                    throw Error.invalidJSON(error)
                }
            }.observe(on: mainSchduler).asObservable()

    }
}

private enum Error: Swift.Error {
       case invalidResponse(URLResponse?)
       case invalidJSON(Swift.Error)
}


