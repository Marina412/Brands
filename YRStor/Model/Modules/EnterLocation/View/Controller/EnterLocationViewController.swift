//
//  EnterLocationViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 03/06/2023.
//

import UIKit

class EnterLocationViewController: UIViewController {
    
    @IBOutlet weak var choosenCountryLbl: UILabel!
    @IBOutlet weak var streetTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    
    @IBOutlet weak var popUpCountry: UIButton!
    @IBOutlet weak var countryTxtField: UITextField!
    var addressViewModel = CustomerAddressViewModel(repo: Repo(networkManager: NetworkManager()))
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderCountryPopButton()
    }
    func renderCountryPopButton(){
        let country = {
            [self] (action: UIAction) in
            choosenCountryLbl.text = action.title
        }
        popUpCountry.menu = UIMenu(children: [
            UIAction(title: "Choose Country",state: .on, handler: country),
            UIAction(title: "Egypt",handler: country),
            UIAction(title: "United Kingdom",handler: country),
            UIAction(title: "United States",handler: country),
            UIAction(title: "Saudi Arabia",handler: country),
            UIAction(title: "United Arab Emirates",handler: country),
 
        ])
    }
    func saveAddress(){
        let customerId = defaults.integer(forKey: "customerId")
        defaults.set(customerId, forKey: "customerId")
        var address = Address(customer_id:customerId ,address1: streetTxtField.text,country: countryTxtField.text, city: cityTxtField.text)
        var customerAddress = CustomerAddress(customer_address: address)
        addressViewModel.saveCustomerAddress(address:customerAddress, customerId: String(customerId))

    }
    @IBAction func saveAddres(_ sender: Any) {
        saveAddress()
        let alert = UIAlertController(title: "Shopify", message: "Address Added Suceesfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
}
extension EnterLocationViewController{
//    func addressAction(names:[String],closureHandler:@escaping (UIAction)->())->[UIAction]{
//        var actions :Array<UIAction>.ArrayLiteralElement?
//        names.forEach{
//            name in
//            actions.
//                .append(UIAction(title: name, handler:closureHandler))
//        }
//        return actions
//    }
}
