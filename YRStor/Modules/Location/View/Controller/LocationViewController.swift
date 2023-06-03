//
//  LocationViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var locationCollectionView: UICollectionView!
    var locationSaved:[Location]=[]
    private let floatingButton :UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .black
        let image = UIImage(systemName:"plus",withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 30
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Address"
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(pressFloatingButton), for: .touchUpInside)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        locationCollectionView.collectionViewLayout=flowLayout
        registerCells()
    }
    private func registerCells(){
        locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
    }
    
    @objc private func pressFloatingButton(){
        
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

