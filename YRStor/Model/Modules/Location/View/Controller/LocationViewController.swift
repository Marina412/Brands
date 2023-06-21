//
//  LocationViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import UIKit
import Floaty
import Reachability

class LocationViewController: UIViewController {
    var reachability = try! Reachability()
    @IBOutlet weak var floating: Floaty!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    var customerAddressViewModel = CustomerAddressViewModel (repo:Repo(networkManager:NetworkManager()))
    var allAddresses : AllAddress?
    var customerAuthAddress : [Address] = []
    var checkOutItems : FavProduct = FavProduct()
    var checkOutDelegate:CheckOutDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        title = "Address"
        floating.frame = CGRect(x: 310,
                                y: 700,
                                width: 60,
                                height: 60)
        floating.addItem("Map", icon: UIImage(systemName: "map")){_ in
            let mapController=self.storyboard?.instantiateViewController(withIdentifier: "mapViewController") as! mapViewController
            self.navigationController?.pushViewController(mapController, animated: true)
            
        }
        floating.addItem("Location", icon: UIImage(systemName: "globe.europe.africa.fill")){_ in
            let locationController=self.storyboard?.instantiateViewController(withIdentifier: "EnterLocationViewController") as! EnterLocationViewController
            self.navigationController?.pushViewController(locationController, animated: true)
        }
        registerCells()
    }
    private func registerCells(){
        locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        tabBarController?.tabBar.isHidden = false
        let defaults = UserDefaults.standard
        let isLoggin = defaults.bool(forKey: "isLogging")
        defaults.set(Constant.IS_ADDRESS, forKey: "isFavOrCart")
        if (isLoggin == false){
            defaults.set(Constant.IS_ADDRESS, forKey: "isFavOrCart")
            let register = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            self.navigationController?.pushViewController(register, animated: true)
        } else{
            self.customerAuthAddress = []
            getAllAddresses()
            
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {}
    override func viewDidDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    func getAllAddresses(){
        if (reachability.connection != .unavailable){
            let defaults = UserDefaults.standard
            let customerId = defaults.integer(forKey: "customerId")
            var addressViewModel = CustomerAddressViewModel(repo: Repo(networkManager: NetworkManager()))
            addressViewModel.getAllAdresses(customerId:String(customerId))
            addressViewModel.bindResult = {() in
                let res = addressViewModel.viewModelResult
                guard let allAddresses = res?.addresses else {return}
                for customerAddresses in allAddresses{
                    if(customerAddresses.customer_id == Int(customerId)){
                        self.customerAuthAddress.append(customerAddresses)
                    }
                }
                DispatchQueue.main.async{
                    self.locationCollectionView.reloadData()
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
}
extension LocationViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customerAuthAddress.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as! LocationCollectionViewCell
        
        if indexPath.row == 0 {
            cell.removeBtnOutlet.isHidden = true
        }
        else{
            cell.removeBtnOutlet.isHidden = false
        }
        cell.addresses = customerAuthAddress
        cell.configureCell(indexPath: indexPath)
        cell.customerAddressViewModel = self.customerAddressViewModel
        cell.customerAddressViewModel?.removeBtn = { [weak self]  in
            let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this address?", preferredStyle: .alert)
            if(self?.customerAuthAddress.count == 1){
                let alertController = UIAlertController(title: "Failed", message: "you can not delete the deafult address", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
            }else{
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                    cell.customerAddressViewModel?.deleteAddress(customerId:cell.addresses[indexPath.row].customer_id ?? 0, addressId:cell.addresses[indexPath.row].id ?? 0)
                    self?.customerAuthAddress.remove(at: indexPath.item)
                    self?.locationCollectionView.reloadData()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    self?.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (locationCollectionView.frame.width - 10), height: (locationCollectionView.frame.height-5))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (reachability.connection != .unavailable){
            if (defaults.bool(forKey: "AddressShoppingCart") == true){
                defaults.set(true, forKey: "didSelectAddress")
                self.navigationController?.popViewController(animated: true)
                checkOutDelegate.getAddress(address: customerAuthAddress[indexPath.row])
            }
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
}

                        


