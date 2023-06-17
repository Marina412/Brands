//
//  LocationViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import UIKit
import Floaty

class LocationViewController: UIViewController {
    
    @IBOutlet weak var floating: Floaty!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    var customerAddressViewModel = CustomerAddressViewModel (repo:Repo(networkManager:NetworkManager()))
    var allAddresses : AllAddress?
    var customerAuthAddress : [Address] = []
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
        self.customerAuthAddress = []
       getAllAddresses()
    }
    func getAllAddresses(){
        let defaults = UserDefaults.standard
        let customerId = defaults.integer(forKey: "customerId")
        print("customerId\(customerId)")
        var addressViewModel = CustomerAddressViewModel(repo: Repo(networkManager: NetworkManager()))
        addressViewModel.getAllAdresses(customerId:String(customerId))
        addressViewModel.bindResult = {() in
            let res = addressViewModel.viewModelResult
            guard let allAddresses = res?.addresses else {return}
            for customerAddresses in allAddresses{
                print("address id  \(customerAddresses.address1)")
                if(customerAddresses.customer_id == Int(customerId)){
                    self.customerAuthAddress.append(customerAddresses)
                    print("countt \(self.customerAuthAddress.count)")
                }
            }
            DispatchQueue.main.async{
                self.locationCollectionView.reloadData()
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
    
}
                        
                      

