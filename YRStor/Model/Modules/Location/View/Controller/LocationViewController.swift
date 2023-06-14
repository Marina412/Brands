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
    var locationSaved:[Location]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Address"
        floating.frame = CGRect(x: 310,
                                y: 700,
                                width: 60,
                                height: 60)
        floating.addItem("Map", icon: UIImage(systemName: "map")){_ in
            self.performSegue(withIdentifier: "MapSegue", sender: self)
        }
        floating.addItem("Location", icon: UIImage(systemName: "globe.europe.africa.fill")){_ in
            self.performSegue(withIdentifier: "LocationSegue", sender: self)
        }
       
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        locationCollectionView.collectionViewLayout=flowLayout
        registerCells()
    }
    private func registerCells(){
        locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
    }
    
    
}
extension LocationViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationSaved.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as! LocationCollectionViewCell
        cell.setup(location: locationSaved[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (locationCollectionView.bounds.width - 25), height: (locationCollectionView.bounds.height-5)/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
        // TODO add alert and delete from firebase
    }
    
    
}

