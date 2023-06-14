//
//  ExchangeViewModel.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 13/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class ExchangeViewModel {
    let exchangeCurrencyBehaviorSubject = BehaviorSubject<[Double]>(value: [])
    private let exchangeApiNetworkService:ExchangeApiNetwork!
    private let disposeBag:DisposeBag!
    
    init(exchangeApiNetworkService: ExchangeApiNetwork!, disposeBag: DisposeBag!) {
        self.exchangeApiNetworkService = exchangeApiNetworkService
        self.disposeBag = disposeBag
    }
    
    func getCurrency(amount:String, onError: @escaping ()->Void, onSuccuss:  @escaping()->Void) {
        if(!amount.isEmpty){
            exchangeApiNetworkService.getExChange().subscribe { exchange in
                let rates = exchange.rates
                self.exchangeCurrencyBehaviorSubject.onNext([rates.EGP,rates.USD,rates.EGP,rates.EUR,rates.SAR,rates.AED])
            }.disposed(by: disposeBag)
        }
    }
    
}
