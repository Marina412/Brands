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
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let remote = NetworkManager()
        let repo = Repo(networkManager: remote)
        ordersVM = OrdersViewModel(repo: repo)
        registerXibCells()
        navigationBarButtons()
        ordersVM.getAllOrdersFromApi(userEmail: userDefaults.string(forKey: "email") ?? "")
        setUpOrdersCollectionView()
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            vc.order = self.ordersVM.orders[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
}

extension OrdersViewController{
    private func registerXibCells(){
        ordersCollectionView.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderCollectionViewCell")
    }
}
extension OrdersViewController{
    func navigationBarButtons(){
        self.navigationController?.navigationBar.tintColor =  #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        let profilBtn = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(self.navToProfil))
        let searchBtn = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.navToFavoriteScreen))
        navigationItem.rightBarButtonItems = [profilBtn,searchBtn]
    }
}
extension OrdersViewController{
    @objc func navToFavoriteScreen(){
        print("go to fav ")
    }
    @objc func navToProfil(){
        print("go to profil ")
    }
}


