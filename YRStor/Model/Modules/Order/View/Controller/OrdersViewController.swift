//
//  OrdersViewController.swift
//  YRStor
//
//  Created by marina on 11/06/2023.
//

import UIKit
import RxSwift
import RxCocoa
class OrdersViewController: UIViewController {
    @IBOutlet weak var ordersCollectionView: UICollectionView!
    var ordersVM:OrdersViewModel!
    let disposeBag = DisposeBag()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorSetUp()
        let remote = NetworkManager()
        let repo = Repo(networkManager: remote)
        ordersVM = OrdersViewModel(repo: repo)
        registerXibCells()
        print( UserDefaults.standard.string(forKey: "email"))
    
        setUpOrdersCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        ordersVM.getAllOrdersFromApi(userEmail:  UserDefaults.standard.string(forKey: "email") ?? "")
        self.activityIndicator.stopAnimating()
        self.ordersCollectionView.isHidden = false
                
        
    }
}
extension OrdersViewController{
    func indicatorSetUp(){
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        ordersCollectionView.isHidden = true
    }
}
extension OrdersViewController{
    func setUpOrdersCollectionView(){
        print("setups")
        ordersVM.ordersObservablRS.bind(to: ordersCollectionView.rx.items){
            collectionView, index, item in
            let orderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderCollectionViewCell", for: IndexPath(row: index, section: 0)) as! OrderCollectionViewCell
            orderCell.cellSetUp(order: item)
            return orderCell
        }.disposed(by: disposeBag)
        
        ordersCollectionView.rx.itemSelected.subscribe (onNext:{ [weak self]
            indexPath in
            guard let self else { return }
            let orderDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            orderDetailsVC.order = self.ordersVM.orders[indexPath.row]
            self.navigationController?.pushViewController(orderDetailsVC, animated: true)
        }).disposed(by: disposeBag)
    }
}

extension OrdersViewController{
    private func registerXibCells(){
        ordersCollectionView.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderCollectionViewCell")
    }
}



