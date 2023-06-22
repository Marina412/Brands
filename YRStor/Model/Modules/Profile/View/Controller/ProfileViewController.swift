//
//  ProfileViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import UIKit
import Reachability

class ProfileViewController: UIViewController {
    @IBOutlet weak var dataCollectionView: UICollectionView!
    let defaults = UserDefaults.standard
    var reachability = try! Reachability()
    @IBOutlet weak var emailLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        registerCells()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        emailLbl.text = defaults.string(forKey: "email")
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
       do{
         try reachability.startNotifier()
       }catch{
         print("could not start reachability notifier")
       }
   
        self.tabBarController?.tabBar.isHidden = false
        
    }
    @objc func reachabilityChanged(note: Notification) {}

    override func viewDidDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    private func registerCells(){
        dataCollectionView.register(UINib(nibName: "DataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DataCollectionViewCell")
    }
    @IBAction func signOutBtn(_ sender: Any) {
        if (reachability.connection != .unavailable){
            let alertController = UIAlertController(title: "Shopify", message: "Are you sure you want to sign out? ", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "No", style: .cancel)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.defaults.set("", forKey: "email")
                self.defaults.set("", forKey: "password")
                self.defaults.set(0, forKey: "customerId")
                self.defaults.set(false, forKey: "isLogging")
                self.defaults.set("", forKey: "isFavOrCart")
                self.emailLbl.text = ""
                
            }
            alertController.addAction(yesAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline please Check Connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
           
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    
    @IBAction func onClickSwitch(_ sender: UISwitch) {
        if #available(iOS 13.0, *){
            let appDelegate = UIApplication.shared.windows.first
            if sender.isOn{
                appDelegate?.overrideUserInterfaceStyle = .dark
                self.navigationController?.navigationBar.tintColor = .white
                return
            }
            appDelegate?.overrideUserInterfaceStyle = .light
            self.navigationController?.navigationBar.tintColor = .black
            return
        }
        else{
        }
        
    }
}
extension ProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCollectionViewCell", for: indexPath) as! DataCollectionViewCell
        cell.setup(data: profileData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (dataCollectionView.frame.width - 10), height: (dataCollectionView.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isLoggin = defaults.bool(forKey: "isLogging")
        if (reachability.connection != .unavailable){
            switch (indexPath.row){
            case 0:
                if isLoggin{
                    self.performSegue(withIdentifier: "profileMyOrderSegue", sender: self)
                }else{
                    let alert = UIAlertController(title: "Shopify", message: "Please Sign up or Sign In in application first ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                
            case 1:
                if isLoggin{
                    self.performSegue(withIdentifier: "profileLocationSegue", sender: self)
                }else{
                   
                        let alert = UIAlertController(title: "Shopify", message: "Please Sign up or Sign In in application first ", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    
                }
                
                
            case 2:
                self.performSegue(withIdentifier: "profileCurrencySegue", sender: self)
            default:
                let alert = UIAlertController(title: "Shopify", message: "Welcome to Shopify. We provide service to subject to notices, terms and condition. By shopping on this  application, you agree to all the terms and conditions in this agreement", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
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
