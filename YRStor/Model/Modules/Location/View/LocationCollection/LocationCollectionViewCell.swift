//
//  LocationCollectionViewCell.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 02/06/2023.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var locationLbl: UILabel!
    var location:Address?
    var addresses : [Address] = []
    var customerAddressViewModel:CustomerAddressViewModel?
    @IBAction func garbagde(_ sender: Any) {
        customerAddressViewModel?.removeBtn?()
        print("clickecd")
    }
    func configureCell(indexPath : IndexPath){
        locationLbl.text = (addresses[indexPath.row].address1 ?? "") + "," +  (addresses[indexPath.row].country ?? "")
    }

}
