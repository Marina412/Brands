//
//  EnterLocationViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 03/06/2023.
//

import UIKit

class EnterLocationViewController: UIViewController {
    
    @IBOutlet weak var StreetTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func saveAddres(_ sender: Any) {
        //Todo save address in core Data
    }
}
