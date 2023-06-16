//
//  ExchangeViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 13/06/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ExchangeViewController: UIViewController {
    private var exchangeApiNetwork:ExchangeApiNetwork!
    private var dispose:DisposeBag!
    private var viewModel:ExchangeViewModel!
    private let currencyList = ["EGP","USD","EUR","SAR","AED"]
    override func viewDidLoad() {
        super.viewDidLoad()
        dispose = DisposeBag()
        exchangeApiNetwork = ExchangeApiNetwork()
        viewModel = ExchangeViewModel(exchangeApiNetworkService: exchangeApiNetwork, disposeBag: dispose)
    }
}
