//
//  ProfileViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var dataCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        registerCells()
    }
    private func registerCells(){
        dataCollectionView.register(UINib(nibName: "DataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DataCollectionViewCell")
    }
    @IBAction func signOutBtn(_ sender: Any) {
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
