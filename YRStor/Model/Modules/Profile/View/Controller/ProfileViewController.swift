//
//  ProfileViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var dataCollectionView: UICollectionView!
    let defaults = UserDefaults.standard
    @IBOutlet weak var emailLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        registerCells()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        emailLbl.text = defaults.string(forKey: "email")
        
    }
    private func registerCells(){
        dataCollectionView.register(UINib(nibName: "DataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DataCollectionViewCell")
    }
    @IBAction func signOutBtn(_ sender: Any) {
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
        
        switch (indexPath.row){
        case 0:
            self.performSegue(withIdentifier: "profileMyOrderSegue", sender: self)
            
        case 1:
            self.performSegue(withIdentifier: "profileLocationSegue", sender: self)
            
        case 2:
            self.performSegue(withIdentifier: "profileCurrencySegue", sender: self)
        default:
            // Todo call global alert notice that is appear from bottom
            let alert = UIAlertController(title: "Shopify", message: "Welcome to Shopify. We provide service to subject to notices, terms and condition. By shopping on this  application, you agree to all the terms and conditions in this agreement", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
