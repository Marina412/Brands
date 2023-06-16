//
//  EnterLocationViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 03/06/2023.
//

import UIKit

class EnterLocationViewController: UIViewController {
    
    @IBOutlet weak var streetTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    var addressViewModel = CustomerAddressViewModel(repo: Repo(networkManager: NetworkManager()))
    let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func saveAddress(){
        let customerId = defaults.integer(forKey: "customerId")
        defaults.set(6996116668723, forKey: "customerId")
        var address = Address(customer_id:customerId ,address1: streetTxtField.text,country: countryTxtField.text, city: cityTxtField.text)
        var customerAddress = CustomerAddress(customer_address: address)
        addressViewModel.saveCustomerAddress(address:customerAddress, customerId: String(customerId))

    }
    @IBAction func saveAddres(_ sender: Any) {
        saveAddress()
        let controller=self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
